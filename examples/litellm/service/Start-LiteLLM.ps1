# Avvia LiteLLM proxy (uv tool) su Windows leggendo le variabili da .env.
param(
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [int]$Port = 4000
)
$ErrorActionPreference = 'Stop'
Set-Location $WpcDir
Get-Content (Join-Path $WpcDir '.env') | Where-Object { $_ -match '^\s*[^#\s][^=]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    [Environment]::SetEnvironmentVariable($name.Trim(), $value.Trim(), 'Process')
}
& "$HOME\.local\bin\litellm.exe" --config (Join-Path $WpcDir 'config.yaml') --host 127.0.0.1 --port $Port
