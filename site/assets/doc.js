/* Pagine dei documenti: preferenze, highlighting, copia dei blocchi di codice e diagrammi Mermaid. */
(function () {
  'use strict';
  WPC.initPrefs();
  document.querySelectorAll('pre.code > code').forEach(code => {
    const raw = code.textContent;
    WPC.highlight(code);
    WPC.addCopyButton(code.parentElement, () => raw);
  });

  // Mermaid locale (assets/vendor/mermaid), nessuna rete. securityLevel "strict": niente HTML né click nei diagrammi.
  // Il diagramma si disegna di nuovo quando cambiano tema o font (evento wpc-prefs di common.js).
  const diagrams = document.querySelectorAll('pre.mermaid');
  async function renderMermaid() {
    if (!diagrams.length || !window.mermaid) return;
    const dark = document.documentElement.dataset.theme === 'dark';
    const font = getComputedStyle(document.documentElement).getPropertyValue('--font-body').trim() || 'sans-serif';
    mermaid.initialize({ startOnLoad: false, securityLevel: 'strict', theme: dark ? 'dark' : 'default', fontFamily: font });
    diagrams.forEach(el => { el.removeAttribute('data-processed'); el.textContent = el.dataset.src; });
    try { await mermaid.run({ nodes: [...diagrams] }); }
    catch (e) { console.error('Mermaid:', e); }
  }
  if (document.fonts && document.fonts.ready) document.fonts.ready.then(renderMermaid); else renderMermaid();
  document.addEventListener('wpc-prefs', renderMermaid);
})();
