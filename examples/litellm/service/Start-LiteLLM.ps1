# Avvia LiteLLM proxy (uv tool) su Windows leggendo le variabili da .env.
# Il file .env è letto come coppie CHIAVE=valore, mai eseguito (AZ-08).
param(
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [int]$Port = 4000
)
$ErrorActionPreference = 'Stop'
$envFile = Join-Path $WpcDir '.env'
# AZ-01: avvisa se altri principal hanno accesso al file
$others = (Get-Acl $envFile).Access | Where-Object { $_.IdentityReference -notmatch [regex]::Escape($env:USERNAME) -and $_.IdentityReference -notmatch 'SYSTEM|Administrators' }
if ($others) { Write-Warning ".env è accessibile ad altri utenti. Esegui: icacls `"$envFile`" /inheritance:r /grant:r `"${env:USERNAME}:R`"" }
Set-Location $WpcDir
Get-Content $envFile | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    $value = $value.Trim().Trim('"').Trim("'")
    [Environment]::SetEnvironmentVariable($name.Trim(), $value, 'Process')
}
& "$HOME\.local\bin\litellm.exe" --config (Join-Path $WpcDir 'config.yaml') --host 127.0.0.1 --port $Port
