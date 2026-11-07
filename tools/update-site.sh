#!/usr/bin/env bash
# Rigenera il sito offline site/ dal runbook (docs/runbook/RUNBOOK.md) e dai documenti in docs/.
# Uso:  tools/update-site.sh            rigenera HTML, CSS e JS
#       tools/update-site.sh --fonts    scarica i Nerd Font dalla release, li converte in WOFF2, poi rigenera
#       tools/update-site.sh --check    esce con codice 1 se il sito non è aggiornato (es. prima del commit)
# Requisiti: uv (docs/01 §3.2 / runbook S-104); con --fonts anche curl e unzip.
# Su Windows usa tools/update-site.ps1.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
PY_MD=(--with 'markdown==3.11.*')
PY_FONTS=(--with 'fonttools==4.67.*' --with 'brotli==1.2.*')
CACHE="$ROOT/.cache/nerd-fonts"          # nel repo, ignorata da git

fonts=0; check=0
for a in "$@"; do
  case "$a" in
    --fonts) fonts=1 ;;
    --check) check=1 ;;
    -h|--help) sed -n 2,7p "$0"; exit 0 ;;
    *) echo "Opzione sconosciuta: $a" >&2; exit 2 ;;
  esac
done

if [ "$check" = 1 ]; then
  exec uv run --no-project "${PY_MD[@]}" python tools/build_site.py --check
fi

if [ "$fonts" = 1 ]; then
  release="$(uv run --no-project python -c 'import json;print(json.load(open("tools/fonts.json"))["release"])')"
  mkdir -p "$CACHE"
  # Ogni zip si estrae in una cartella propria: i file scaricati sono dati non fidati.
  for zip in $(uv run --no-project python -c 'import json;print(" ".join(f["zip"] for f in json.load(open("tools/fonts.json"))["families"]))'); do
    name="${zip%.zip}"
    echo "Scarico $zip"
    curl -fsSL --retry 2 -o "$CACHE/$zip" "$release$zip"
    rm -rf "${CACHE:?}/$name" && mkdir -p "$CACHE/$name"
    unzip -q -o "$CACHE/$zip" -d "$CACHE/$name"
  done
  uv run --no-project "${PY_FONTS[@]}" python -I tools/fonts.py "$CACHE"
fi

uv run --no-project "${PY_MD[@]}" python -I tools/build_site.py
echo "Apri site/index.html nel browser (funziona anche offline, da file://)."
