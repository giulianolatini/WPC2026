#!/usr/bin/env python3
"""Converte i Nerd Font (TTF/OTF) in WOFF2 per il sito offline e genera fonts.css + fonts-manifest.json.

Uso: python3 tools/fonts.py <cartella-sorgenti> [<cartella-sorgenti> ...]
Le cartelle possono contenere gli zip di release estratti o la struttura patched-fonts/ del repository Nerd Fonts.
Le famiglie non trovate restano quelle già presenti in site/assets/fonts (nessuna cancellazione).
Requisiti: fonttools, brotli (es. uv run --with fonttools --with brotli python tools/fonts.py ...).
"""
import fnmatch, json, os, shutil, sys
from pathlib import Path
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parent.parent
CFG = json.loads((ROOT / "tools" / "fonts.json").read_text(encoding="utf-8"))
OUT = ROOT / "site" / "assets" / "fonts"
LIC = OUT / "LICENSES"

def find(sources, pattern):
    hits = []
    for src in sources:
        for dirpath, _, files in os.walk(src):
            hits += [Path(dirpath) / f for f in files if fnmatch.fnmatch(f, pattern)]
    return sorted(hits, key=lambda p: len(str(p)))[0] if hits else None

def find_license(font_file: Path, patterns, sources):
    """Cerca la licenza nella cartella del font e nelle cartelle padre, senza uscire dalla sorgente."""
    roots = [s.resolve() for s in sources]
    d = font_file.parent.resolve()
    while True:
        for pattern in patterns:
            for f in sorted(d.iterdir()):
                if f.is_file() and fnmatch.fnmatch(f.name, pattern):
                    return f
        if d in roots or d.parent == d:
            return None
        d = d.parent

def to_woff2(src: Path, dst: Path):
    font = TTFont(src, recalcTimestamp=False)  # output riproducibile: head.modified non cambia
    font.flavor = "woff2"
    dst.parent.mkdir(parents=True, exist_ok=True)
    font.save(dst)

def main(sources):
    OUT.mkdir(parents=True, exist_ok=True); LIC.mkdir(parents=True, exist_ok=True)
    done = []
    for fam in CFG["families"]:
        first = None
        for role in ("mono", "body"):
            for weight, pattern in fam.get(role, {}).items():
                src = find(sources, pattern)
                if not src:
                    continue
                first = first or src
                dst = OUT / f"{fam['id']}-{role}-{weight}.woff2"
                to_woff2(src, dst)
                done.append(f"{dst.name} <- {src.name}")
        if first:
            lic = find_license(first, fam.get("license", []), sources)
            if lic:
                shutil.copyfile(lic, LIC / f"{fam['id']}-LICENSE.txt")
                done.append(f"{fam['id']}-LICENSE.txt <- {lic}")
            else:
                done.append(f"ATTENZIONE: licenza non trovata per {fam['id']}")
    write_css_manifest()
    print("\n".join(done) or "Nessun font trovato nelle sorgenti indicate.")

def write_css_manifest():
    """Rigenera fonts.css e il manifest dai file WOFF2 presenti (anche quelli di esecuzioni precedenti)."""
    css, manifest = [], []
    for fam in CFG["families"]:
        entry = {"id": fam["id"], "label": fam["label"], "mono": False, "body": False}
        for role in ("mono", "body"):
            for weight in ("400", "700"):
                f = OUT / f"{fam['id']}-{role}-{weight}.woff2"
                if f.exists():
                    entry[role] = True
                    css.append("@font-face{font-family:'%s-%s';src:url('fonts/%s') format('woff2');"
                               "font-weight:%s;font-style:normal;font-display:swap}" % (fam["id"], role, f.name, weight))
        if entry["mono"] or entry["body"]:
            manifest.append(entry)
    (OUT.parent / "fonts.css").write_text("\n".join(css) + "\n", encoding="utf-8")
    (OUT.parent / "fonts-manifest.json").write_text(json.dumps(manifest, indent=2), encoding="utf-8")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        write_css_manifest(); print("Solo rigenerazione di fonts.css e manifest."); sys.exit(0)
    main([Path(p) for p in sys.argv[1:]])
