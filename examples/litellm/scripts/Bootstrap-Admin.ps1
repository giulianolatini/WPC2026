# AZ-04 su Windows (R-codex-12): crea il primo utente proxy_admin con password (profilo esteso).
# Equivalente di bootstrap-admin.sh. Richiede PowerShell 7 (docs/01 §3.2).
# L'API accetta la master key anche con disable_env_credential_login: true (docs/Sources.md#s-148).
# Uso: .\scripts\Bootstrap-Admin.ps1 -AdminEmail tu@example.com [-AdminId wpc-admin] [-Resume]
param(
    [string]$AdminId = 'wpc-admin',
    [string]$AdminEmail,
    [string]$WpcDir = "$HOME\wpc2026-litellm",
    [string]$ProxyUrl,
    [switch]$Resume          # salta /user/new e ripete solo l'impostazione della password
)
$ErrorActionPreference = 'Stop'
if (-not $Resume -and -not $AdminEmail) { throw 'Imposta -AdminEmail' }

# .env letto come CHIAVE=valore (mai eseguito); toglie solo una coppia di virgolette esterne uguali.
$cfg = @{}
Get-Content (Join-Path $WpcDir '.env') | Where-Object { $_ -match '^\s*[A-Za-z_][A-Za-z0-9_]*=' } | ForEach-Object {
    $name, $value = $_ -split '=', 2
    $value = $value.Trim()
    if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") { $value = $Matches[1] }
    $cfg[$name.Trim()] = $value
}
if (-not $cfg['LITELLM_MASTER_KEY']) { throw 'LITELLM_MASTER_KEY vuota in .env' }
if (-not $ProxyUrl) { $ProxyUrl = "http://localhost:$(if ($cfg['LITELLM_PORT']) { $cfg['LITELLM_PORT'] } else { 4000 })" }

$secure = Read-Host "Password per $AdminId" -AsSecureString
$password = [System.Net.NetworkCredential]::new('', $secure).Password
# Policy password LiteLLM controllata PRIMA di ogni chiamata API.
if (-not ($password.Length -ge 12 -and $password -cmatch '[A-Z]' -and $password -cmatch '[a-z]' -and
          $password -match '[0-9]' -and $password -match '[^A-Za-z0-9]')) {
    throw 'Password non valida: minimo 12 caratteri con maiuscole, minuscole, cifre e simboli.'
}

# Header come hashtable: la master key non compare negli argomenti di un processo esterno.
$headers = @{ Authorization = "Bearer $($cfg['LITELLM_MASTER_KEY'])" }
if (-not $Resume) {
    $body = @{ user_id = $AdminId; user_email = $AdminEmail; user_role = 'proxy_admin'; auto_create_key = $false } | ConvertTo-Json -Compress
    try { Invoke-RestMethod -Method Post -Uri "$ProxyUrl/user/new" -Headers $headers -ContentType 'application/json' -Body $body | Out-Null }
    catch { throw "Creazione fallita: $($_.Exception.Message). Se l'utente '$AdminId' esiste già, ripeti con -Resume." }
}
$body = @{ user_id = $AdminId; user_role = 'proxy_admin'; password = $password } | ConvertTo-Json -Compress
try { Invoke-RestMethod -Method Post -Uri "$ProxyUrl/user/update" -Headers $headers -ContentType 'application/json' -Body $body | Out-Null }
catch { throw "Impostazione della password fallita: $($_.Exception.Message). Ripeti con -Resume." }
Write-Output "proxy_admin '$AdminId' pronto. Verifica il login su $ProxyUrl/ui con email e password."
