/* Funzioni comuni a runbook e documenti: preferenze (tema, font), highlighting e pulsanti di copia. */
(function () {
  'use strict';
  const PREFS_KEY = 'wpc2026.prefs';

  function store(key, value) {
    try { if (value === undefined) return JSON.parse(localStorage.getItem(key) || 'null'); localStorage.setItem(key, JSON.stringify(value)); }
    catch (e) { return null; }
  }

  function fonts() {
    try {
      const f = JSON.parse(document.getElementById('fonts-data').textContent || '[]');
      return Array.isArray(f) ? f.filter(x => x && FONT_ID.test(x.id)) : [];
    } catch (e) { return []; }
  }

  const THEMES = ['auto', 'light', 'dark'];
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));
  // Id di famiglia ammesso nei nomi CSS (R2-agy-02): solo lettere minuscole e cifre, come in tools/fonts.json.
  const FONT_ID = /^[a-z0-9]{1,40}$/;

  function applyTheme(theme) {
    let t = THEMES.includes(theme) ? theme : 'auto';
    if (t === 'auto') t = matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
    document.documentElement.dataset.theme = t;
    const light = document.getElementById('hl-light'), dark = document.getElementById('hl-dark');
    if (light && dark) { light.disabled = t === 'dark'; dark.disabled = t !== 'dark'; }
  }

  function applyFonts(prefs) {
    const root = document.documentElement.style;
    const fam = fonts();
    const body = fam.find(f => f.id === prefs.body);
    const code = fam.find(f => f.id === prefs.code && f.mono);
    root.setProperty('--font-body', body ? `'${body.id}-${body.body ? 'body' : 'mono'}', system-ui, sans-serif` : 'system-ui, -apple-system, "Segoe UI", sans-serif');
    root.setProperty('--font-code', code ? `'${code.id}-mono', ui-monospace, monospace` : 'ui-monospace, SFMono-Regular, Menlo, Consolas, monospace');
  }

  function initPrefs() {
    const fam = fonts();
    // Default: font Nerd incorporati (UbuntuSans per il testo se presente, BlexMono per il codice)
    const first = (ids, monoOnly) => (ids.map(id => fam.find(f => f.id === id && (!monoOnly || f.mono))).find(Boolean) || { id: '' }).id;
    const prefs = Object.assign({ theme: 'auto', body: first(['ubuntusans', 'blexmono']), code: first(['blexmono', 'saucecodepro'], true) }, store(PREFS_KEY) || {});
    const theme = document.getElementById('pref-theme');
    const body = document.getElementById('pref-body');
    const code = document.getElementById('pref-code');
    body.innerHTML = '<option value="">di sistema</option>' + fam.map(f => `<option value="${esc(f.id)}">${esc(f.label)}${f.body ? '' : ' (mono)'}</option>`).join('');
    // Il codice usa solo font monospace (classe Mono)
    code.innerHTML = '<option value="">monospace di sistema</option>' + fam.filter(f => f.mono).map(f => `<option value="${esc(f.id)}">${esc(f.label)}</option>`).join('');
    if (!THEMES.includes(prefs.theme)) prefs.theme = 'auto';
    theme.value = prefs.theme; body.value = prefs.body; code.value = prefs.code;
    const save = () => { prefs.theme = theme.value; prefs.body = body.value; prefs.code = code.value; store(PREFS_KEY, prefs); applyTheme(prefs.theme); applyFonts(prefs); document.dispatchEvent(new Event('wpc-prefs')); };
    [theme, body, code].forEach(el => el.addEventListener('change', save));
    matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => { applyTheme(prefs.theme); document.dispatchEvent(new Event('wpc-prefs')); });
    applyTheme(prefs.theme); applyFonts(prefs);
  }

  function toast(msg) {
    let t = document.getElementById('toast');
    if (!t) { t = document.createElement('div'); t.id = 'toast'; t.className = 'toast'; document.body.appendChild(t); }
    t.textContent = msg; t.classList.add('show');
    clearTimeout(toast._t); toast._t = setTimeout(() => t.classList.remove('show'), 1800);
  }

  async function copyText(text) {
    try { await navigator.clipboard.writeText(text); return true; }
    catch (e) {
      const ta = document.createElement('textarea'); ta.value = text; ta.style.position = 'fixed'; ta.style.opacity = '0';
      document.body.appendChild(ta); ta.select();
      let ok = false; try { ok = document.execCommand('copy'); } catch (e2) { ok = false; }
      ta.remove(); return ok;
    }
  }

  function highlight(codeEl) {
    const m = (codeEl.className.match(/language-([\w-]+)/) || [])[1] || 'plaintext';
    if (window.hljs) {
      if (!hljs.getLanguage(m)) { codeEl.classList.remove('language-' + m); codeEl.classList.add('language-plaintext'); }
      delete codeEl.dataset.highlighted;
      hljs.highlightElement(codeEl);
    }
  }

  /* Avvolge i <pre class="code"> statici con un pulsante di copia. getText: funzione che restituisce il testo da copiare. */
  function addCopyButton(pre, getText) {
    const wrap = document.createElement('div'); wrap.className = 'codewrap';
    pre.parentNode.insertBefore(wrap, pre); wrap.appendChild(pre);
    const btn = document.createElement('button'); btn.className = 'copy'; btn.type = 'button'; btn.textContent = 'Copia';
    btn.addEventListener('click', async () => {
      const ok = await copyText(getText());
      btn.textContent = ok ? 'Copiato' : 'Errore'; btn.classList.toggle('done', ok);
      setTimeout(() => { btn.textContent = 'Copia'; btn.classList.remove('done'); }, 1500);
    });
    wrap.appendChild(btn);
    return wrap;
  }

  window.WPC = { store, initPrefs, toast, copyText, highlight, addCopyButton };
})();
