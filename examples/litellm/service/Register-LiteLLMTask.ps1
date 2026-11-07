# Registra un'attività pianificata che avvia LiteLLM al login dell'utente corrente.
# Requisito: PowerShell 7 (winget install --id Microsoft.PowerShell -e) — R-agy-05, R-codex-08.
param(
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [string]$TaskName = 'WPC2026-LiteLLM'
)
$ErrorActionPreference = 'Stop'
# Percorso assoluto di pwsh.exe: il task non dipende dal PATH e fallisce subito se PowerShell 7 manca.
$pwsh   = (Get-Command pwsh.exe -ErrorAction Stop).Source
$script = Join-Path $WpcDir 'service\Start-LiteLLM.ps1'
$action  = New-ScheduledTaskAction -Execute $pwsh -Argument "-NoProfile -WindowStyle Hidden -File `"$script`" -WpcDir `"$WpcDir`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
# Avvio e continuità anche a batteria (default di Task Scheduler: non avvia e ferma a batteria).
$settings = New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) `
    -ExecutionTimeLimit ([TimeSpan]::Zero) -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Description 'LiteLLM proxy per demo WPC2026' -Force
Start-ScheduledTask -TaskName $TaskName
