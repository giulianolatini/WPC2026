# Decisions — Registro delle decisioni

Questo file è il registro cronologico delle decisioni del progetto WPC2026.
Il formato segue il template ADR di Nygard, con una sezione **Razionale** esplicita ([S-090](Sources.md#s-090), [S-091](Sources.md#s-091)).

**Regole del registro**

- Il registro è *append-only*. Non modifica una decisione `Accepted`: scrivi una nuova decisione che la sostituisce (`Superseded by D-NNN`).
- Ogni decisione ha uno stato: `Proposed` → `Accepted` | `Rejected` → `Superseded`.
- `Proposed` indica una scelta dell'assistente che il PO deve confermare.
- Ogni decisione punta alle fonti in [Sources.md](Sources.md).

## Indice

| ID | Data | Titolo | Stato |
|----|------|--------|-------|
| [D-001](#d-001) | 2026-11-07 | Struttura del repository e cartella `docs/` | Accepted |
| [D-002](#d-002) | 2026-11-07 | Registro decisioni e fonti in due file con ancore | Accepted |
| [D-003](#d-003) | 2026-11-07 | Provider: solo API dirette dei vendor | Accepted |
| [D-004](#d-004) | 2026-11-07 | Piani Copilot: individuali e di organizzazione | Superseded by D-013 |
| [D-005](#d-005) | 2026-11-07 | LiteLLM: profilo minimo e profilo esteso | Accepted |
| [D-006](#d-006) | 2026-11-07 | openSUSE: `zypper` al posto di YaST | Superseded by D-014 |
| [D-007](#d-007) | 2026-11-07 | Provider *Custom Endpoint* al posto di `customOAIModels` | Accepted |
| [D-008](#d-008) | 2026-11-07 | Hugging Face nativo: estensione ufficiale HF | Accepted |
| [D-009](#d-009) | 2026-11-07 | Installazione di `uv` su Linux con installer ufficiale | Accepted |
| [D-010](#d-010) | 2026-11-07 | File di esempio in `examples/` | Accepted |
| [D-011](#d-011) | 2026-11-07 | GitHub Flow con rebase merge su `main` protetto | Accepted |
| [D-012](#d-012) | 2026-11-07 | Lingua italiana con regole ASD-STE100 adattate | Accepted |
| [D-013](#d-013) | 2026-11-07 | Policy BYOK: attiva di default, fatturazione in AI Credits | Accepted |
| [D-014](#d-014) | 2026-11-07 | openSUSE: `zypper`; YaST rimosso da Leap 16 | Accepted |
| [D-015](#d-015) | 2026-11-07 | "Codex" = `gpt-6.1-sol` via Responses API | Accepted |
| [D-016](#d-016) | 2026-11-07 | Gemini: `gemini-4-argon` stabile + `gemini-3.1-pro-preview` | Accepted |
| [D-017](#d-017) | 2026-11-07 | Tesi del talk: confronto con criteri | Accepted |
| [D-018](#d-018) | 2026-11-07 | LiteLLM: versione fissata `v1.108.2` e hardening | Accepted |
| [D-019](#d-019) | 2026-11-07 | Claude via LiteLLM con `apiType: messages`, senza discovery | Accepted |
| [D-020](#d-020) | 2026-11-07 | Tabella breve delle alternative a LiteLLM | Accepted |
| [D-021](#d-021) | 2026-11-07 | `anthropic-version: 2026-10-21` negli esempi | Accepted |
| [D-022](#d-022) | 2026-11-07 | Documento di best practice di sicurezza | Accepted |
| [D-023](#d-023) | 2026-11-07 | Security review con OWASP e ISO/IEC 27001 | Superseded by D-024 |
| [D-024](#d-024) | 2026-11-07 | OWASP LLM Top 10 edizione 2026 | Accepted |
| [D-025](#d-025) | 2026-11-07 | Applicazione delle azioni AZ-01…AZ-10 | Accepted |
| [D-026](#d-026) | 2026-11-07 | Runbook unico con filtri per OS, percorso e profilo | Accepted |
| [D-027](#d-027) | 2026-11-07 | Nerd Fonts in WOFF2 nel repository | Superseded by D-032 |
| [D-028](#d-028) | 2026-11-07 | Architettura del sito offline e delle evidenze | Accepted |
| [D-029](#d-029) | 2026-11-07 | Deck finale come artefatto Slides | Accepted |
| [D-030](#d-030) | 2026-11-07 | PostgreSQL locale per il percorso uv con profilo esteso | Accepted |
| [D-031](#d-031) | 2026-11-07 | Diagrammi Mermaid disegnati nel sito offline | Accepted |
| [D-032](#d-032) | 2026-11-07 | Nerd Fonts in WOFF2: sette famiglie e release fissata | Accepted |
| [D-033](#d-033) | 2026-11-14 | Team di agenti: custom agents di VS Code, template in `examples/agents/` | Accepted |
| [D-034](#d-034) | 2026-11-14 | Team di agenti: modelli per figura (misto per ruolo) | Superseded by D-037 |
| [D-035](#d-035) | 2026-11-14 | Team di agenti: flusso di lavoro, GitFlow, TDD e backlog | Accepted |
| [D-036](#d-036) | 2026-11-14 | Regole di scrittura originali ispirate ad ASD-STE100 | Accepted |
| [D-037](#d-037) | 2026-11-14 | Team di agenti: modelli per figura dopo la verifica P-12 | Accepted |
| [D-038](#d-038) | 2026-11-14 | Definition of Done per Epic e Feature; criteri di accettazione verificabili | Accepted |
| [D-039](#d-039) | 2026-11-14 | Protezione di `main` e `develop`: due ruleset, CODEOWNERS, identità separata | Accepted |
| [D-040](#d-040) | 2026-11-14 | Rami di Feature con il nome creato da Spec Kit | Accepted |
| [D-041](#d-041) | 2026-11-14 | Due documenti nuovi: BYOK in GitHub Copilot e introduzione a LiteLLM | Accepted |
| [D-042](#d-042) | 2026-11-14 | Runbook: fase F9 per il team di agenti; la chiusura diventa F10 | Accepted |
| [D-043](#d-043) | 2026-11-14 | Strumenti del Pianificatore e permessi dell'identità dell'agente dopo la review | Proposed |

---

<a id="d-001"></a>
## D-001 — Struttura del repository e cartella `docs/`

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** Il repository diventa pubblico all'evento WPC2026. Il pubblico deve trovare subito lo scopo e i materiali.

**Opzioni considerate.** (1) Tutti i file nella radice. (2) `README.md` nella radice e documentazione Markdown in `docs/`.

**Decisione.** Usiamo l'opzione 2. `README.md` riassume scopo, argomento e organizzazione. `docs/` contiene tutta la documentazione Markdown.

**Razionale.** GitHub mostra `README.md` come pagina d'ingresso. Una cartella dedicata separa documentazione, esempi e strumenti del sito offline.

**Conseguenze.** Ogni nuovo documento Markdown va in `docs/` e va elencato nel `README.md`.

**Fonti.** Richiesta del PO in chat (2026-11-07).

---

<a id="d-002"></a>
## D-002 — Registro decisioni e fonti in due file con ancore

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** Le decisioni devono essere collegate alle fonti. Le stesse fonti servono per citazioni e rimandi in tutta la documentazione.

**Opzioni considerate.** (1) `Decisions.md` + `Sources.md` con ancore `S-NNN`. (2) Un file per ADR in `docs/adr/` più un indice. (3) Fonti come sezione di `Decisions.md`.

**Decisione.** Usiamo l'opzione 1. `Decisions.md` è la lista cronologica. `Sources.md` contiene titolo e URL di ogni fonte, con un'ancora stabile.

**Razionale.** Un solo file di decisioni è sufficiente per la dimensione del progetto. Un solo file di fonti dà un link unico per la stessa fonte in tutti i documenti: così un URL cambia in un solo punto.

**Conseguenze.** I documenti puntano a `Sources.md#s-NNN`, non all'URL diretto. Se il numero di decisioni cresce molto, una nuova decisione può introdurre `docs/adr/`.

**Fonti.** [S-090](Sources.md#s-090), [S-091](Sources.md#s-091).

---

<a id="d-003"></a>
## D-003 — Provider: solo API dirette dei vendor

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** "Claude.AI", "Codex" e "Gemini Pro" hanno più canali di accesso: API del vendor, cloud enterprise (Azure, Vertex AI, Bedrock), abbonamenti consumer.

**Opzioni considerate.** (1) API dirette dei vendor. (2) API dirette più cloud enterprise. (3) Abbonamenti consumer.

**Decisione.** Usiamo l'opzione 1:

| Nome nel talk | Endpoint usato | Chiave |
|---------------|----------------|--------|
| Claude.AI | Anthropic API (`api.anthropic.com`) | `ANTHROPIC_API_KEY` |
| Codex | OpenAI API, modelli della famiglia Codex/GPT | `OPENAI_API_KEY` |
| Gemini Pro | Gemini API di Google AI Studio | `GEMINI_API_KEY` |
| OpenRouter | `openrouter.ai/api/v1` | `OPENROUTER_API_KEY` |
| Hugging Face | Inference Providers (`router.huggingface.co/v1`) | `HF_TOKEN` |

**Razionale.** Le API dirette hanno autenticazione semplice (una chiave) e sono supportate sia da VS Code BYOK sia da LiteLLM. In 30 minuti i canali enterprise aggiungono complessità senza valore per la tesi del talk. Gli abbonamenti consumer non sono un canale BYOK documentato.

**Conseguenze.** Il prefisso LiteLLM per Gemini è `gemini/` (AI Studio), non `vertex_ai/` ([S-025](Sources.md#s-025)). Gli harness Claude e Codex di VS Code hanno credenziali proprie e restano fuori dallo scopo ([S-001](Sources.md#s-001)).

**Fonti.** [S-001](Sources.md#s-001), [S-024](Sources.md#s-024), [S-025](Sources.md#s-025), [S-040](Sources.md#s-040), [S-042](Sources.md#s-042), [S-044](Sources.md#s-044), [S-047](Sources.md#s-047).

---

<a id="d-004"></a>
## D-004 — Piani Copilot: individuali e di organizzazione

- **Data:** 2026-11-07 — **Stato:** Superseded by [D-013](#d-013) — **Decisore:** PO

**Contesto.** Il BYOK ha regole diverse per i piani individuali (Free, Pro, Pro+) e per i piani Business/Enterprise.

**Opzioni considerate.** (1) Entrambi. (2) Solo individuali. (3) Solo Business/Enterprise.

**Decisione.** Usiamo l'opzione 1. La documentazione descrive il flusso individuale e aggiunge le policy di organizzazione.

**Razionale.** La platea WPC include sviluppatori e amministratori di tenant. Per Business/Enterprise un amministratore deve abilitare la policy *Bring Your Own Language Model Key in VS Code*; senza questa informazione la demo non è riproducibile in azienda.

**Conseguenze.** Il documento di configurazione contiene una sezione sulle policy: BYOK locale e *Enterprise BYOK* (public preview, policy *Enable custom models*).

**Fonti.** [S-001](Sources.md#s-001), [S-015](Sources.md#s-015), [S-016](Sources.md#s-016).

---

<a id="d-005"></a>
## D-005 — LiteLLM: profilo minimo e profilo esteso

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** LiteLLM proxy funziona senza database (solo `config.yaml` e master key) oppure con PostgreSQL (Admin UI, virtual keys, budget, spend log).

**Opzioni considerate.** (1) Minimo per la demo + esteso come approfondimento. (2) Solo minimo. (3) Solo completo.

**Decisione.** Usiamo l'opzione 1, per Docker e per il servizio locale con `uv`.

**Razionale.** Il profilo minimo parte in pochi secondi e riduce il rischio in demo. Il profilo esteso mostra il valore aziendale del gateway: chiavi virtuali per utente e controllo dei costi. Senza database i budget non sono applicati ([S-020](Sources.md#s-020)).

**Conseguenze.** Gli esempi in `examples/litellm/` contengono due file Compose. `LITELLM_SALT_KEY` va generata una sola volta e non va rigenerata ([S-020](Sources.md#s-020), [S-023](Sources.md#s-023)).

**Fonti.** [S-020](Sources.md#s-020), [S-021](Sources.md#s-021), [S-022](Sources.md#s-022), [S-023](Sources.md#s-023).

---

<a id="d-006"></a>
## D-006 — openSUSE: `zypper` al posto di YaST

- **Data:** 2026-11-07 — **Stato:** Superseded by [D-014](#d-014) (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** La richiesta cita `yast`. YaST è lo strumento di amministrazione (GUI/TUI) di openSUSE. Il package manager a riga di comando è `zypper`; YaST usa la stessa libreria.

**Opzioni considerate.** (1) Comandi `zypper`, con nota su YaST Software Management. (2) Procedura grafica YaST.

**Decisione.** Usiamo l'opzione 1.

**Razionale.** Un comando è copiabile, ripetibile e registrabile nelle evidenze. La documentazione VS Code e la wiki openSUSE usano `zypper` ([S-009](Sources.md#s-009), [S-064](Sources.md#s-064)).

**Conseguenze.** Il documento d'installazione mostra `zypper` e cita YaST come alternativa grafica.

**Fonti.** [S-009](Sources.md#s-009), [S-064](Sources.md#s-064).

---

<a id="d-007"></a>
## D-007 — Provider *Custom Endpoint* al posto di `customOAIModels`

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** Molte guide in rete usano l'impostazione `github.copilot.chat.customOAIModels` o il provider *OpenAI Compatible*. La documentazione VS Code attuale li dichiara deprecati e li sostituisce con il provider *Custom Endpoint* (`vendor: customendpoint`), che supporta le API `chat-completions`, `responses` e `messages`.

**Opzioni considerate.** (1) Custom Endpoint. (2) `customOAIModels` deprecato.

**Decisione.** Usiamo l'opzione 1 per OpenRouter, Hugging Face (alternativa all'estensione) e LiteLLM.

**Razionale.** Una configurazione deprecata può smettere di funzionare dopo il talk. Custom Endpoint permette di scegliere il formato API: con LiteLLM possiamo mostrare la stessa route in formato OpenAI e in formato Anthropic.

**Conseguenze.** Gli esempi usano `chatLanguageModels.json`. Le guide di terze parti con `customOAIModels` sono citate solo come contesto storico.

**Fonti.** [S-001](Sources.md#s-001).

---

<a id="d-008"></a>
## D-008 — Hugging Face nativo: estensione ufficiale HF

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** VS Code non ha un provider built-in Hugging Face. Hugging Face pubblica l'estensione *Hugging Face Provider for GitHub Copilot Chat*, che aggiunge un provider al Language Models editor. Il router HF è anche OpenAI-compatible.

**Opzioni considerate.** (1) Estensione ufficiale HF come configurazione "nativa". (2) Solo Custom Endpoint verso `router.huggingface.co/v1`. (3) Entrambe.

**Decisione.** Usiamo l'opzione 3: l'estensione come percorso principale, il Custom Endpoint come alternativa senza estensione.

**Razionale.** L'estensione usa l'API ufficiale *Language Model Chat Provider* di VS Code ed è il percorso documentato da HF. Il Custom Endpoint mostra che lo stesso risultato non dipende da un'estensione.

**Conseguenze.** Il token HF deve essere *fine-grained* con il permesso *Make calls to Inference Providers* ([S-047](Sources.md#s-047)).

**Fonti.** [S-001](Sources.md#s-001), [S-047](Sources.md#s-047), [S-048](Sources.md#s-048), [S-049](Sources.md#s-049).

---

<a id="d-009"></a>
## D-009 — Installazione di `uv` su Linux con installer ufficiale

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** La richiesta chiede i package manager `apt` e `zypper`. La documentazione di `uv` non cita pacchetti di distribuzione Linux; cita `winget` e `brew`.

**Opzioni considerate.** (1) Installer ufficiale `astral.sh` su Linux. (2) Pacchetti di distribuzione, se presenti. (3) `pipx install uv`.

**Decisione.** Usiamo l'opzione 1 su Linux; `winget` su Windows; `brew` su macOS.

**Razionale.** LiteLLM ≥ 1.84.0 richiede Python ≥ 3.10; `uv tool install` installa un Python compatibile ([S-021](Sources.md#s-021)). Un pacchetto di distribuzione può essere vecchio o assente.

**Conseguenze.** Su Linux il documento indica un'eccezione esplicita alla regola "solo package manager".

**Fonti.** [S-021](Sources.md#s-021), [S-060](Sources.md#s-060).

---

<a id="d-010"></a>
## D-010 — File di esempio in `examples/`

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** I documenti contengono configurazioni lunghe (`config.yaml`, Compose, `chatLanguageModels.json`, unit di servizio). Il pubblico deve poterle scaricare e usare.

**Opzioni considerate.** (1) Solo blocchi di codice nei documenti. (2) File pronti in `examples/` e blocchi di codice brevi nei documenti.

**Decisione.** Usiamo l'opzione 2.

**Razionale.** Un file versionato è testabile e non contiene errori di copia. `docs/` resta riservata al Markdown (D-001).

**Conseguenze.** Le chiavi API non entrano mai nel repo: gli esempi usano `.env` (escluso da `.gitignore`) e `.env.example`.

**Fonti.** —

---

<a id="d-011"></a>
## D-011 — GitHub Flow con rebase merge su `main` protetto

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (istruzioni di progetto)

**Contesto.** Il PO chiede GitHub Flow, `main` protetto, ingresso dei commit solo con rebase merge di una PR, review con codex cli e agy cli prima della review del PO.

**Decisione.** Ogni attività apre un ramo da `main`. Il ramo rientra con una PR e *rebase merge*. Il PO esegue la review finale e il merge.

**Razionale.** Il rebase merge conserva i singoli commit su una storia lineare. Questa scelta richiede commit atomici e messaggi curati.

**Conseguenze.** Il primo ramo è `docs/initial-documentation`. La protezione di `main` va configurata su GitHub (vedi PR).

**Fonti.** [S-017](Sources.md#s-017).

---

<a id="d-012"></a>
## D-012 — Lingua italiana con regole ASD-STE100 adattate

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (istruzioni di progetto)

**Contesto.** La documentazione deve essere sintetica e senza ambiguità.

**Decisione.** I documenti sono in italiano. Le regole di scrittura ASD-STE100 sono adattate all'italiano: frasi brevi, una istruzione per frase, forma attiva, imperativo nelle procedure, un termine per un concetto. I nomi tecnici restano in inglese.

**Razionale.** La platea usa i comandi in inglese. Frasi brevi riducono gli errori nell'esecuzione delle procedure.

**Conseguenze.** I riferimenti allo standard citano solo l'indice delle regole, non il testo ([S-092](Sources.md#s-092)).

**Fonti.** [S-092](Sources.md#s-092).


---

<a id="d-013"></a>
## D-013 — Policy BYOK: attiva di default, fatturazione in AI Credits

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (review P-02) — **Sostituisce:** [D-004](#d-004)

**Contesto.** D-004 afferma che un amministratore Business/Enterprise *deve abilitare* la policy BYOK. La review P-02 e il changelog GitHub dicono che la policy è *attiva di default*. La FAQ di VS Code dice ancora "must enable": le fonti ufficiali non sono coerenti. Dal 2026-06-01 Copilot usa i GitHub AI Credits al posto delle premium requests.

**Decisione.** Manteniamo lo scopo di D-004 (piani individuali e di organizzazione). Correggiamo i fatti:
- La policy *Bring Your Own Language Model Key in VS Code* è attiva di default. L'amministratore può disattivarla.
- Il BYOK locale non consuma crediti Copilot. Il provider fattura le chiamate.
- L'Enterprise BYOK (public preview) usa la policy *Enable custom models* (nella tabella delle superfici: *Configure custom models*).
- Piani individuali: Free, Pro, Pro+, Max, Student.

**Razionale.** Il changelog GitHub è la fonte primaria più specifica e più recente sulla policy. Il documento segnala l'incoerenza con ⚠️, così la platea non resta bloccata se un tenant ha la policy disattivata.

**Conseguenze.** [02-Configurazione-Copilot.md §2.5](02-Configurazione-Copilot.md#25-policy-per-copilot-business-ed-enterprise) è aggiornato.

**Fonti.** [S-015](Sources.md#s-015), [S-018](Sources.md#s-018), [S-019](Sources.md#s-019), [S-100](Sources.md#s-100), [S-101](Sources.md#s-101).

---

<a id="d-014"></a>
## D-014 — openSUSE: `zypper`; YaST rimosso da Leap 16

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (decisione invariata), contesto corretto dalla review P-06 — **Sostituisce:** [D-006](#d-006)

**Contesto.** D-006 descrive YaST come lo strumento di amministrazione di openSUSE. La review P-06 indica che Leap 16 ha rimosso YaST (installer Agama, gestione con Cockpit, software con Myrlyn). Su Tumbleweed YaST resta, ma non riceve più sviluppo.

**Decisione.** Usiamo `zypper` su Leap 16 e su Tumbleweed. Il documento cita Myrlyn (Leap 16) e YaST Software (Tumbleweed) come alternative grafiche.

**Razionale.** Il razionale di D-006 è più forte: `zypper` è l'unico strumento comune alle due distribuzioni.

**Conseguenze.** I pacchetti Docker sono diversi: su Tumbleweed `docker docker-compose docker-compose-switch`; su Leap 16 `docker docker-compose docker-buildx` (⚠️ fonti in conflitto, da provare).

**Fonti.** [S-064](Sources.md#s-064), [S-067](Sources.md#s-067).

---

<a id="d-015"></a>
## D-015 — "Codex" = `gpt-6.1-sol` via Responses API

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** Nel catalogo OpenAI tutti i modelli con "codex" nel nome sono *Shut down* o *Deprecated* (`gpt-5.3-codex`). I modelli raccomandati per Codex sono `gpt-6-astra`, `gpt-6.1-sol`, `gpt-6.1-terra`, `gpt-6-luna`. Codex supporta solo la Responses API.

**Opzioni considerate.** (1) `gpt-6.1-sol` via Responses. (2) `gpt-5.3-codex` (deprecato). (3) `gpt-6-astra`.

**Decisione.** Usiamo l'opzione 1. Nel talk "Codex" indica "il modello OpenAI raccomandato per Codex". In LiteLLM la route usa `openai/responses/gpt-6.1-sol`.

**Razionale.** `gpt-6.1-sol` è valido via API, supporta Responses e Chat Completions, ed è nella lista Codex. Un modello deprecato può sparire prima del talk.

**Conseguenze.** L'harness Codex di VS Code resta fuori scopo (D-003).

**Fonti.** [S-042](Sources.md#s-042), [S-043](Sources.md#s-043), [S-102](Sources.md#s-102).

---

<a id="d-016"></a>
## D-016 — Gemini: `gemini-4-argon` stabile + `gemini-3.1-pro-preview`

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** L'unico modello "Pro" è `gemini-3.1-pro-preview` (preview). Il modello di punta stabile è `gemini-4-argon` (tier a pagamento). `gemini-2.5-pro` è deprecato.

**Opzioni considerate.** (1) Entrambi. (2) Solo Pro preview. (3) Solo `gemini-4-argon`.

**Decisione.** Usiamo l'opzione 1. Alias LiteLLM: `gemini` → `gemini-4-argon` (default stabile); `gemini-pro` → `gemini-3.1-pro-preview`.

**Razionale.** Il default stabile riduce il rischio in demo. L'alias `gemini-pro` mantiene il nome usato nel titolo del talk.

**Conseguenze.** Una chiave Gemini del solo tier gratuito non usa `gemini-4-argon` ⚠️.

**Fonti.** [S-044](Sources.md#s-044), [S-103](Sources.md#s-103).

---

<a id="d-017"></a>
## D-017 — Tesi del talk: confronto con criteri

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (review P-08)

**Contesto.** Il contraddittorio P-08 valuta *parziale* la tesi "LiteLLM è preferibile per un team". Argomenti contro: due compromissioni supply chain di LiteLLM nel 2026, CVE critiche, concentrazione delle credenziali, perdita del thinking Anthropic con Chat Completions, bug di integrazione con VS Code. Argomenti a favore: virtual keys, budget, alias, un solo punto di log.

**Opzioni considerate.** (1) Confronto con criteri. (2) Tesi pro gateway con una slide sui rischi. (3) Solo tabella neutra.

**Decisione.** Usiamo l'opzione 1. Nativo per il singolo sviluppatore. Gateway quando serve governance di team, con rischi e misure di hardening esplicite.

**Razionale.** La raccomandazione dipende dal contesto. Una tesi assoluta pro gateway non resiste agli incidenti documentati del 2026.

**Conseguenze.** [02-Configurazione-Copilot.md §4.1](02-Configurazione-Copilot.md#41-quando-usare-un-gateway) contiene criteri di scelta, rischi e hardening.

**Fonti.** [S-104](Sources.md#s-104), [S-105](Sources.md#s-105), [S-106](Sources.md#s-106), [S-107](Sources.md#s-107).

---

<a id="d-018"></a>
## D-018 — LiteLLM: versione fissata `v1.108.2` e hardening

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** Il tag `v1.90.2` degli esempi è vecchio. Le versioni `1.82.7`, `1.82.8` e `1.107.0` erano compromesse. Il 2026-10-21 anche i tag mobili `latest`, `main-latest`, `main-stable` puntavano a immagini compromesse. La chiave cosign è cambiata il 2026-10-23. Il default di `--host` è `0.0.0.0`.

**Decisione.** Adottiamo:
- versione `1.108.2` (LTS) fissata per Docker e per `uv`; mai tag mobili; digest e firma cosign per l'uso in team;
- bind solo su `127.0.0.1`;
- agli sviluppatori solo virtual keys, mai la master key;
- `general_settings.disable_env_credential_login: true`.

**Razionale.** Il pin evita che un tag mobile compromesso entri nella demo o nella produzione.

**Conseguenze.** Prima del talk, controlla la release LTS corrente e il suo digest ⚠️.

**Fonti.** [S-023](Sources.md#s-023), [S-104](Sources.md#s-104), [S-105](Sources.md#s-105), [S-108](Sources.md#s-108), [S-109](Sources.md#s-109).

---

<a id="d-019"></a>
## D-019 — Claude via LiteLLM con `apiType: messages`, senza discovery

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** Con Chat Completions, i modelli Anthropic con thinking e tool richiedono di inviare di nuovo i `thinking_blocks`; i client OpenAI-compatible spesso li perdono (errore 400 o thinking disattivato). La discovery dei modelli del Custom Endpoint dà "Invalid response format" con LiteLLM (issue aperta).

**Decisione.** Adottiamo: modelli Claude via LiteLLM nel gruppo `apiType: messages`; altri modelli in `chat-completions`; nessun `url` a livello di provider (niente discovery), un `url` esplicito per ogni modello.

**Razionale.** Il formato Messages è il formato nativo di Anthropic. Un URL esplicito evita il bug di discovery.

**Conseguenze.** VS Code invia `x-api-key` con Messages. La configurazione aggiunge `Authorization: Bearer ${apiKey}` in `requestHeaders` ⚠️ (da provare).

**Fonti.** [S-001](Sources.md#s-001), [S-028](Sources.md#s-028), [S-110](Sources.md#s-110), [S-111](Sources.md#s-111).

---

<a id="d-020"></a>
## D-020 — Tabella breve delle alternative a LiteLLM

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Decisione.** Il documento di configurazione contiene una tabella di 5 righe: Enterprise BYOK di GitHub, Portkey, Cloudflare AI Gateway, Azure APIM + Foundry, OpenRouter come gateway. Nessuna procedura.

**Razionale.** La platea deve sapere che LiteLLM non è l'unica scelta. In 30 minuti non c'è tempo per altre demo.

**Fonti.** [S-015](Sources.md#s-015), [S-112](Sources.md#s-112), [S-113](Sources.md#s-113), [S-114](Sources.md#s-114), [S-115](Sources.md#s-115).

---

<a id="d-021"></a>
## D-021 — `anthropic-version: 2026-10-21` negli esempi

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** L'ultima versione dell'API Anthropic è `2026-10-21` (raccomandata). Rimuove `temperature`, `top_p`, `top_k` (errore 400). `2023-06-01` è nello storico; la pagina non dice se è deprecata.

**Decisione.** Usiamo `2026-10-21` negli esempi `curl`. Gli esempi non inviano `temperature`, `top_p`, `top_k`.

**Razionale.** La versione raccomandata riduce il rischio di comportamenti legacy.

**Fonti.** [S-116](Sources.md#s-116).


---

<a id="d-022"></a>
## D-022 — Documento di best practice di sicurezza

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** Il talk mostra configurazioni che gestiscono chiavi API e danno autonomia agli agenti. La platea deve avere un riferimento sui comportamenti corretti.

**Decisione.** Creiamo [03-Security-Best-Practices.md](03-Security-Best-Practices.md) con le best practice di Microsoft (VS Code, GitHub Copilot) e LiteLLM: comportamenti corretti e configurazioni sicure. Aggiungiamo la baseline [`examples/vscode/settings.secure.jsonc`](../examples/vscode/settings.secure.jsonc).

**Razionale.** Le best practice sono distribuite su molte pagine e cambiano spesso. Un documento unico con le fonti riduce il rischio di configurazioni insicure copiate dal talk.

**Conseguenze.** Ogni nuova configurazione di esempio deve rispettare il documento.

**Fonti.** [S-108](Sources.md#s-108), [S-109](Sources.md#s-109), [S-130](Sources.md#s-130), [S-131](Sources.md#s-131), [S-133](Sources.md#s-133), [S-134](Sources.md#s-134).

---

<a id="d-023"></a>
## D-023 — Security review con OWASP e ISO/IEC 27001

- **Data:** 2026-11-07 — **Stato:** Superseded by [D-024](#d-024) — **Decisore:** PO

**Contesto.** Le configurazioni di esempio vanno analizzate con framework riconosciuti, utili anche per un audit.

**Opzioni considerate.** OWASP: (1) LLM Top 10 + Agentic Top 10; (2) solo LLM Top 10; (3) LLM Top 10 + Top 10 web. ISO: (1) 2022 Annex A; (2) 2022 Annex A + clausole 4–10.

**Decisione.** OWASP Top 10 for LLM Applications 2025 come asse principale, OWASP Top 10 for Agentic Applications 2026 per gli agenti. ISO/IEC 27001:2022 Annex A e clausole 4–10. Il documento è [04-Security-Review-OWASP-ISO27001.md](04-Security-Review-OWASP-ISO27001.md).

**Razionale.** Il Top 10 LLM copre il singolo scambio con il modello; il Top 10 Agentic copre tool, permessi ed esecuzione. Le clausole 4–10 collegano i rilievi al sistema di gestione.

**Conseguenze.** I rilievi `F-NN` producono azioni `AZ-NN`. Le azioni che cambiano gli esempi richiedono l'approvazione del PO. Il testo della norma ISO non è riprodotto: il documento cita solo numero e titolo dei controlli.

**Fonti.** [S-137](Sources.md#s-137), [S-138](Sources.md#s-138), [S-140](Sources.md#s-140), [S-141](Sources.md#s-141).


---

<a id="d-024"></a>
## D-024 — OWASP LLM Top 10 edizione 2026

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO — **Sostituisce:** [D-023](#d-023) (solo l'edizione OWASP LLM)

**Contesto.** D-023 usa l'OWASP Top 10 for LLM Applications 2025. La review P-10 indica che il 2026-08-03 OWASP ha pubblicato l'edizione 2026, con un ordine diverso (es. Excessive Agency passa da LLM06 a LLM03; System Prompt Leakage diventa Hidden Context Exposure, LLM08). L'assistente ha verificato la data sulla pagina della risorsa e l'elenco sul repository canonico.

**Opzioni considerate.** (1) Edizione 2026. (2) Edizione 2025, già citata in D-023.

**Decisione.** Usiamo l'opzione 1. Il documento 04 riporta anche la corrispondenza con gli ID 2025. Restano invariati: Agentic Top 10 2026 e ISO/IEC 27001:2022 Annex A + clausole 4–10.

**Razionale.** Il pubblico del talk troverà l'edizione 2026 come edizione corrente. Gli ID 2025 vecchi creano confusione.

**Conseguenze.** I rilievi `F-NN` usano `LLMxx` = 2026.

**Fonti.** [S-137](Sources.md#s-137), [S-146](Sources.md#s-146), [S-147](Sources.md#s-147).

---

<a id="d-025"></a>
## D-025 — Applicazione delle azioni AZ-01…AZ-10

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

**Contesto.** La security review ([04](04-Security-Review-OWASP-ISO27001.md)) propone 10 azioni che cambiano gli esempi.

**Decisione.** Applichiamo tutte le azioni. Integriamo le correzioni di P-09 e P-10: la sandbox dell'agente è `off` di default e la baseline la attiva; il primo `proxy_admin` si crea con l'API (`/user/new`, `/user/update`) e la master key.

**Razionale.** Gli esempi sono pubblici e saranno copiati: devono essere sicuri di default.

**Conseguenze.** Nuovi file: `scripts/pin-images.sh`, `scripts/bootstrap-admin.sh`, `service/load-env.sh`. Tre punti restano ⚠️ da provare: tag `litellm-non_root:v1.108.2`, campi `provider` di OpenRouter, `turn_off_message_logging`.

**Fonti.** [S-104](Sources.md#s-104), [S-108](Sources.md#s-108), [S-109](Sources.md#s-109), [S-144](Sources.md#s-144), [S-145](Sources.md#s-145), [S-148](Sources.md#s-148), [S-151](Sources.md#s-151).

---

<a id="d-026"></a>
## D-026 — Runbook unico con filtri per OS, percorso e profilo

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO ("Tutto, con filtro OS"; evidenze "Parametri + esito + output")

**Contesto.** I documenti 01 e 02 descrivono 4 sistemi operativi, 2 percorsi LiteLLM (Docker, uv) e 2 profili (minimo, esteso). Il PO vuole un runbook da eseguire passo per passo, con evidenze.

**Opzioni considerate.** (1) Un runbook per ogni combinazione. (2) Un runbook unico con metadati di filtro per passo e per blocco di codice.

**Decisione.** Usiamo l'opzione 2: `docs/runbook/RUNBOOK.md`, fasi F1–F9, passi `S-nnn`. Ogni passo ha la riga `<!-- step: os=… path=… profile=… evidence=… -->`. I blocchi di codice hanno `os=…`. I comandi usano parametri `{{NOME}}` dichiarati in una tabella. L'evidenza registra parametri, esito e output.

**Razionale.** Una sola sorgente evita divergenze tra le copie. Il generatore controlla che ogni parametro usato sia dichiarato e che gli ID siano unici.

**Conseguenze.** Il runbook rimanda a 01 e 02 per le spiegazioni e non le ripete. I passi che producono segreti (S-202, S-203, S-501) hanno `evidence=no-output`.

**Fonti.** [01](01-Installazione.md), [02](02-Configurazione-Copilot.md), [S-092](Sources.md#s-092).

---

<a id="d-027"></a>
## D-027 — Nerd Fonts in WOFF2 nel repository

- **Data:** 2026-11-07 — **Stato:** Superseded by [D-032](#d-032) — **Decisore:** PO ("WOFF2 nel repo")

**Contesto.** Il sito deve funzionare offline su una postazione che può non avere i font richiesti: BlexMono, FiraCode, GoogleSansCode, Monoid, OpenDyslexic, SauceCodePro, UbuntuSans (Nerd Fonts).

**Opzioni considerate.** (1) WOFF2 nel repository. (2) Download dei font a ogni generazione, senza commit. (3) Font di sistema.

**Decisione.** Usiamo l'opzione 1. `tools/fonts.py` converte i TTF in `site/assets/fonts/<id>-<ruolo>-<peso>.woff2` e copia la licenza di ogni famiglia in `site/assets/fonts/LICENSES/`. `tools/fonts.json` dichiara famiglie, zip di release e file. Il codice usa solo le varianti `Mono`.

**Razionale.** WOFF2 riduce la dimensione (circa 13 MB per 5 famiglie, licenze incluse). Il clone del repo basta per usare il sito.

**Conseguenze.** GoogleSansCode e UbuntuSans sono solo nelle release zip: il PO le aggiunge con `tools/update-site.sh --fonts`. La cartella `.cache/` (zip scaricati) è esclusa da git.

**Fonti.** [S-152](Sources.md#s-152), [S-153](Sources.md#s-153), [S-156](Sources.md#s-156).

---

<a id="d-028"></a>
## D-028 — Architettura del sito offline e delle evidenze

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** proposta dell'assistente, approvata dal PO

**Contesto.** Il sito si apre da `file://`, senza server e senza rete.

**Opzioni considerate.** (1) Pagine statiche generate in Python, dati del runbook nel HTML come JSON, sessioni in `localStorage`, export Markdown e JSON. (2) Static site generator esterno (es. MkDocs) più un'app JavaScript separata. (3) Applicazione con server locale.

**Decisione.** Usiamo l'opzione 1.

- `tools/build_site.py` genera `site/index.html` (runbook interattivo) e `site/docs/*.html` (documenti di `docs/`, con i link `.md` riscritti).
- Dati nel HTML: il browser blocca `fetch` da `file://`.
- Sessioni multiple in `localStorage` (chiave `wpc2026.runbook`); export/import JSON per cambiare browser o macchina.
- Evidenza in Markdown: dati della sessione, parametri (valore e origine), riepilogo, comandi con i parametri risolti, esito, data e ora, output, note.
- Il sito oscura i segreti riconosciuti (`sk-…`, `hf_…`, `AIza…`, `Bearer …`, `*_API_KEY=…`, `*_PASSWORD=…`, campi JSON come `"key": "…"`, password in `postgresql://`) e rifiuta segreti nei parametri.
- Le sessioni lette da `localStorage` o da un JSON importato sono dati non fidati: il sito le ricostruisce campo per campo (valori ammessi, segreti oscurati, nessun output per i passi `evidence=no-output`) prima di salvarle. Ogni valore dinamico nell'HTML passa dall'escaping (review PR #2).
- highlight.js locale; temi chiaro, scuro e automatico.
- `tools/update-site.sh` e `tools/update-site.ps1` rigenerano il sito; `--check` controlla che il sito sia aggiornato.

**Razionale.** Nessuna dipendenza a runtime. Un solo generatore piccolo e leggibile. Le evidenze restano sotto il controllo dell'operatore.

**Conseguenze.** `localStorage` appartiene a un browser e a un profilo: l'export JSON è il backup. L'oscuramento dei segreti è una protezione aggiuntiva, non sostituisce il controllo dell'operatore (S-902). La sessione registra la versione del runbook e il sito segnala una versione diversa.

**Fonti.** [S-154](Sources.md#s-154), [S-155](Sources.md#s-155), [S-157](Sources.md#s-157).

---

<a id="d-029"></a>
## D-029 — Deck finale come artefatto Slides

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO ("Artefatto Slides")

**Contesto.** Le istruzioni del progetto chiedono un deck che racconti i punti principali e sia una mappa di quanto prodotto.

**Decisione.** Il deck è un artefatto Slides di claude.ai, esportabile in PowerPoint o PDF. Non è un file del repository.

**Conseguenze.** Il README riporta il collegamento al deck quando il PO lo condivide.

**Fonti.** —

---

<a id="d-030"></a>
## D-030 — PostgreSQL locale per il percorso uv con profilo esteso

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** richiesta del PO (procedura di installazione per ogni sistema operativo); scelte di dettaglio dell'assistente, approvate dal PO

**Contesto.** Con `uv` il profilo esteso richiede un PostgreSQL esterno ([01 §6](01-Installazione.md#6-litellm-come-servizio-locale-con-uv)). La review della PR #2 (R2-codex-04) ha trovato il percorso incompleto. Il PO chiede una procedura di installazione per ogni sistema operativo.

**Opzioni considerate.** (1) Versione principale fissa, uguale al profilo Docker (`postgres:16`), con pacchetti ufficiali: installer EDB via `winget` (Windows), `postgresql@16` di Homebrew (macOS), repository PGDG (Debian/Ubuntu), `postgresql16-server` (openSUSE). (2) Versione dei pacchetti della distribuzione, diversa per ogni sistema. (3) Solo un database dell'organizzazione, senza procedura.

**Decisione.** Usiamo l'opzione 1, con il parametro `PG_MAJOR` (default `16`) nei passi S-402–S-404 del runbook:

- S-402 installa il server e lo avvia come servizio.
- S-403 imposta `listen_addresses = 'localhost'` con `ALTER SYSTEM` e porta a `scram-sha-256` ogni riga `host` di `pg_hba.conf`.
- S-404 crea l'utente e il database `litellm` con la password `POSTGRES_PASSWORD` di `.env`, passata a `psql` da standard input, e scrive `DATABASE_URL` in `.env` solo se manca.

L'opzione 3 resta possibile: S-402 e S-403 sono «Non applicabile» e S-404 scrive solo `DATABASE_URL`.

**Razionale.** La stessa versione principale nei due percorsi riduce le differenze da provare. I pacchetti ufficiali hanno aggiornamenti di sicurezza. L'installer EDB ascolta su tutte le interfacce e Homebrew usa `trust`: la procedura li limita a localhost e alle password.

**Conseguenze.** ⚠️ Da provare su ogni sistema: ID `winget` `PostgreSQL.PostgreSQL.16`, nome del pacchetto e inizializzazione automatica su openSUSE, primo avvio di LiteLLM con il database. Su macOS le connessioni dal socket locale restano `trust` per l'utente che è superutente del database.

**Fonti.** [S-158](Sources.md#s-158), [S-159](Sources.md#s-159), [S-160](Sources.md#s-160), [S-161](Sources.md#s-161), [S-162](Sources.md#s-162), [S-163](Sources.md#s-163), [S-022](Sources.md#s-022).

---

<a id="d-031"></a>
## D-031 — Diagrammi Mermaid disegnati nel sito offline

- **Data:** 2026-11-07 — **Stato:** Accepted (confermata dal PO il 2026-11-07) — **Decisore:** richiesta del PO (vedere il grafo, oppure un PNG); scelta dell'assistente, approvata dal PO

**Contesto.** I documenti 02 e 04 contengono diagrammi Mermaid. GitHub li disegna; il sito offline mostrava solo la sorgente.

**Opzioni considerate.** (1) Mermaid locale nel sito (`mermaid.min.js`, circa 5,5 MB), disegno nel browser. (2) Immagini PNG o SVG generate in anticipo con Mermaid CLI e salvate nel repository. (3) Solo la sorgente.

**Decisione.** Usiamo l'opzione 1: `mermaid@12.3.0` in `tools/site/vendor/mermaid/`, caricato solo dalle pagine con diagrammi, `securityLevel: 'strict'`. Il diagramma segue tema e font scelti; la sorgente resta visibile in un pannello con il pulsante Copia.

**Razionale.** Una sola sorgente (il Markdown): nessuna immagine da rigenerare quando il diagramma cambia. Mermaid CLI richiede un browser headless sul computer che genera il sito. Il tema scuro funziona anche per i diagrammi.

**Conseguenze.** Il repository cresce di circa 5,5 MB. Un aggiornamento di Mermaid sostituisce il file in `vendor/` e aggiorna `VERSION` (sha256 e integrity npm); `--check` confronta i file di `vendor/`.

**Fonti.** [S-164](Sources.md#s-164).

---

<a id="d-032"></a>
## D-032 — Nerd Fonts in WOFF2: sette famiglie e release fissata

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO (richiesta dopo la review R4-agy-09) — **Sostituisce:** [D-027](#d-027)

**Contesto.** D-027 descrive 5 famiglie (circa 13 MB) e rimanda GoogleSansCode e UbuntuSans a un passo successivo. Il PO ha eseguito `tools/update-site.sh --fonts`: il sito contiene ora tutte le 7 famiglie. La review della PR #2 (R4-agy-04) ha fissato la release e i checksum degli zip. Il registro è *append-only*: una nuova decisione aggiorna D-027.

**Opzioni considerate.** (1) Nuova decisione che sostituisce D-027 con i dati attuali. (2) Lasciare D-027 con i dati di quel momento.

**Decisione.** Usiamo l'opzione 1. Restano valide le scelte di D-027: WOFF2 nel repository, conversione con `tools/fonts.py`, licenza di ogni famiglia in `site/assets/fonts/LICENSES/`, varianti `Mono` per il codice. Cambiano i dati:

- 7 famiglie: BlexMono, FiraCode, GoogleSansCode, Monoid, OpenDyslexic, SauceCodePro, UbuntuSans.
- 17 file WOFF2 (circa 19 MB): varianti `Mono` 400/700 di ogni famiglia (OpenDyslexic solo 400), varianti per il testo di OpenDyslexic e UbuntuSans.
- Release Nerd Fonts fissata a `v3.5.1`, con lo sha256 di ogni zip in `tools/fonts.json`. `tools/update-site.sh --fonts` (o `-Fonts`) verifica l'hash prima di estrarre.
- Conversione riproducibile: due esecuzioni producono gli stessi byte (`recalcTimestamp=False`).

**Razionale.** Il registro deve descrivere il repository com'è. Le altre parti di D-027 non cambiano.

**Conseguenze.** Un aggiornamento dei font cambia la versione in `tools/fonts.json`, aggiorna gli sha256 e rigenera i WOFF2 con `--fonts`.

**Fonti.** [S-152](Sources.md#s-152), [S-153](Sources.md#s-153), [S-156](Sources.md#s-156).

---

<a id="d-033"></a>
## D-033 — Team di agenti: custom agents di VS Code, template in `examples/agents/`

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO (brainstorming del 2026-11-14)

**Contesto.** Il PO chiede un secondo passo: un team di sviluppo orchestrato (9 figure) che usa i modelli BYOK configurati in [02](02-Configurazione-Copilot.md) per uno sviluppo *spec-driven*. La richiesta nomina «ClaudeCode, Codex e OpenRouter tramite chiamate API di GitHub Copilot». Il progetto software usa GitFlow; questo repository usa GitHub Flow.

**Opzioni considerate.** Forma: (1) *custom agents* di VS Code con subagent; (2) harness Claude e Codex; (3) Copilot CLI; (4) orchestratore esterno. Harness: (a) Copilot con Local di riserva; (b) solo Copilot; (c) solo Local. Posizione: (i) template in questo repository; (ii) nuovo repository.

**Decisione.** Opzioni 1, a, i. Ogni figura è un file `.agent.md` in `examples/agents/.github/agents/`, scritto per l'harness Copilot (`target: github-copilot`). Il documento [05](05-Team-Agenti.md) descrive le differenze per l'harness Local.

**Razionale.** I *custom agents* fissano modello, strumenti e istruzioni per figura e restano dentro Copilot Chat, che il talk descrive. L'harness Local termina a febbraio 2027. Un template lascia questo repository in GitHub Flow.

**Conseguenze.** Nell'harness Copilot il BYOK è sperimentale: punto ⚠️ da provare. Senza il campo `agents` (solo Local) la limitazione dei subagent sta nelle istruzioni e in `user-invocable: false`.

**Fonti.** [S-007](Sources.md#s-007), [S-068](Sources.md#s-068), [S-072](Sources.md#s-072), [S-165](Sources.md#s-165).

---

<a id="d-034"></a>
## D-034 — Team di agenti: modelli per figura (misto per ruolo)

- **Data:** 2026-11-14 — **Stato:** Superseded by [D-037](#d-037) — **Decisore:** PO (brainstorming del 2026-11-14)

**Contesto.** Il PO chiede modelli costosi per analisi e pianificazione e modelli economici per l'implementazione: Pianificatore alto con effort `high` o superiore; Organizzatore intermedio; Avversario medio con ragionamento limitato; figure operative e Reviewer medio/bassi; due modelli diversi per i Reviewer.

**Opzioni considerate.** (1) Misto per ruolo tra Anthropic, OpenAI e OpenRouter. (2) OpenRouter solo con `openai/gpt-oss-120b` senza conservazione dei dati. (3) Massimo risparmio: tutte le figure operative su modelli aperti via OpenRouter.

**Decisione.** Opzione 1:

| Figura | Modello | Effort |
|---|---|---|
| Pianificatore | `claude-fable-5-2` | `high` |
| Organizzatore | `claude-sonnet-5-5` | default |
| Avversario | `gpt-6.1-sol` | `low` |
| Sviluppatore, Operativo | `gpt-5.4-mini` | default |
| Tester, Scrittore | `claude-haiku-5-5` | default |
| Reviewer ottimista | `deepseek/deepseek-v4.1-flash` (OpenRouter) | default |
| Reviewer antagonista | `qwen/qwen3-coder` (OpenRouter) | default |

**Razionale.** Il costo segue il ragionamento richiesto. Due provider diversi per Pianificatore e Avversario, e due modelli diversi per i Reviewer, danno punti di vista indipendenti. OpenAI non ha modelli «Codex» correnti: le figure di codice usano i modelli generali indicati per il coding.

**Conseguenze.** ⚠️ Da verificare con P-12: ID e prezzi dei modelli OpenAI e OpenRouter. I diff delle PR vanno a provider scelti da OpenRouter: servono i *guardrail* per codice riservato ([05 §9](05-Team-Agenti.md#10-sicurezza)). Un cambio di modello modifica solo il campo `model` del file della figura.

**Fonti.** [S-040](Sources.md#s-040), [S-102](Sources.md#s-102), [S-166](Sources.md#s-166), [S-072](Sources.md#s-072).

---

<a id="d-035"></a>
## D-035 — Team di agenti: flusso di lavoro, GitFlow, TDD e backlog

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO (brainstorming del 2026-11-14)

**Contesto.** La richiesta lascia aperti cinque punti: dove vive il backlog; come avviene il brainstorming 1to1 (un subagent non può fare domande all'utente); chi unisce le Feature in `develop`; hotfix e riallineamento in GitFlow; chi modifica i test nel ciclo TDD.

**Decisione.**

- **Backlog:** specifiche e piano con GitHub Spec Kit; Epic, Feature e Task in file Markdown in `docs/backlog/`.
- **Brainstorming:** il PO apre direttamente l'agente Pianificatore, che chiama l'Avversario come subagent.
- **Merge in `develop`:** l'Organizzatore, quando i due Reviewer approvano e i test sono verdi. Il merge in `main` resta del PO, con approvazione esplicita.
- **GitFlow completo:** rami `hotfix/*` da `main` e *back-merge* di Release e hotfix in `develop`.
- **TDD:** il Tester scrive prima i test (*red*); chi implementa li fa passare (*green*) e fa il *refactor*; solo il Tester modifica i test.

**Opzioni scartate.** Backlog in GitHub Issues o senza Spec Kit; Organizzatore come tramite nel brainstorming; merge in `develop` sempre del PO; GitFlow senza hotfix; test modificabili da chi implementa.

**Razionale.** I file Markdown sono versionati con il codice e leggibili da ogni figura. Il brainstorming diretto è l'unico vero 1to1 possibile. Il merge automatico in `develop` riduce le attese del PO, che controlla il passaggio a `main`. La separazione tra chi scrive i test e chi scrive il codice protegge il significato dei test.

**Conseguenze.** L'Organizzatore ha gli strumenti `execute` (git, gh) e `agent`. Il ruleset di GitHub deve imporre l'approvazione del PO su `main`. ⚠️ Da verificare con P-13: nomi dei rami di Spec Kit rispetto a `feature/*`.

**Fonti.** [S-165](Sources.md#s-165), [S-167](Sources.md#s-167), [S-168](Sources.md#s-168), [S-169](Sources.md#s-169), [S-080](Sources.md#s-080).

---

<a id="d-036"></a>
## D-036 — Regole di scrittura originali ispirate ad ASD-STE100

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO (brainstorming del 2026-11-14)

**Contesto.** Il Pianificatore deve dare allo Scrittore regole e un dizionario basati su ASD-STE100. Il PO può consultare lo standard ma non condividerlo; il repository è pubblico.

**Opzioni considerate.** (1) Regole originali in italiano e dizionario dei termini del progetto, nel repository, con riferimenti solo all'indice dello standard. (2) File locale escluso da git, più vicino allo standard. (3) Solo dizionario di progetto.

**Decisione.** Opzione 1: `examples/agents/docs/team/writing-rules.md` contiene 16 regole originali e un dizionario iniziale. Le istruzioni del Pianificatore vietano di copiare testo dello standard.

**Razionale.** Lo Scrittore ha bisogno delle regole nel repository per applicarle. Un testo originale rispetta il vincolo di riservatezza.

**Conseguenze.** Il Pianificatore estende il dizionario a ogni progetto. Le regole non sostituiscono lo standard e non lo riproducono.

**Fonti.** [S-092](Sources.md#s-092).

---

<a id="d-037"></a>
## D-037 — Team di agenti: modelli per figura dopo la verifica P-12

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("Luna per il codice, GLM per i test"; "Resta DeepSeek V4.1 Flash") — **Sostituisce:** [D-034](#d-034)

**Contesto.** La verifica P-12 ha confermato i prezzi Anthropic e ha trovato tre problemi nei modelli di D-034: `gpt-5.4-mini` è della generazione precedente e costa 0,75 / 4,50 USD per 1M token; `qwen/qwen3-coder` ha il 46,2% su τ²-Bench per le chiamate agli strumenti; Anthropic presenta `claude-haiku-5-5` per classificazione, estrazione e instradamento, non per il coding. `gpt-5.3-codex` è deprecato.

**Opzioni considerate.** (1) Mantenere D-034. (2) `gpt-6-luna` per Sviluppatore e Operativo, `z-ai/glm-5.3` per il Tester, `qwen/qwen3.5-397b-a17b` per il Reviewer antagonista. (3) `google/gemini-3.5-flash-lite` per il Reviewer antagonista (più stabile, 78,3%).

**Decisione.** Opzione 2:

| Figura | Modello | Effort | Prezzo input / output (USD per 1M token) |
|---|---|---|---|
| Pianificatore | `claude-fable-5-2` | `high` | 8 / 40 |
| Organizzatore | `claude-sonnet-5-5` | default | 2 / 10 |
| Avversario | `gpt-6.1-sol` | `low` | 2 / 10 |
| Sviluppatore, Operativo | `gpt-6-luna` | default | 0,10 / 0,50 |
| Tester | `z-ai/glm-5.3` (OpenRouter) | default | 0,0699 / 1,40 |
| Scrittore | `claude-haiku-5-5` | default | 0,10 / 0,50 fino a 100K token di prompt |
| Reviewer ottimista | `deepseek/deepseek-v4.1-flash` (OpenRouter) | default | 0,0507 / 0,2028 |
| Reviewer antagonista | `qwen/qwen3.5-397b-a17b` (OpenRouter), provider `novita` → `venice` → `gmicloud` | default | 0,39 / 2,34 |

**Razionale.** `gpt-6-luna` costa meno di `gpt-5.4-mini` ed è della generazione corrente. `z-ai/glm-5.3` è presentato per l'ingegneria del software e ha il 77,3% su τ²-Bench. `qwen/qwen3.5-397b-a17b` ha il 79,1%; i tre provider scelti hanno il tasso di errore più basso nelle chiamate agli strumenti (settimana 7–14 novembre 2026). I due Reviewer restano su modelli diversi.

**Conseguenze.** Tre figure usano OpenRouter: i guardrail dell'account sono necessari per il codice riservato. ⚠️ I punteggi e i tassi di errore vengono da P-12 e non sono stati riletti dall'assistente. ⚠️ `modelOptions.provider` in `chatLanguageModels.native.json` va provato. I prezzi cambiano.

**Fonti.** [S-040](Sources.md#s-040), [S-102](Sources.md#s-102), [S-151](Sources.md#s-151), [S-115](Sources.md#s-115), [P-12](Review-Perplexity.md#registro-degli-esiti).

---

<a id="d-038"></a>
## D-038 — Definition of Done per Epic e Feature; criteri di accettazione verificabili

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("lo sviluppo é concluso solo quando la Definition of Done è completata")

**Contesto.** Il template chiudeva Feature ed Epic con una sezione «Chiusura» di due righe e con criteri di accettazione generici. Il PO segnala che i criteri di accettazione così definiti sono poco chiari e che gli sviluppatori li sottovalutano. Il PO chiede una Definition of Done evidente e aderente alla sua definizione formale, come obiettivo nei file `epic.md` e `feature.md` e come vincolo nelle review.

**Opzioni considerate.** (1) Rafforzare solo i criteri di accettazione. (2) Definition of Done come tabella con evidenze in `epic.md` e `feature.md`, controllata dai Reviewer, più criteri di accettazione in forma «Dato / quando / allora». (3) Definition of Done unica per tutto il progetto in un solo file.

**Decisione.** Opzione 2:

- `backlog.md` definisce le voci standard: da DoD-F1 a DoD-F9 per una Feature, da DoD-E1 a DoD-E8 per un'Epic, ognuna con l'evidenza richiesta e chi la verifica;
- i modelli `templates/epic.md` e `templates/feature.md` aprono con l'obiettivo di completamento e contengono la tabella;
- l'Organizzatore compila le evidenze; i due Reviewer non approvano con una voce `non soddisfatta` o `senza evidenza`; il merge e lo stato `done` richiedono la Definition of Done completa;
- solo il PO può togliere una voce;
- i criteri di accettazione dei Task hanno la forma «Dato…, quando…, allora…», un campo **Verifica** e almeno un criterio per gli errori.

**Razionale.** La Scrum Guide definisce la Definition of Done come descrizione formale dello stato richiesto e dice che un lavoro che non la rispetta non si rilascia. Una tabella con evidenze rende il controllo oggettivo anche per un modello economico. Due livelli separati evitano di confondere «il Task funziona» con «la Feature è finita».

**Conseguenze.** Più lavoro per l'Organizzatore prima delle review. Dopo il merge serve una PR per registrare DoD-F8 e DoD-F9. I Reviewer non eseguono comandi: controllano le evidenze contro i file. La Scrum Guide applica la Definition of Done all'Increment: l'uso per Feature ed Epic è un adattamento di questo template.

**Fonti.** [S-170](Sources.md#s-170).

---

<a id="d-039"></a>
## D-039 — Protezione di `main` e `develop`: due ruleset, CODEOWNERS e identità separata per l'agente

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("Configurazione + spec come esempio"; "Identità separata")

**Contesto.** P-13 ha mostrato che un ruleset non può nominare un utente e che `gh pr merge --admin` o un bypass possono saltare le regole. Il PO ha prodotto con Spec Kit 1.4.0 e Perplexity un pacchetto: due ruleset, `CODEOWNERS`, CI, script di applicazione, specifica, piano e test di verifica.

**Opzioni considerate.** (1) Solo la descrizione in `gitflow.md`. (2) File di configurazione nel template e specifica, piano e test come caso svolto. (3) Tutto il pacchetto nel template. Per l'identità: (a) token del PO; (b) identità separata senza bypass.

**Decisione.** Opzione 2 con (b):

- nel template `examples/agents/`: `.github/rulesets/main-develop.json`, `.github/rulesets/main-release-approval.json`, `.github/CODEOWNERS`, `.github/workflows/ci.yml`, `scripts/Set-Rulesets.ps1`, `.specify/extensions/git/git-config.yml`;
- in `examples/speckit-ruleset/`: `spec.md`, `plan.md`, contratto, checklist, test Pester `Live` e workflow di verifica;
- l'agente usa una GitHub App o un account di servizio con *Contents: write* e *Pull requests: write*, senza *Administration* e senza bypass; il PO è l'unico code owner e approva le PR verso `main`.

**Razionale.** Le istruzioni di un agente non sono un controllo: il rifiuto deve venire da GitHub. Con il token del PO l'agente avrebbe i diritti del PO. Il caso svolto mostra il metodo spec-driven su un problema reale.

**Conseguenze.** ⚠️ Niente è stato provato su GitHub: tutti i file sono marcati «non provato». Lo script richiede un'organizzazione con un team di emergenza. Con il piano Free i ruleset funzionano solo nei repository pubblici. `integration_id` 15368 va controllato. `ci.yml` richiede una soluzione .NET nella radice. I nomi `contoso`, `release-approver` e simili sono esempi.

**Fonti.** [S-171](Sources.md#s-171), [S-172](Sources.md#s-172), [S-173](Sources.md#s-173), [S-174](Sources.md#s-174), [S-175](Sources.md#s-175), [S-176](Sources.md#s-176), [S-177](Sources.md#s-177), [P-13](Review-Perplexity.md#registro-degli-esiti).

---

<a id="d-040"></a>
## D-040 — Rami di Feature con il nome creato da Spec Kit

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("accetto D-040 allineamoci allo standard Spec Kit"); proposta dell'assistente

**Contesto.** La prima versione di `gitflow.md` nominava i rami `feature/<epic>-<feature>-<nome>`; [D-035](#d-035) lasciava il punto da verificare. L'estensione `git` di Spec Kit 1.4.0 crea `feature/<NNN>-<slug>` con `branch_prefix: "feature"`: l'ultimo segmento deve iniziare con il numero. I due formati non coincidono. Spec Kit non ha una corrispondenza ufficiale con Epic, Feature e Task.

**Opzioni considerate.** (1) Il ramo è quello di Spec Kit; `feature.md` registra ramo e cartella `specs/<NNN>-<slug>/`; gli ID `E<nn>-F<nn>` restano nel backlog. (2) Rami con l'ID del backlog, creati a mano, senza l'estensione `git`. (3) Un template di ramo che contiene i due identificativi.

**Decisione.** Opzione 1. Una cartella `specs/<NNN>-<slug>/` corrisponde a una Feature del backlog.

**Razionale.** Un solo strumento crea i rami; nessun passo manuale. Il collegamento tra i due identificativi è nel front matter di `feature.md`.

**Conseguenze.** Il nome del ramo non mostra l'Epic. `gitflow.md`, `backlog.md`, i modelli e `git-config.yml` usano già questo formato. ⚠️ Il comando `specify extension add git` va provato: la rilettura diretta del README di Spec Kit non lo mostra.

**Fonti.** [S-080](Sources.md#s-080), [P-13](Review-Perplexity.md#registro-degli-esiti).

---

<a id="d-041"></a>
## D-041 — Due documenti nuovi: BYOK in GitHub Copilot e introduzione a LiteLLM

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("aggiungi nel docs del sito due documenti")

**Contesto.** Il documento 02 descrive la procedura di configurazione. Il PO chiede due documenti di concetto per il sito: una descrizione più dettagliata del BYOK in GitHub Copilot e un'introduzione a LiteLLM con le feature del rilascio stable.

**Opzioni considerate.** (1) Ampliare il documento 02. (2) Due documenti nuovi, `06-BYOK-GitHub-Copilot.md` e `07-LiteLLM-Introduzione.md`, collegati da 02 e 05.

**Decisione.** Opzione 2. I due documenti entrano nelle pagine del sito offline.

**Razionale.** Il documento 02 è una procedura: i concetti in documenti separati si leggono senza seguire i passi. Lo scopo è didattico.

**Conseguenze.** ⚠️ La documentazione di LiteLLM non è divisa per versione: il documento 07 elenca le feature della documentazione corrente con la 1.108.2 come riferimento. ⚠️ La prova LTS dura un mese: il documento 07 va riletto prima del talk. Alcune feature raccomandate (SSO) sono Enterprise.

**Fonti.** [S-015](Sources.md#s-015), [S-071](Sources.md#s-071), [S-182](Sources.md#s-182), [S-183](Sources.md#s-183), [S-184](Sources.md#s-184), [S-185](Sources.md#s-185), [S-186](Sources.md#s-186), [S-187](Sources.md#s-187), [S-119](Sources.md#s-119).

---

<a id="d-042"></a>
## D-042 — Runbook: fase F9 per il team di agenti; la chiusura diventa F10

- **Data:** 2026-11-14 — **Stato:** Accepted — **Decisore:** PO ("Il runbook e il deck non contengono ancora la fase del team di agenti")

**Contesto.** Il runbook ([D-026](#d-026)) ha le fasi F1–F9; F9 è la chiusura (revoca delle chiavi, esportazione delle evidenze). L'installazione e la prova del team di agenti non hanno passi.

**Opzioni considerate.** (1) Nuova fase dopo la chiusura. (2) Nuova fase F9 «Team di agenti» prima della chiusura, che diventa F10. (3) Un secondo runbook.

**Decisione.** Opzione 2. La fase F9 ha i passi S-911…S-921. La chiusura è la fase F10 con i passi S-1001 e S-1002. Gli identificativi S-901 e S-902 non si riusano. Nuovi parametri: `TEAM_PROJECT`, `GH_OWNER`, `GH_REPO`, `PO_USER`. Il default di `SPECKIT_VERSION` diventa `1.4.0`.

**Razionale.** La revoca delle chiavi deve restare l'ultima azione. Un identificativo riusato collegherebbe le evidenze di una sessione salvata a un passo diverso.

**Conseguenze.** Una sessione salvata prima di questa modifica perde lo stato dei due passi di chiusura. ⚠️ I passi S-917, S-918 e S-921 usano ruleset e script non provati su GitHub. ⚠️ La versione di Spec Kit non è confermata dalla rilettura diretta ([Review-Perplexity.md](Review-Perplexity.md#registro-degli-esiti)).

**Fonti.** [S-080](Sources.md#s-080), [S-171](Sources.md#s-171), [S-174](Sources.md#s-174), [S-175](Sources.md#s-175).

---

<a id="d-043"></a>
## D-043 — Strumenti del Pianificatore e permessi dell'identità dell'agente dopo la review

- **Data:** 2026-11-14 — **Stato:** Proposed — **Decisore:** assistente; il PO deve confermare

**Contesto.** La review della PR #4 ha trovato due problemi. (1) R6-agy-03: il Pianificatore deve eseguire `/speckit-specify`, che lancia uno script e crea il ramo `feature/<NNN>-<slug>` ([D-040](#d-040)), ma non aveva lo strumento `execute`. (2) R6-agy-01: `ci.yml` gira dal ramo della PR e `develop` non richiede approvazioni; un'identità che può modificare il workflow o i test può rendere verdi i controlli richiesti dai ruleset ([D-039](#d-039)).

**Opzioni considerate.** Per (1): (a) `execute` al Pianificatore, senza `web`; (b) `execute` e `web` insieme; (c) spostare `/speckit-specify` all'Organizzatore. Per (2): (a) nessun permesso *Workflows* all'identità dell'agente, più controllo del Reviewer antagonista; (b) come (a), più approvazione di un code owner su `develop` per `.github/**` e `scripts/**`; (c) approvazione del PO su ogni PR verso `develop`.

**Decisione proposta.** (1a) e (2a):

- il Pianificatore ha `read`, `search`, `edit`, `execute`, `agent`, `todo`; usa il terminale solo per gli script di Spec Kit e per il ramo della pianificazione; nessuna figura ha `web`;
- l'identità dell'agente non ha il permesso *Workflows*; l'Organizzatore non modifica `.github/` e `scripts/Set-Rulesets.ps1`; il Reviewer antagonista assegna severità `alta` a ogni modifica in `.github/` e a ogni test cancellato o reso sempre verde.

**Razionale.** La specifica è lavoro del modello più capace: resta al Pianificatore. Un agente con `web` ed `execute` insieme può eseguire istruzioni lette da una pagina. Senza *Workflows* GitHub rifiuta il push che modifica un workflow: è un controllo di GitHub, non un'istruzione. Le opzioni (2b) e (2c) cambiano la scelta del PO sul merge in `develop` ([D-035](#d-035)).

**Conseguenze.** Il Pianificatore non fa ricerche sul web: le chiede al PO. ⚠️ Resta il rischio di test modificati in una PR verso `develop`: lo copre solo la review. ⚠️ Il rifiuto del push senza il permesso *Workflows* va provato. Se il PO sceglie (2b) o (2c) cambiano `main-develop.json`, `CODEOWNERS` e il ruolo dell'Organizzatore nel merge.

**Fonti.** [S-072](Sources.md#s-072), [S-172](Sources.md#s-172), [S-173](Sources.md#s-173), [S-177](Sources.md#s-177), review R6-agy-01 e R6-agy-03 della PR #4.
