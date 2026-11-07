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
  exec uv run --no-project --python 3.12 "${PY_MD[@]}" python -I tools/build_site.py --check
fi

if [ "$fonts" = 1 ]; then
  release="$(uv run --no-project --python 3.12 python -I -c 'import json;print(json.load(open("tools/fonts.json"))["release"])')"
  mkdir -p "$CACHE"
  # Release fissata e sha256 di ogni zip in tools/fonts.json: un file diverso ferma lo script (R4-agy-04).
  # Ogni zip si estrae in una cartella propria: i file scaricati sono dati non fidati.
  uv run --no-project --python 3.12 python -I -c 'import json;[print(f["zip"], f["sha256"]) for f in json.load(open("tools/fonts.json"))["families"]]' |
  while read -r zip sha; do
    name="${zip%.zip}"
    echo "Scarico $zip"
    curl -fsSL --retry 2 -o "$CACHE/$zip" "$release$zip"
    got="$( (sha256sum "$CACHE/$zip" 2>/dev/null || shasum -a 256 "$CACHE/$zip") | awk '{print $1}')"
    if [ "$got" != "$sha" ]; then
      echo "sha256 NON valido per $zip: $got (atteso $sha)" >&2; rm -f "$CACHE/$zip"; exit 1
    fi
    rm -rf "${CACHE:?}/$name" && mkdir -p "$CACHE/$name"
    unzip -q -o "$CACHE/$zip" -d "$CACHE/$name"
  done
  uv run --no-project --python 3.12 "${PY_FONTS[@]}" python -I tools/fonts.py "$CACHE"
fi

uv run --no-project --python 3.12 "${PY_MD[@]}" python -I tools/build_site.py
echo "Apri site/index.html nel browser (funziona anche offline, da file://)."
