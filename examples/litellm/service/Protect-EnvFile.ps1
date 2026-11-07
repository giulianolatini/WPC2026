# Limita .env al solo utente corrente (equivalente di chmod 600) — AZ-01, R-codex-01.
# Rimuove le regole ereditate e tutte le regole esplicite, poi concede Read+Write solo all'utente corrente.
param([string]$Path = (Join-Path "$HOME\wpc2026-litellm" '.env'))
$ErrorActionPreference = 'Stop'
$me  = [System.Security.Principal.WindowsIdentity]::GetCurrent().User
$acl = Get-Acl -LiteralPath $Path
$acl.SetAccessRuleProtection($true, $false)          # niente ereditarietà, niente copia delle regole ereditate
foreach ($rule in @($acl.Access)) { [void]$acl.RemoveAccessRule($rule) }
$acl.AddAccessRule([System.Security.AccessControl.FileSystemAccessRule]::new($me, 'Read,Write', 'Allow'))
Set-Acl -LiteralPath $Path -AclObject $acl
Write-Output "ACL di $Path limitata a $($me.Translate([System.Security.Principal.NTAccount]))"
