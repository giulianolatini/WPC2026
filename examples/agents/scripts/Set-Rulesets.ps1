#Requires -Version 7.4
<#
.SYNOPSIS
    Crea o aggiorna i ruleset main-develop e main-release-approval a partire dai file
    versionati in .github/rulesets/ (spec 001, FR-013).

.DESCRIPTION
    - Risolve l'ID del team di emergenza e lo inserisce in bypass_actors (actor_id 0 nel file).
    - Se un ruleset con lo stesso nome esiste lo aggiorna (PUT), altrimenti lo crea (POST).
    - Richiede un token con Repository Administration: write (un maintainer, MAI
      la GitHub App contoso-copilot-agent).

.EXAMPLE
    ./scripts/Set-Rulesets.ps1 -Repository contoso/sample-app-ruleset-lab -WhatIf
    ./scripts/Set-Rulesets.ps1 -Repository contoso/sample-app
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)] [ValidatePattern('^[\w.-]+/[\w.-]+$')] [string] $Repository,
    [string] $EmergencyTeamSlug = 'release-emergency',
    [string] $RulesetDirectory = (Join-Path $PSScriptRoot '..' '.github' 'rulesets')
)

$ErrorActionPreference = 'Stop'
$org = $Repository.Split('/')[0]

# Con un errore dell'API (es. 404) `--jq '.id'` stampa "null": valida il testo prima della conversione.
$rawTeamId = gh api "orgs/$org/teams/$EmergencyTeamSlug" --jq '.id' 2>$null
if ($LASTEXITCODE -ne 0 -or "$rawTeamId" -notmatch '^\d+$') { throw "Team '$EmergencyTeamSlug' non trovato in '$org'." }
$teamId = [int]"$rawTeamId"

$existing = gh api "repos/$Repository/rulesets" --paginate | ConvertFrom-Json
if ($LASTEXITCODE -ne 0) { throw "Impossibile leggere i ruleset di $Repository." }

foreach ($file in Get-ChildItem -Path $RulesetDirectory -Filter '*.json') {
    $ruleset = Get-Content -Raw -Path $file.FullName | ConvertFrom-Json

    foreach ($actor in @($ruleset.bypass_actors)) {
        if ($actor.actor_type -eq 'Team' -and $actor.actor_id -eq 0) { $actor.actor_id = $teamId }
    }

    $body = New-TemporaryFile
    try {
        $ruleset | ConvertTo-Json -Depth 10 | Set-Content -Path $body -Encoding utf8
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
        Remove-Item $body -ErrorAction SilentlyContinue
    }
}

# Verifica: regole attive effettive sui due rami.
foreach ($branch in 'main', 'develop') {
    $types = gh api "repos/$Repository/rules/branches/$branch" --jq '.[].type' | Sort-Object -Unique
    Write-Host "$branch -> $($types -join ', ')"
}
