# Avvia LiteLLM proxy (uv tool) su Windows leggendo le variabili da .env.
# Il file .env è letto come coppie CHIAVE=valore, mai eseguito (AZ-08).
param(
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [int]$Port = 0      # 0 = usa LITELLM_PORT da .env, altrimenti 4000 (R-agy-05)
)
$ErrorActionPreference = 'Stop'
$envFile = Join-Path $WpcDir '.env'
# AZ-01 (R-codex-01): termina se un principal diverso da utente corrente, SYSTEM o Administrators
# ha accesso al file. Confronto per SID esatto, non per sottostringa del nome.
$allowed = @(
    [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value,
    'S-1-5-18',      # LocalSystem
    'S-1-5-32-544'   # BUILTIN\Administrators
)
$unsafe = foreach ($rule in (Get-Acl -LiteralPath $envFile).Access) {
    if ($rule.AccessControlType -ne 'Allow') { continue }
    try { $sid = $rule.IdentityReference.Translate([System.Security.Principal.SecurityIdentifier]).Value }
    catch { $sid = $rule.IdentityReference.Value }
    if ($allowed -notcontains $sid) { $rule.IdentityReference.Value }
}
if ($unsafe) {
    Write-Error (".env è accessibile a: {0}. Esegui service\Protect-EnvFile.ps1 e riprova." -f (($unsafe | Select-Object -Unique) -join ', '))
    exit 1
}
Set-Location $WpcDir
Get-Content $envFile | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    $value = $value.Trim()
    # Rimuove solo una coppia di virgolette esterne uguali, come load-env.sh (R-agy-14)
    if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") { $value = $Matches[1] }
    [Environment]::SetEnvironmentVariable($name.Trim(), $value, 'Process')
}
if (-not $env:LITELLM_MASTER_KEY) { Write-Error 'LITELLM_MASTER_KEY vuota in .env'; exit 1 }   # fail-closed (R-agy-01)
if ($Port -eq 0) { $Port = if ($env:LITELLM_PORT) { [int]$env:LITELLM_PORT } else { 4000 } }
& "$HOME\.local\bin\litellm.exe" --config (Join-Path $WpcDir 'config.yaml') --host 127.0.0.1 --port $Port
# R-codex-05: propaga il codice di uscita, così Task Scheduler vede il fallimento e applica RestartCount.
exit $LASTEXITCODE
