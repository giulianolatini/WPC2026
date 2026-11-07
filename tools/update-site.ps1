# Rigenera il sito offline site/ dal runbook (docs/runbook/RUNBOOK.md) e dai documenti in docs/.
# Uso:  .\tools\update-site.ps1            rigenera HTML, CSS e JS
#       .\tools\update-site.ps1 -Fonts     scarica i Nerd Font dalla release, li converte in WOFF2, poi rigenera
#       .\tools\update-site.ps1 -Check     esce con codice 1 se il sito non è aggiornato
# Requisiti: PowerShell 7 e uv (runbook S-102, S-104).
param([switch]$Fonts, [switch]$Check)
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root
$PyMd = @('--with', 'markdown==3.11.*')
$PyFonts = @('--with', 'fonttools==4.67.*', '--with', 'brotli==1.2.*')
$Cache = Join-Path $Root '.cache\nerd-fonts'      # nel repo, ignorata da git

if ($Check) {
    uv run --no-project --python 3.12 @PyMd python -I tools/build_site.py --check
    exit $LASTEXITCODE
}

if ($Fonts) {
    $cfg = Get-Content tools/fonts.json -Raw | ConvertFrom-Json
    New-Item -ItemType Directory -Force $Cache | Out-Null
    foreach ($f in $cfg.families) {
        $name = [IO.Path]::GetFileNameWithoutExtension($f.zip)
        $zip = Join-Path $Cache $f.zip
        $dest = Join-Path $Cache $name
        Write-Output "Scarico $($f.zip)"
        Invoke-WebRequest -Uri ($cfg.release + $f.zip) -OutFile $zip -MaximumRetryCount 2
        # Release fissata e sha256 di ogni zip in tools/fonts.json: un file diverso ferma lo script (R4-agy-04)
        $got = (Get-FileHash -Algorithm SHA256 $zip).Hash.ToLowerInvariant()
        if ($got -ne $f.sha256) { Remove-Item $zip; throw "sha256 NON valido per $($f.zip): $got (atteso $($f.sha256))" }
        if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }
        # Ogni zip si estrae in una cartella propria: i file scaricati sono dati non fidati.
        Expand-Archive -Path $zip -DestinationPath $dest -Force
    }
    uv run --no-project --python 3.12 @PyFonts python -I tools/fonts.py $Cache
    if ($LASTEXITCODE) { exit $LASTEXITCODE }
}

uv run --no-project --python 3.12 @PyMd python -I tools/build_site.py
if ($LASTEXITCODE) { exit $LASTEXITCODE }
Write-Output 'Apri site\index.html nel browser (funziona anche offline, da file://).'
