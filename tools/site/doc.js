/* Pagine dei documenti: preferenze, highlighting e copia dei blocchi di codice. */
(function () {
  'use strict';
  WPC.initPrefs();
  document.querySelectorAll('pre.code > code').forEach(code => {
    const raw = code.textContent;
    WPC.highlight(code);
    WPC.addCopyButton(code.parentElement, () => raw);
  });
})();
