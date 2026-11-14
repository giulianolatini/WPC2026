#Requires -Version 7.4
<#
.SYNOPSIS
    Crea o aggiorna i ruleset main-develop, main-release-approval e develop-approval a partire dai file
    versionati in .github/rulesets/ (spec 001, FR-013).

.DESCRIPTION
    - Risolve l'ID del team di emergenza e lo inserisce in bypass_actors (actor_id 0 nel file).
    - Con -WithoutEmergencyTeam (account personale, nessun team) toglie l'attore di bypass:
      nessuno può aggirare i ruleset.
    - Se un ruleset con lo stesso nome esiste lo aggiorna (PUT), altrimenti lo crea (POST).
    - Richiede un token con Repository Administration: write (un maintainer, MAI
      la GitHub App contoso-copilot-agent).

.EXAMPLE
    ./scripts/Set-Rulesets.ps1 -Repository contoso/sample-app-ruleset-lab -WhatIf
    ./scripts/Set-Rulesets.ps1 -Repository contoso/sample-app
    ./scripts/Set-Rulesets.ps1 -Repository octocat/sample-app -WithoutEmergencyTeam
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [ValidatePattern('^[\w.-]+/[\w.-]+$')] [string] $Repository,
    [string] $EmergencyTeamSlug = 'release-emergency',
    # Account personale o organizzazione senza team di emergenza: nessun attore di bypass.
    [switch] $WithoutEmergencyTeam,
    [string] $RulesetDirectory = (Join-Path $PSScriptRoot '..' '.github' 'rulesets')
)

$ErrorActionPreference = 'Stop'
$org = $Repository.Split('/')[0]

$teamId = 0
if (-not $WithoutEmergencyTeam) {
    # Con un errore dell'API (es. 404) `--jq '.id'` stampa "null": valida il testo prima della conversione.
    $rawTeamId = gh api "orgs/$org/teams/$EmergencyTeamSlug" --jq '.id' 2>$null
    if ($LASTEXITCODE -ne 0 -or "$rawTeamId" -notmatch '^\d+$') {
        throw "Team '$EmergencyTeamSlug' non trovato in '$org'. Per un account personale usa -WithoutEmergencyTeam."
    }
    $teamId = [int]"$rawTeamId"
}

$rawExisting = gh api "repos/$Repository/rulesets" --paginate
if ($LASTEXITCODE -ne 0) { throw "Impossibile leggere i ruleset di $Repository." }
$existing = @($rawExisting | ConvertFrom-Json)

foreach ($file in Get-ChildItem -Path $RulesetDirectory -Filter '*.json') {
    $ruleset = Get-Content -Raw -Path $file.FullName | ConvertFrom-Json

    if ($WithoutEmergencyTeam) {
        # Toglie il segnaposto del team: il ruleset resta senza attori di bypass.
        $ruleset.bypass_actors = @($ruleset.bypass_actors | Where-Object { -not ($_.actor_type -eq 'Team' -and $_.actor_id -eq 0) })
    }
    else {
        foreach ($actor in @($ruleset.bypass_actors)) {
            if ($actor.actor_type -eq 'Team' -and $actor.actor_id -eq 0) { $actor.actor_id = $teamId }
        }
    }

    # API .NET per il file temporaneo: New-TemporaryFile, Set-Content e Remove-Item non fanno nulla con -WhatIf.
    $body = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($body, ($ruleset | ConvertTo-Json -Depth 10))
        $match = $existing | Where-Object name -EQ $ruleset.name | Select-Object -First 1

        if ($match) {
            if ($PSCmdlet.ShouldProcess("$Repository ruleset '$($ruleset.name)' (id $($match.id))", 'PUT')) {
                gh api -X PUT "repos/$Repository/rulesets/$($match.id)" --input $body | Out-Null
                if ($LASTEXITCODE -ne 0) { throw "Aggiornamento di '$($ruleset.name)' fallito." }
            }
        }
        elseif ($PSCmdlet.ShouldProcess("$Repository ruleset '$($ruleset.name)'", 'POST')) {
            gh api -X POST "repos/$Repository/rulesets" --input $body | Out-Null
            if ($LASTEXITCODE -ne 0) { throw "Creazione di '$($ruleset.name)' fallita." }
        }
    }
    finally {
        [System.IO.File]::Delete($body)
    }
}

# Verifica: regole attive effettive sui due rami. Con -WhatIf nessun ruleset è stato applicato: niente verifica.
if ($WhatIfPreference) { return }
foreach ($branch in 'main', 'develop') {
    $rawTypes = gh api "repos/$Repository/rules/branches/$branch" --jq '.[].type'
    if ($LASTEXITCODE -ne 0) { throw "Impossibile leggere le regole del ramo '$branch'." }
    $types = $rawTypes | Sort-Object -Unique
    Write-Host "$branch -> $($types -join ', ')"
}
