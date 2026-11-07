/* Runbook WPC2026 — sito offline: sessioni, parametri, filtri, evidenze, export.
   I dati del runbook arrivano da #runbook-data (generato da tools/build_site.py). Nessuna rete. */
(function () {
  'use strict';
  const RB = JSON.parse(document.getElementById('runbook-data').textContent);
  const KEY = 'wpc2026.runbook';
  const STATUS = [['ok', 'OK'], ['ko', 'KO'], ['skip', 'Saltato'], ['na', 'Non applicabile']];
  const STATUS_LABEL = Object.fromEntries(STATUS);
  const $ = (s, el = document) => el.querySelector(s);
  // Ogni valore dinamico che entra in innerHTML passa da esc(), anche negli attributi (R2-codex-01).
  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  /* ------------------------------------------------------------ stato */
  let state = { current: null, sessions: {} };   // caricato e validato all'avvio (loadState)
  const save = () => { const s = cur(); if (s) s.updatedAt = new Date().toISOString(); WPC.store(KEY, state); };
  const cur = () => state.sessions[state.current];

  function newSession() {
    const now = new Date();
    const id = 's' + now.getTime().toString(36);
    state.sessions[id] = {
      id, name: 'Sessione ' + now.toLocaleString('it-IT', { dateStyle: 'short', timeStyle: 'short' }),
      operator: '', os: guessOs(), path: 'docker', profile: 'minimal', params: {},
      createdAt: now.toISOString(), updatedAt: now.toISOString(), runbookVersion: RB.hash, steps: {}
    };
    state.current = id; save(); return state.sessions[id];
  }
  function guessOs() {
    const p = (navigator.userAgentData && navigator.userAgentData.platform) || navigator.platform || '';
    return /win/i.test(p) ? 'windows' : /mac/i.test(p) ? 'macos' : 'debian';
  }
  const stepState = id => (cur().steps[id] ||= { status: '', checks: [], output: '', note: '', at: '', commands: '' });

  /* ------------------------------------------------------------ parametri */
  function paramValue(p, s = cur()) {
    if (s.params[p.name] !== undefined && s.params[p.name] !== '') return s.params[p.name];
    return s.os === 'windows' ? p.defaultWindows : p.default;
  }
  const PARAM_RE = /\{\{(\w+)\}\}/g;
  function resolve(code, s = cur()) {
    const byName = Object.fromEntries(RB.params.map(p => [p.name, p]));
    return code.replace(PARAM_RE, (m, n) => byName[n] ? paramValue(byName[n], s) : m);
  }
  function usedParams(code) { return [...new Set([...code.matchAll(PARAM_RE)].map(m => m[1]))]; }

  /* ------------------------------------------------------------ redazione dei segreti */
  // Pattern dei segreti noti (R2-codex-03: anche campi JSON tra virgolette e valori tra virgolette con spazi).
  // Ogni sostituzione è idempotente: redact(redact(x)) === redact(x).
  const SECRET_NAME = '(?:[A-Za-z0-9_-]*?(?:password|passwd|secret|token|api[_-]?key|master[_-]?key|salt[_-]?key|private[_-]?key|access[_-]?key)|key)';
  const REDACT = [
    [/\b(sk-(?:ant-|or-|proj-)?)[A-Za-z0-9_\-]{8,}/g, '$1[REDATTO]'],
    [/\bhf_[A-Za-z0-9]{10,}/g, 'hf_[REDATTO]'],
    [/\bAIza[0-9A-Za-z_\-]{20,}/g, 'AIza[REDATTO]'],
    [/(Bearer\s+)[A-Za-z0-9._~+\/\-]{8,}=*/gi, '$1[REDATTO]'],
    [/(x-api-key:\s*)\S+/gi, '$1[REDATTO]'],
    // JSON: "POSTGRES_PASSWORD": "valore", "key": "valore"
    [new RegExp('("' + SECRET_NAME + '"\\s*:\\s*)"(?:[^"\\\\]|\\\\.)*"', 'gi'), '$1"[REDATTO]"'],
    // CHIAVE=valore, CHIAVE: valore, anche con valore tra virgolette e spazi
    [/\b((?:[A-Za-z][A-Za-z0-9_]*_)?(?:API_?KEY|MASTER_KEY|SALT_KEY|ACCESS_KEY|PRIVATE_KEY|TOKEN|PASSWORD|PASSWD|SECRET)\s*[=:]\s*)(?:"[^"\n]*"|'[^'\n]*'|[^\s"',}]+)/gi, '$1[REDATTO]'],
    [/(postgres(?:ql)?:\/\/[^:\s\/]+:)[^@\s]+@/gi, '$1[REDATTO]@']
  ];
  function redact(text) { let t = text || ''; for (const [re, rep] of REDACT) t = t.replace(re, rep); return t; }

  /* ------------------------------------------------------------ validazione delle sessioni
     I dati da localStorage e da un JSON importato sono dati non fidati (R2-codex-01, R2-codex-02):
     la sessione si ricostruisce campo per campo, con valori ammessi, segreti oscurati e nessun
     output per i passi evidence=no-output. Una sessione non valida non entra nello stato. */
  const STEPS = Object.fromEntries(RB.phases.flatMap(p => p.steps).map(s => [s.id, s]));
  const ID_RE = /^s[a-z0-9]{1,20}$/;
  const isoOr = (v, d) => (typeof v === 'string' && !isNaN(Date.parse(v))) ? new Date(v).toISOString() : d;
  const str = (v, max) => (typeof v === 'string' ? v : '').slice(0, max);
  // Un parametro entra tra virgolette doppie nei comandi bash e PowerShell: lì "$" e "`" espandono ancora.
  // Unica espansione ammessa: $HOME all'inizio (codex review P2, R2-agy-03). Niente $( ${ $VAR, backtick,
  // virgolette, parentesi, ; | & < > o a capo.
  function cleanParam(name, v) {
    v = str(v, 300).trim();
    if (!v) return '';
    const rest = v.replace(/^\$HOME(?=$|[\\/])/, '');
    if (/[$`"'()\n\r;|&<>]/.test(rest) || redact(v) !== v || redact(name + '=' + v) !== name + '=' + v) return null;
    return v;
  }
  // Comandi importati: restano solo se la redazione non li cambia. Un comando legittimo può contenere
  // un nome come POSTGRES_PASSWORD (es. in un grep): in quel caso si usano i comandi attuali (S-404, S-501).
  function importCommands(st, cmds, s) {
    if (!Array.isArray(cmds)) return '';
    const list = cmds.slice(0, 20).filter(c => c && typeof c.code === 'string')
      .map(c => ({ lang: /^[\w-]{1,20}$/.test(c.lang) ? c.lang : 'plaintext', code: c.code.slice(0, 20000) }));
    return list.every(c => redact(c.code) === c.code) ? list : currentCommands(st, s);
  }
  // JSON con chiavi ordinate: confronta due sessioni senza dipendere dall'ordine delle proprietà.
  const stable = v => JSON.stringify(v, (k, x) => x && typeof x === 'object' && !Array.isArray(x)
    ? Object.fromEntries(Object.keys(x).sort().map(key => [key, x[key]])) : x);
  function sanitizeSession(raw) {
    if (!raw || typeof raw !== 'object' || !ID_RE.test(raw.id)) throw new Error('id');
    const now = new Date().toISOString();
    const pick = (v, allowed, d) => allowed.includes(v) ? v : d;
    const s = {
      id: raw.id,
      name: str(raw.name, 120).trim() || 'Sessione importata',
      operator: str(raw.operator, 120),
      os: pick(raw.os, Object.keys(RB.osLabels), 'debian'),
      path: pick(raw.path, ['docker', 'uv'], 'docker'),
      profile: pick(raw.profile, ['minimal', 'extended'], 'minimal'),
      params: {}, steps: {},
      createdAt: isoOr(raw.createdAt, now), updatedAt: isoOr(raw.updatedAt, now),
      runbookVersion: /^[0-9a-f]{12}$/.test(raw.runbookVersion) ? raw.runbookVersion : ''
    };
    const params = raw.params && typeof raw.params === 'object' ? raw.params : {};
    for (const p of RB.params) {
      const v = cleanParam(p.name, params[p.name]);
      if (v) s.params[p.name] = v;            // un parametro rifiutato torna al default
    }
    const steps = raw.steps && typeof raw.steps === 'object' ? raw.steps : {};
    for (const [id, st] of Object.entries(STEPS)) {
      const x = steps[id]; if (!x || typeof x !== 'object') continue;
      const noOut = st.evidence === 'no-output';
      const status = pick(x.status, STATUS.map(a => a[0]), '');
      s.steps[id] = {
        status,
        checks: Array.from({ length: st.checks || 0 }, (_, i) => Array.isArray(x.checks) && x.checks[i] === true),
        output: noOut ? '' : redact(str(x.output, 100000)),
        note: redact(str(x.note, 10000)),
        at: status ? isoOr(x.at, '') : '',
        commands: status ? importCommands(st, x.commands, s) : ''
      };
    }
    return s;
  }
  function loadState() {
    const raw = WPC.store(KEY);
    const st = { current: null, sessions: {} };
    if (raw && raw.sessions && typeof raw.sessions === 'object') {
      for (const v of Object.values(raw.sessions)) {
        try { const s = sanitizeSession(v); st.sessions[s.id] = s; } catch (e) { /* sessione non valida: scartata */ }
      }
      if (st.sessions[raw.current]) st.current = raw.current;
    }
    return st;
  }

  /* ------------------------------------------------------------ filtri */
  const visibleStep = (st, s = cur()) => st.os.includes(s.os) && (st.path === 'all' || st.path === s.path) && (st.profile === 'all' || st.profile === s.profile);
  const visibleBlock = (b, s = cur()) => b.type !== 'code' || b.os.includes(s.os);
  const DONE = ['ok', 'skip', 'na'];

  /* ------------------------------------------------------------ rendering */
  function renderSessionBar() {
    const sel = $('#session-select');
    sel.innerHTML = Object.values(state.sessions).sort((a, b) => b.createdAt.localeCompare(a.createdAt))
      .map(s => `<option value="${esc(s.id)}">${esc(s.name)}</option>`).join('');
    sel.value = state.current;
    const s = cur();
    $('#s-name').value = s.name; $('#s-operator').value = s.operator;
    $('#s-os').innerHTML = Object.entries(RB.osLabels).map(([k, v]) => `<option value="${esc(k)}">${esc(v)}</option>`).join('');
    $('#s-os').value = s.os; $('#s-path').value = s.path; $('#s-profile').value = s.profile;
    $('#version-warning').classList.toggle('hidden', s.runbookVersion === RB.hash);
  }

  function renderParams() {
    const s = cur();
    $('#params').innerHTML = RB.params.map(p => `
      <label class="field" title="${esc(p.description)}"><span>${esc(p.name)} — ${esc(p.description.replace(/\[([^\]]+)\]\([^)]+\)/g, '$1'))}</span>
      <input type="text" class="mono" data-param="${esc(p.name)}" value="${esc(s.params[p.name] ?? '')}" placeholder="${esc(s.os === 'windows' ? p.defaultWindows : p.default)}"></label>`).join('');
  }

  function renderPhases() {
    const s = cur();
    $('#intro').innerHTML = `<h2>${esc(RB.title)}</h2>${RB.intro}`;
    let out = '';
    for (const ph of RB.phases) {
      const steps = ph.steps.filter(st => visibleStep(st, s));
      if (!steps.length) continue;
      out += `<section class="phase" id="${esc(ph.id)}"><h2>${esc(ph.id)} — ${esc(ph.title)}</h2>`;
      for (const st of steps) out += renderStep(st);
      out += '</section>';
    }
    $('#phases').innerHTML = out || '<p class="card">Nessun passo per i filtri scelti.</p>';
    decorateCode(); bindStepEvents(); renderToc();
  }

  function renderStep(st) {
    const ss = stepState(st.id);
    const badges = [st.os.length === 4 ? 'tutti gli OS' : st.os.map(o => RB.osLabels[o]).join(', ')];
    if (st.path !== 'all') badges.push(st.path === 'docker' ? 'Docker' : 'uv');
    if (st.profile !== 'all') badges.push(st.profile === 'minimal' ? 'profilo minimo' : 'profilo esteso');
    let body = '';
    for (const b of st.blocks) {
      if (b.type === 'prose') body += `<div class="prose">${b.html}</div>`;
      else if (visibleBlock(b)) {
        const params = usedParams(b.code);
        body += `<pre class="code" data-code="${esc(b.code)}" data-os="${esc(b.os.join(','))}"><code class="language-${esc(b.lang)}"></code></pre>`
             + (params.length ? `<p class="hint">Parametri: ${params.map(n => `<code>${esc(n)}</code>`).join(' ')}</p>` : '');
      }
    }
    const noOut = st.evidence === 'no-output';
    return `<article class="card step" id="${esc(st.id)}" data-step="${esc(st.id)}" data-status="${esc(ss.status)}">
      <header><h3><span class="sid">${esc(st.id)}</span>${esc(st.title)}</h3>
        <div class="badges">${badges.map(b => `<span class="badge">${esc(b)}</span>`).join('')}${noOut ? '<span class="badge secret">segreti: output non salvato</span>' : ''}</div></header>
      ${body}
      <details class="evidence" ${ss.status ? '' : 'open'}><summary>Evidenza${ss.status ? ' — ' + esc(STATUS_LABEL[ss.status]) : ''}</summary>
        <div class="status">${STATUS.map(([v, l]) => `<button type="button" data-v="${esc(v)}" aria-pressed="${ss.status === v}">${esc(l)}</button>`).join('')}
          <span class="when">${ss.at ? new Date(ss.at).toLocaleString('it-IT') : ''}</span></div>
        <p class="hint stale hidden" data-stale>⚠️ Parametri o sistema operativo cambiati dopo l'esito: l'evidenza contiene i comandi del momento dell'esito. Per registrare i comandi attuali, premi di nuovo il pulsante dell'esito.</p>
        ${noOut ? '<p class="hint">Questo passo produce segreti: il sito non salva l\'output.</p>'
                : `<label class="field"><span>Output del comando (i segreti riconosciuti sono oscurati)</span><textarea class="mono" data-f="output" spellcheck="false">${esc(ss.output)}</textarea></label>
                   <p class="redacted hidden" data-redacted>Alcuni valori sono stati oscurati come [REDATTO].</p>`}
        <label class="field"><span>Note</span><textarea data-f="note">${esc(ss.note)}</textarea></label>
      </details></article>`;
  }

  function decorateCode() {
    document.querySelectorAll('pre.code[data-code]').forEach(pre => {
      const code = pre.firstElementChild;
      code.textContent = resolve(pre.dataset.code);
      WPC.highlight(code);
      if (!pre.parentElement.classList.contains('codewrap')) {
        const wrap = WPC.addCopyButton(pre, () => resolve(pre.dataset.code));
        const tag = document.createElement('span'); tag.className = 'ostag';
        const os = pre.dataset.os.split(',');
        tag.textContent = os.length === 4 ? '' : os.map(o => RB.osLabels[o]).join(' · ');
        wrap.insertBefore(tag, pre);
      }
    });
    document.querySelectorAll('.step').forEach(el => {
      const ss = stepState(el.dataset.step);
      const stale = $('[data-stale]', el); if (stale) stale.classList.toggle('hidden', !isStale(findStep(el.dataset.step), ss));
      el.querySelectorAll('input[data-check]').forEach(cb => { cb.checked = !!ss.checks[+cb.dataset.check]; });
    });
  }

  function renderToc() {
    const s = cur(); let all = 0, done = 0;
    $('#toc').innerHTML = RB.phases.map(ph => {
      const steps = ph.steps.filter(st => visibleStep(st, s));
      if (!steps.length) return '';
      const d = steps.filter(st => DONE.includes(stepState(st.id).status)).length;
      all += steps.length; done += d;
      return `<li><a href="#${esc(ph.id)}"><span>${esc(ph.id)} — ${esc(ph.title)}</span><span class="count">${d}/${steps.length}</span></a></li>`;
    }).join('');
    $('#progress-bar').style.width = all ? (100 * done / all) + '%' : '0';
    $('#progress-text').textContent = `${done} di ${all} passi completati (OK, saltati o non applicabili).`;
  }

  /* ------------------------------------------------------------ eventi */
  function bindStepEvents() {
    document.querySelectorAll('.step').forEach(el => {
      const id = el.dataset.step; const st = findStep(id);
      el.querySelectorAll('.status button').forEach(b => b.addEventListener('click', () => {
        const ss = stepState(id);
        ss.status = ss.status === b.dataset.v ? '' : b.dataset.v;
        ss.at = ss.status ? new Date().toISOString() : '';
        ss.commands = ss.status ? currentCommands(st) : '';
        save();
        el.dataset.status = ss.status;
        el.querySelectorAll('.status button').forEach(x => x.setAttribute('aria-pressed', String(x.dataset.v === ss.status)));
        $('.when', el).textContent = ss.at ? new Date(ss.at).toLocaleString('it-IT') : '';
        $('summary', el).textContent = 'Evidenza' + (ss.status ? ' — ' + STATUS_LABEL[ss.status] : '');
        $('[data-stale]', el).classList.add('hidden');   // l'esito ha appena registrato i comandi attuali
        renderToc();
      }));
      el.querySelectorAll('textarea[data-f]').forEach(ta => {
        ta.addEventListener('change', () => {
          const clean = redact(ta.value);
          const changed = clean !== ta.value;
          ta.value = clean; stepState(id)[ta.dataset.f] = clean; save();
          const n = $('[data-redacted]', el); if (n && ta.dataset.f === 'output') n.classList.toggle('hidden', !changed);
          if (changed) WPC.toast('Valori sensibili oscurati');
        });
      });
      el.querySelectorAll('input[data-check]').forEach(cb => cb.addEventListener('change', () => {
        stepState(id).checks[+cb.dataset.check] = cb.checked; save();
      }));
    });
  }
  const findStep = id => RB.phases.flatMap(p => p.steps).find(s => s.id === id);
  // Comandi risolti con i parametri e l'OS attuali; l'esito registra questa lista (R2-agy-04).
  const currentCommands = (st, s = cur()) => st.blocks.filter(x => x.type === 'code' && visibleBlock(x, s)).map(x => ({ lang: x.lang, code: resolve(x.code, s) }));
  const isStale = (st, ss, s = cur()) => Array.isArray(ss.commands) && ss.commands.length > 0 && JSON.stringify(ss.commands) !== JSON.stringify(currentCommands(st, s));

  function bindGlobal() {
    $('#session-select').addEventListener('change', e => { state.current = e.target.value; save(); renderAll(); });
    $('#session-new').addEventListener('click', () => { newSession(); renderAll(); WPC.toast('Nuova sessione creata'); });
    $('#session-delete').addEventListener('click', () => {
      if (!confirm('Elimina la sessione "' + cur().name + '" da questo browser? Esporta prima le evidenze.')) return;
      delete state.sessions[state.current];
      state.current = Object.keys(state.sessions)[0] || null;
      if (!state.current) newSession(); save(); renderAll();
    });
    $('#s-name').addEventListener('change', e => { cur().name = e.target.value || cur().name; save(); renderSessionBar(); });
    $('#s-operator').addEventListener('change', e => { cur().operator = e.target.value; save(); });
    ['os', 'path', 'profile'].forEach(k => $('#s-' + k).addEventListener('change', e => { cur()[k] = e.target.value; save(); renderParams(); renderPhases(); }));
    $('#params').addEventListener('change', e => {
      const name = e.target.dataset.param; if (!name) return;
      const v = cleanParam(name, e.target.value);
      if (v === null) {
        e.target.value = cur().params[name] ?? '';   // torna al valore accettato: campo, comandi ed evidenze restano coerenti
        WPC.toast('Valore rifiutato: niente segreti, virgolette, $( ), backtick o ; | & < >. Solo $HOME all\'inizio.');
        return;
      }
      cur().params[name] = v; save(); decorateCode();
    });
    $('#export-md').addEventListener('click', () => download(fileBase() + '.md', exportMarkdown(), 'text/markdown'));
    $('#export-json').addEventListener('click', () => download(fileBase() + '.json', JSON.stringify({ format: 'wpc2026-runbook-session', version: 1, runbook: RB.version + '·' + RB.hash, session: cur() }, null, 2), 'application/json'));
    $('#import-json').addEventListener('click', () => $('#import-file').click());
    $('#import-file').addEventListener('change', async e => {
      const f = e.target.files[0]; e.target.value = ''; if (!f) return;
      try {
        const d = JSON.parse(await f.text());
        if (!d || d.format !== 'wpc2026-runbook-session') throw new Error('formato');
        const s = sanitizeSession(d.session);   // valida PRIMA di salvare (review codex P2)
        if (state.sessions[s.id] && !confirm('La sessione esiste già in questo browser. Sostituirla?')) return;
        const unchanged = stable(s) === stable(d.session);   // prima di save(): save() cambia updatedAt (R2-agy-01)
        state.sessions[s.id] = s; state.current = s.id; save(); renderAll();
        WPC.toast(unchanged ? 'Sessione importata' : 'Sessione importata: valori non validi o segreti rimossi');
      } catch (err) { alert('File non valido: serve un export JSON di questo runbook.'); }
    });
  }

  /* ------------------------------------------------------------ export */
  function fileBase() {
    const s = cur(); const d = new Date().toISOString().slice(0, 16).replace(/[:T]/g, '-');
    return 'evidenze-wpc2026-' + (s.name || 'sessione').toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '') + '-' + d;
  }
  function fence(text, lang = 'text') {
    const ticks = '`'.repeat(Math.max(3, ...[...(text.match(/`+/g) || [])].map(m => m.length + 1)));
    return `${ticks}${lang}\n${text}\n${ticks}`;
  }
  const cell = v => String(v ?? '').replace(/\|/g, '\\|').replace(/\n/g, ' ');
  function exportMarkdown() {
    const s = cur(); const now = new Date();
    const steps = RB.phases.flatMap(p => p.steps.filter(st => visibleStep(st, s)).map(st => ({ ph: p, st, ss: stepState(st.id) })));
    const fmt = iso => iso ? new Date(iso).toLocaleString('it-IT') : '—';
    let md = `# Evidenze — ${RB.title}\n\n`;
    md += `| Campo | Valore |\n|---|---|\n`;
    md += [['Sessione', s.name], ['Operatore', s.operator || '—'], ['Sistema operativo', RB.osLabels[s.os]],
           ['Percorso LiteLLM', s.path === 'docker' ? 'Docker' : 'uv (servizio)'], ['Profilo LiteLLM', s.profile === 'minimal' ? 'minimo' : 'esteso'],
           ['Versione del runbook', `${RB.version} · ${RB.hash}` + (s.runbookVersion !== RB.hash ? ` (sessione avviata con ${s.runbookVersion})` : '')],
           ['Sessione creata', fmt(s.createdAt)], ['Ultima modifica', fmt(s.updatedAt)], ['Export', now.toLocaleString('it-IT')]]
      .map(([k, v]) => `| ${k} | ${cell(v)} |`).join('\n') + '\n\n';
    md += `## Parametri\n\n| Parametro | Valore | Origine |\n|---|---|---|\n` +
      RB.params.map(p => `| ${p.name} | \`${cell(paramValue(p, s))}\` | ${s.params[p.name] ? 'inserito' : 'default'} |`).join('\n') + '\n\n';
    const done = steps.filter(x => DONE.includes(x.ss.status)).length;
    md += `## Riepilogo\n\n${done} di ${steps.length} passi completati.\n\n| Passo | Titolo | Esito | Data e ora |\n|---|---|---|---|\n` +
      steps.map(({ st, ss }) => `| ${st.id} | ${cell(st.title)} | ${ss.status ? STATUS_LABEL[ss.status] : 'da fare'} | ${fmt(ss.at)} |`).join('\n') + '\n\n';
    md += `## Dettaglio dei passi\n`;
    let lastPh = '';
    for (const { ph, st, ss } of steps) {
      if (ph.id !== lastPh) { md += `\n### ${ph.id} — ${ph.title}\n`; lastPh = ph.id; }
      md += `\n#### ${st.id} — ${st.title}\n\n- Esito: **${ss.status ? STATUS_LABEL[ss.status] : 'da fare'}**\n- Data e ora: ${fmt(ss.at)}\n`;
      if (st.checks) md += `- Checklist: ${ss.checks.filter(Boolean).length} di ${st.checks} punti spuntati\n`;
      const snap = Array.isArray(ss.commands) && ss.commands.length;
      const cmds = snap ? ss.commands : currentCommands(st, s);
      if (cmds.length) md += `\n**Comandi (parametri risolti${snap ? ' al momento dell\'esito' : ''})**\n\n` + cmds.map(c => fence(c.code, c.lang)).join('\n\n') + '\n';
      if (snap && isStale(st, ss, s)) md += `\n> ⚠️ Parametri o sistema operativo cambiati dopo l'esito: i comandi sopra sono quelli registrati con l'esito.\n`;
      if (st.evidence === 'no-output') md += `\n**Output:** non salvato (il passo produce segreti).\n`;
      else if (ss.output) md += `\n**Output**\n\n${fence(redact(ss.output))}\n`;
      if (ss.note) md += `\n**Note:** ${redact(ss.note)}\n`;
    }
    return md;
  }
  function download(name, text, type) {
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([text], { type: type + ';charset=utf-8' }));
    a.download = name; document.body.appendChild(a); a.click();
    setTimeout(() => { URL.revokeObjectURL(a.href); a.remove(); }, 500);
    WPC.toast('File scaricato: ' + name);
  }

  /* ------------------------------------------------------------ avvio */
  function renderAll() { renderSessionBar(); renderParams(); renderPhases(); }
  WPC.initPrefs();
  state = loadState(); WPC.store(KEY, state);   // riscrive lo stato già validato
  if (!cur()) { const ids = Object.keys(state.sessions); if (ids.length) state.current = ids[0]; else newSession(); }
  bindGlobal(); renderAll();
  if (location.hash) { const t = document.getElementById(location.hash.slice(1)); if (t) t.scrollIntoView(); }
})();
