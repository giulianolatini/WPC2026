#Requires -Version 7.4
#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '6.2.0' }
<#
.SYNOPSIS
    Verifica che la GitHub App contoso-copilot-agent non possa aggirare il ruleset
    di main/develop con `gh pr merge --admin` (spec 001, US4, FR-011, FR-017).

.NOTES
    Esegue merge REALI. Lanciare solo da .github/workflows/verify-ruleset-admin.yml.
    I rifiuti V1-V3 sono validi solo se anche lo stato delle PR di test e V4 sono superati:
    se uno di questi test fallisce, l'intera esecuzione non è valida.
    Un merge (V1-V4) parte solo se il controllo di stato della sua PR è superato; altrimenti il test è Skipped.
    Escluso dalla CI ordinaria con: Invoke-Pester -ExcludeTagFilter Live
    Variabili richieste: GH_TOKEN, RULESET_REPO, PR_MAIN, PR_DEVELOP_RED,
    PR_DEVELOP_GREEN, RULESET_ID.
#>

Describe 'Ruleset main/develop con contoso-copilot-agent' -Tag 'Live', 'AdminBypass' {
    # Setup dentro il Describe con tag Live: non viene eseguito quando la CI esclude 'Live'.
    BeforeAll {
        $script:Repo     = $env:RULESET_REPO
        $script:Evidence = [System.Collections.Generic.List[object]]::new()
        # Una PR di test entra qui solo se il suo stato è quello previsto: i merge partono solo per queste PR.
        $script:FixtureOk = @{}

        foreach ($name in 'GH_TOKEN', 'RULESET_REPO', 'PR_MAIN', 'PR_DEVELOP_RED', 'PR_DEVELOP_GREEN', 'RULESET_ID') {
            if (-not [Environment]::GetEnvironmentVariable($name)) {
                throw "Variabile d'ambiente mancante: $name"
            }
        }

        # Messaggi che indicano un problema di token/permessi, non un rifiuto del ruleset.
        $script:AuthErrorPattern = 'HTTP 401|Bad credentials|Resource not accessible by integration'

        function Invoke-Gh {
            param([Parameter(Mandatory)][string[]] $Arguments, [string] $Case, [string] $PrNumber)
            # Un exit code ≠ 0 è un esito atteso: non deve interrompere il test.
            $ErrorActionPreference = 'Continue'
            $output   = & gh @Arguments 2>&1 | Out-String
            $exitCode = $LASTEXITCODE
            # Stato della PR dopo il comando: fa parte dell'evidenza (contratto, sezione Output).
            $prState  = if ($PrNumber) { Get-PrState -Number $PrNumber } else { $null }
            $script:Evidence.Add([pscustomobject]@{
                case     = $Case
                command  = "gh $($Arguments -join ' ')"
                exitCode = $exitCode
                output   = $output.Trim()
                prState  = $prState
            })
            [pscustomobject]@{ ExitCode = $exitCode; Output = $output }
        }

        function Get-PrState {
            param([Parameter(Mandatory)][string] $Number)
            (& gh pr view $Number --repo $script:Repo --json state --jq '.state').Trim()
        }

        # Tutti e tre i check obbligatori devono esistere ed essere verdi: un elenco vuoto non basta.
        function Test-RequiredChecksGreen {
            param($Facts)
            foreach ($name in 'build', 'test-dotnet', 'test-powershell') {
                $check = @($Facts.statusCheckRollup | Where-Object { $_.name -eq $name })
                if ($check.Count -eq 0 -or $check[0].conclusion -ne 'SUCCESS') { return $false }
            }
            $true
        }

        # Commit del ramo base che mancano nel ramo della PR: con la policy strict una PR non aggiornata
        # viene rifiutata per questo motivo, non per la regola che il test vuole provare.
        function Get-BehindBy {
            param($Facts)
            $raw = & gh api "repos/$script:Repo/compare/$($Facts.baseRefName)...$($Facts.headRefName)" --jq '.behind_by'
            if ($LASTEXITCODE -ne 0) { throw "Impossibile confrontare $($Facts.headRefName) con $($Facts.baseRefName)." }
            [int]"$raw"
        }

        # Stato della PR di test: serve per attribuire il rifiuto alla regola giusta.
        function Get-PrFacts {
            param([Parameter(Mandatory)][string] $Number)
            $raw = & gh pr view $Number --repo $script:Repo --json state,baseRefName,headRefName,mergeable,reviewDecision,statusCheckRollup
            if ($LASTEXITCODE -ne 0) { throw "Impossibile leggere la PR $Number." }
            $raw | ConvertFrom-Json
        }
    }

    AfterAll {
        $script:Evidence | ConvertTo-Json -Depth 4 |
            Set-Content -Path (Join-Path $PWD 'ruleset-admin-evidence.json') -Encoding utf8
    }


    Context 'Precondizioni' {
        It 'main ha le regole attive pull_request, required_status_checks, non_fast_forward, deletion' {
            $types = & gh api "repos/$script:Repo/rules/branches/main" --jq '.[].type'
            foreach ($t in 'pull_request', 'required_status_checks', 'non_fast_forward', 'deletion') {
                $types | Should -Contain $t
            }
        }

        It 'main richiede l''approvazione di un code owner (ruleset main-release-approval attivo)' {
            $required = & gh api "repos/$script:Repo/rules/branches/main" --jq '[.[] | select(.type == "pull_request") | .parameters.require_code_owner_review] | any'
            $LASTEXITCODE | Should -Be 0
            "$required"   | Should -Be 'true'
        }

        It 'develop ha le regole attive pull_request, required_status_checks, non_fast_forward, deletion' {
            $types = & gh api "repos/$script:Repo/rules/branches/develop" --jq '.[].type'
            foreach ($t in 'pull_request', 'required_status_checks', 'non_fast_forward', 'deletion') {
                $types | Should -Contain $t
            }
        }
    }

    # Ordine: prima lo stato delle PR, poi i rifiuti, poi V4. V4 fa avanzare develop: eseguito prima
    # renderebbe non aggiornata la PR di V3, che sarebbe rifiutata per un motivo diverso dal check fallito.
    Context 'Stato delle PR di test (attribuisce il rifiuto alla regola giusta)' {
        It 'PR_MAIN: aperta, verso main, senza conflitti, check verdi, senza approvazione' {
            $f = Get-PrFacts -Number $env:PR_MAIN
            $f.state          | Should -Be 'OPEN'
            $f.baseRefName    | Should -Be 'main'
            $f.mergeable      | Should -Be 'MERGEABLE'
            Get-BehindBy -Facts $f | Should -Be 0 -Because 'la PR deve contenere tutti i commit del ramo base'
            $f.reviewDecision | Should -Not -Be 'APPROVED'
            Test-RequiredChecksGreen -Facts $f |
                Should -BeTrue -Because 'con i tre check verdi l''unico requisito mancante è l''approvazione del code owner'
            $script:FixtureOk['PR_MAIN'] = $true
        }

        It 'PR_DEVELOP_RED: aperta, verso develop, senza conflitti, test-dotnet fallito' {
            $f = Get-PrFacts -Number $env:PR_DEVELOP_RED
            $f.state       | Should -Be 'OPEN'
            $f.baseRefName | Should -Be 'develop'
            $f.mergeable   | Should -Be 'MERGEABLE'
            Get-BehindBy -Facts $f | Should -Be 0 -Because 'la PR deve contenere tutti i commit del ramo base'
            $failed = @($f.statusCheckRollup | Where-Object { $_.name -eq 'test-dotnet' })
            $failed.Count         | Should -BeGreaterThan 0 -Because 'il check test-dotnet deve essere stato eseguito'
            $failed[0].conclusion | Should -Be 'FAILURE'
            $script:FixtureOk['PR_DEVELOP_RED'] = $true
        }

        It 'PR_DEVELOP_GREEN: aperta, verso develop, senza conflitti, check verdi' {
            $f = Get-PrFacts -Number $env:PR_DEVELOP_GREEN
            $f.state       | Should -Be 'OPEN'
            $f.baseRefName | Should -Be 'develop'
            $f.mergeable   | Should -Be 'MERGEABLE'
            Get-BehindBy -Facts $f | Should -Be 0 -Because 'la PR deve contenere tutti i commit del ramo base'
            Test-RequiredChecksGreen -Facts $f | Should -BeTrue -Because 'i tre check obbligatori devono esistere ed essere verdi'
            $script:FixtureOk['PR_DEVELOP_GREEN'] = $true
        }
    }

    Context 'Tentativi di bypass che devono fallire' {
        It 'V1 - merge senza approvazione verso main viene rifiutato' {
            if (-not $script:FixtureOk['PR_MAIN']) { Set-ItResult -Skipped -Because 'lo stato della PR di test non è quello previsto: nessun merge viene tentato'; return }
            $r = Invoke-Gh -Case 'V1' -PrNumber $env:PR_MAIN -Arguments @('pr', 'merge', $env:PR_MAIN, '--repo', $script:Repo, '--merge')
            $r.Output   | Should -Not -Match $script:AuthErrorPattern -Because 'un errore di autenticazione rende il test non valido'
            $r.ExitCode | Should -Not -Be 0
            Get-PrState -Number $env:PR_MAIN | Should -Be 'OPEN'
        }

        It 'V2 - merge con --admin verso main viene rifiutato' {
            if (-not $script:FixtureOk['PR_MAIN']) { Set-ItResult -Skipped -Because 'lo stato della PR di test non è quello previsto: nessun merge viene tentato'; return }
            $r = Invoke-Gh -Case 'V2' -PrNumber $env:PR_MAIN -Arguments @('pr', 'merge', $env:PR_MAIN, '--repo', $script:Repo, '--merge', '--admin')
            $r.Output   | Should -Not -Match $script:AuthErrorPattern -Because 'un errore di autenticazione rende il test non valido'
            $r.ExitCode | Should -Not -Be 0 -Because 'contoso-copilot-agent non deve essere un attore di bypass (FR-010, FR-011)'
            Get-PrState -Number $env:PR_MAIN | Should -Be 'OPEN'
        }

        It 'V3 - merge con --admin verso develop con check fallito viene rifiutato' {
            if (-not $script:FixtureOk['PR_DEVELOP_RED']) { Set-ItResult -Skipped -Because 'lo stato della PR di test non è quello previsto: nessun merge viene tentato'; return }
            $r = Invoke-Gh -Case 'V3' -PrNumber $env:PR_DEVELOP_RED -Arguments @('pr', 'merge', $env:PR_DEVELOP_RED, '--repo', $script:Repo, '--merge', '--admin')
            $r.Output   | Should -Not -Match $script:AuthErrorPattern -Because 'un errore di autenticazione rende il test non valido'
            $r.ExitCode | Should -Not -Be 0
            Get-PrState -Number $env:PR_DEVELOP_RED | Should -Be 'OPEN'
        }
    }

    Context 'Controllo positivo (rende validi i rifiuti precedenti)' {
        It 'V4 - merge di una PR conforme verso develop riesce' {
            if (-not $script:FixtureOk['PR_DEVELOP_GREEN']) { Set-ItResult -Skipped -Because 'lo stato della PR di test non è quello previsto: nessun merge viene tentato'; return }
            $r = Invoke-Gh -Case 'V4' -PrNumber $env:PR_DEVELOP_GREEN -Arguments @('pr', 'merge', $env:PR_DEVELOP_GREEN, '--repo', $script:Repo, '--merge')
            $r.ExitCode | Should -Be 0 -Because "il token deve poter fare merge di PR conformi, altrimenti V1-V3 non sono validi e l'intera esecuzione va ripetuta. Output: $($r.Output)"
        }
    }

    Context 'Permessi sul ruleset' {
        It 'V5 - l''app non vede bypass_actors (nessun accesso in scrittura al ruleset)' {
            $raw      = & gh api "repos/$script:Repo/rulesets/$env:RULESET_ID"
            $exitCode = $LASTEXITCODE
            $script:Evidence.Add([pscustomobject]@{
                case     = 'V5'
                command  = "gh api repos/$script:Repo/rulesets/$env:RULESET_ID"
                exitCode = $exitCode
                output   = ($raw | Out-String).Trim()
                prState  = $null
            })
            $exitCode | Should -Be 0 -Because "la lettura del ruleset deve riuscire: un errore dell'API non prova nulla. Output: $raw"
            $json = $raw | ConvertFrom-Json
            "$($json.id)" | Should -Be $env:RULESET_ID
            $json.name    | Should -Be 'main-release-approval'
            $json.PSObject.Properties.Name | Should -Not -Contain 'bypass_actors'
        }
    }
}
