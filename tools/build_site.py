#!/usr/bin/env python3
"""Genera il sito offline WPC2026 da docs/runbook/RUNBOOK.md e dai documenti in docs/.

Uso:  python3 tools/build_site.py [--check]
      --check: non scrive nulla; esce con codice 1 se il sito non è aggiornato.
Requisiti: markdown (es. uv run --with markdown python tools/build_site.py).

Output (cartella site/):
  index.html               runbook interattivo (parametri, filtri, evidenze, export)
  docs/<nome>.html         documenti di docs/ convertiti, con i link .md riscritti in .html
  assets/                  CSS, JS, highlight.js, font (i font li genera tools/fonts.py)
"""
import hashlib, html, json, re, shutil, sys
from pathlib import Path
import markdown

ROOT = Path(__file__).resolve().parent.parent
DOCS = ROOT / "docs"
RUNBOOK = DOCS / "runbook" / "RUNBOOK.md"
TPL = ROOT / "tools" / "site"
SITE = ROOT / "site"
OS_ALL = ["windows", "macos", "debian", "opensuse"]
OS_LABEL = {"windows": "Windows", "macos": "macOS", "debian": "Debian/Ubuntu", "opensuse": "openSUSE"}
DOC_PAGES = ["01-Installazione.md", "02-Configurazione-Copilot.md", "03-Security-Best-Practices.md",
             "04-Security-Review-OWASP-ISO27001.md", "Decisions.md", "Sources.md", "Review-Perplexity.md"]


# ---------------------------------------------------------------- Markdown

def github_slug(value: str, separator: str = "-") -> str:
    """Slug compatibile con le ancore di GitHub (le stesse usate nei link dei documenti)."""
    value = re.sub(r"<[^>]+>", "", value).strip().lower()
    value = re.sub(r"[^\w\- ]", "", value)
    return value.replace(" ", separator)


def rewrite_link(href: str, from_dir: str) -> str:
    """Riscrive i link relativi dei Markdown per il sito.
    from_dir: 'runbook' (sorgente docs/runbook, pagina site/index.html) o 'docs' (sorgente docs/, pagina site/docs/)."""
    if re.match(r"^[a-z]+:|^#", href):
        return href
    path, _, frag = href.partition("#")
    frag = ("#" + frag) if frag else ""
    if from_dir == "runbook":
        if path.startswith("../../"):          # file del repo (es. examples/)
            return "../" + path[len("../../"):] + frag
        if path.startswith("../") and path.endswith(".md"):
            return "docs/" + path[3:-3] + ".html" + frag
        return path + frag
    # from docs/
    if path == "runbook/RUNBOOK.md":           # il runbook è la pagina interattiva del sito
        return "../index.html" + frag
    if path.endswith(".md") and "/" not in path:
        return path[:-3] + ".html" + frag
    if path.startswith("../"):                 # file del repo visti da site/docs/
        return "../../" + path[3:] + frag
    return path + frag


def md_to_html(text: str, from_dir: str) -> str:
    md = markdown.Markdown(extensions=["tables", "fenced_code", "sane_lists", "toc", "md_in_html"],
                           extension_configs={"toc": {"slugify": github_slug}})
    out = md.convert(text)
    out = re.sub(r'href="([^"]+)"', lambda m: 'href="%s"' % html.escape(rewrite_link(html.unescape(m.group(1)), from_dir)), out)
    # checklist Markdown
    out = out.replace("<li>[ ] ", '<li class="task"><input type="checkbox" disabled> ').replace(
        "<li>[x] ", '<li class="task"><input type="checkbox" checked disabled> ')
    # diagrammi Mermaid: il sito li disegna con mermaid.js locale (doc.js); la sorgente resta visibile e copiabile
    out = re.sub(r'<pre><code class="language-mermaid">(.*?)</code></pre>',
                 lambda m: ('<figure class="mermaid-wrap"><pre class="mermaid" data-src="%s">%s</pre>'
                            '<details class="mermaid-src"><summary>Sorgente Mermaid</summary>'
                            '<pre class="code"><code class="language-plaintext">%s</code></pre></details></figure>')
                 % (html.escape(html.unescape(m.group(1)), quote=True), m.group(1), m.group(1)), out, flags=re.S)
    # blocchi di codice: classi per highlight.js
    out = re.sub(r'<pre><code class="language-([\w-]+)[^"]*">', r'<pre class="code"><code class="language-\1">', out)
    out = out.replace("<pre><code>", '<pre class="code"><code class="language-plaintext">')
    return out


# ---------------------------------------------------------------- Runbook

