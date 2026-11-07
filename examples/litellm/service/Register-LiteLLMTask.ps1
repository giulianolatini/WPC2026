# Registra un'attività pianificata che avvia LiteLLM al login dell'utente corrente.
param(
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [string]$TaskName = 'WPC2026-LiteLLM'
)
$script = Join-Path $WpcDir 'service\Start-LiteLLM.ps1'
$action  = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument "-NoProfile -WindowStyle Hidden -File `"$script`" -WpcDir `"$WpcDir`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
$settings = New-ScheduledTaskSettingsSet -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 1) -ExecutionTimeLimit ([TimeSpan]::Zero)
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Description 'LiteLLM proxy per demo WPC2026' -Force
Start-ScheduledTask -TaskName $TaskName