FENCE = re.compile(r"^```(\w+)?((?:\s+\w+=[\w,.-]+)*)\s*$")


def parse_attrs(s: str) -> dict:
    return dict(re.findall(r"(\w+)=([\w,.-]+)", s or ""))


def parse_runbook(text: str) -> dict:
    front, body = {}, text
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if m:
        front = dict(re.findall(r"^(\w+):\s*(.+)$", m.group(1), re.M))
        body = text[m.end():]
    lines = body.split("\n")
    intro, params, phases = [], [], []
    phase = step = None
    buf: list = []
    in_params = False

    def flush_prose():
        nonlocal buf
        if step is not None and any(l.strip() for l in buf):
            step["blocks"].append({"type": "prose", "md": "\n".join(buf).strip()})
        buf = []

    i = 0
    while i < len(lines):
        line = lines[i]
        if line.startswith("## "):
            flush_prose()
            title = line[3:].strip()
            in_params = title.lower() == "parametri"
            if not in_params:
                m = re.match(r"(F\d+)\s+—\s+(.+)", title)
                if not m:
                    raise SystemExit(f"Titolo di fase non valido: {title!r} (atteso 'F<n> — <titolo>')")
                phase = {"id": m.group(1), "title": m.group(2), "steps": []}
                phases.append(phase)
                step = None
            i += 1
            continue
        if line.startswith("### "):
            flush_prose()
            m = re.match(r"(S-\d+)\s+—\s+(.+)", line[4:].strip())
            if not m or phase is None:
                raise SystemExit(f"Titolo di passo non valido o fuori fase: {line!r}")
            meta = {"os": "all", "path": "all", "profile": "all", "evidence": "full"}
            if i + 1 < len(lines) and lines[i + 1].startswith("<!-- step:"):
                meta.update(parse_attrs(lines[i + 1]))
                i += 1
            step = {"id": m.group(1), "title": m.group(2), "os": expand_os(meta["os"]),
                    "path": meta["path"], "profile": meta["profile"], "evidence": meta["evidence"],
                    "blocks": [], "checks": 0}
            phase["steps"].append(step)
            i += 1
            continue
        if in_params:
            cells = [c.strip() for c in line.strip().strip("|").split("|")]
            if line.startswith("|") and len(cells) == 4 and not set(cells[0]) <= set("-: ") and cells[0] != "Nome":
                params.append({"name": cells[0], "default": cells[1], "defaultWindows": cells[2], "description": cells[3]})
            i += 1
            continue
        if step is None:
            intro.append(line); i += 1; continue
        fm = FENCE.match(line)
        if fm:
            flush_prose()
            lang, attrs = fm.group(1) or "plaintext", parse_attrs(fm.group(2))
            code = []
            i += 1
            while i < len(lines) and not lines[i].startswith("```"):
                code.append(lines[i]); i += 1
            step["blocks"].append({"type": "code", "lang": lang, "os": expand_os(attrs.get("os", "all")),
                                   "code": "\n".join(code)})
            i += 1
            continue
        if re.match(r"^- \[[ x]\] ", line):
            step["checks"] += 1
        buf.append(line)
        i += 1
    flush_prose()

    for ph in phases:
        for st in ph["steps"]:
            n = 0
            for b in st["blocks"]:
                if b["type"] == "prose":
                    h = md_to_html(b["md"], "runbook")

                    def repl(_m):
                        nonlocal n
                        n += 1
                        return '<li class="task"><input type="checkbox" data-check="%d"> ' % (n - 1)
                    b["html"] = re.sub(r'<li class="task"><input type="checkbox" disabled> ', repl, h)
                    del b["md"]
    # parametri nei comandi e nel testo dei passi (il sito sostituisce entrambi, R2-agy-06)
    used = {n for ph in phases for st in ph["steps"] for b in st["blocks"]
            for n in re.findall(r"\{\{(\w+)\}\}", b["code"] if b["type"] == "code" else b["html"])}
    declared = {p["name"] for p in params}
    if used - declared:
        raise SystemExit(f"Parametri usati ma non dichiarati: {sorted(used - declared)}")
    ids = [s["id"] for p in phases for s in p["steps"]]
    if len(ids) != len(set(ids)):
        raise SystemExit("ID di passo duplicati nel runbook")
    return {"title": front.get("title", "Runbook"), "version": front.get("version", "0"),
            "intro": md_to_html("\n".join(l for l in intro if not l.startswith("# ")), "runbook"),
            "params": params, "phases": phases, "osLabels": OS_LABEL}


def expand_os(v: str) -> list:
    return OS_ALL[:] if v == "all" else [o for o in v.split(",") if o]


# ---------------------------------------------------------------- Output

def page(title: str, body: str, depth: int, extra_head: str = "") -> str:
    a = "../" * depth + "assets/"
    tpl = (TPL / "page.html").read_text(encoding="utf-8")
    manifest = SITE / "assets" / "fonts-manifest.json"
    fonts = manifest.read_text(encoding="utf-8") if manifest.exists() else "[]"
    return (tpl.replace("{{FONTS_JSON}}", fonts.replace("</", "<\\/")).replace("{{TITLE}}", html.escape(title)).replace("{{ASSETS}}", a)
               .replace("{{HOME}}", "../" * depth + "index.html").replace("{{EXTRA_HEAD}}", extra_head)
               .replace("{{BODY}}", body))


def build() -> dict:
    files = {}
    rb_text = RUNBOOK.read_text(encoding="utf-8")
    model = parse_runbook(rb_text)
    model["hash"] = hashlib.sha256(rb_text.encode()).hexdigest()[:12]
    data = json.dumps(model, ensure_ascii=False).replace("</", "<\\/")
    manifest = SITE / "assets" / "fonts-manifest.json"
    fonts = manifest.read_text(encoding="utf-8") if manifest.exists() else "[]"
    app = (TPL / "index.html").read_text(encoding="utf-8")
    files["index.html"] = (app.replace("{{TITLE}}", html.escape(model["title"]))
                              .replace("{{FONTS_JSON}}", fonts.replace("</", "<\\/"))
                              .replace("{{VERSION}}", html.escape(model["version"] + " · " + model["hash"]))
                              .replace("{{RUNBOOK_JSON}}", data))
    nav = "".join('<li><a href="%s.html">%s</a></li>' % (n[:-3], html.escape(n[:-3])) for n in DOC_PAGES)
    for name in DOC_PAGES:
        src = DOCS / name
        if not src.exists():
            continue
        body = ('<nav class="docnav"><a href="../index.html">← Runbook</a><ul>%s</ul></nav><article class="doc">%s</article>'
                % (nav, md_to_html(src.read_text(encoding="utf-8"), "docs")))
        extra = '<script src="../assets/vendor/mermaid/mermaid.min.js"></script>' if 'class="mermaid"' in body else ""
        files["docs/" + name[:-3] + ".html"] = page(name[:-3], body, 1, extra)
    for f in ["styles.css", "common.js", "app.js", "doc.js"]:
        files["assets/" + f] = (TPL / f).read_text(encoding="utf-8")
    return files


def main():
    check = "--check" in sys.argv
    files = build()
    stale = [p for p, c in files.items() if not (SITE / p).exists() or (SITE / p).read_text(encoding="utf-8") != c]
    vendor_src, vendor_dst = TPL / "vendor", SITE / "assets" / "vendor"
    if check:
        # R2-agy-05: confronta anche i file di vendor/ e richiede gli asset dei font.
        problems = list(stale)
        for f in sorted(vendor_src.rglob("*")):
            if f.is_file():
                d = vendor_dst / f.relative_to(vendor_src)
                if not d.exists() or d.read_bytes() != f.read_bytes():
                    problems.append(str(d.relative_to(SITE)))
        if vendor_dst.exists():
            extra = [d for d in vendor_dst.rglob("*") if d.is_file() and not (vendor_src / d.relative_to(vendor_dst)).exists()]
            problems += [str(d.relative_to(SITE)) + " (in più)" for d in extra]
        for name in ("fonts.css", "fonts-manifest.json"):
            if not (SITE / "assets" / name).exists():
                problems.append("assets/" + name + " (manca: esegui tools/fonts.py)")
        if problems:
            print("Sito NON aggiornato:", *problems, sep="\n  ")
            sys.exit(1)
        print("Sito aggiornato."); return
    for p, c in files.items():
        (SITE / p).parent.mkdir(parents=True, exist_ok=True)
        (SITE / p).write_text(c, encoding="utf-8")
    if vendor_dst.exists():
        shutil.rmtree(vendor_dst)
    shutil.copytree(vendor_src, vendor_dst)
    if not (SITE / "assets" / "fonts.css").exists():
        (SITE / "assets" / "fonts.css").write_text("/* esegui tools/fonts.py */\n", encoding="utf-8")
        (SITE / "assets" / "fonts-manifest.json").write_text("[]", encoding="utf-8")
    print(f"Sito generato in {SITE} ({len(files)} file, {len(stale)} cambiati).")


if __name__ == "__main__":
    main()
