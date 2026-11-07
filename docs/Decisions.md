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
| [D-004](#d-004) | 2026-11-07 | Piani Copilot: individuali e di organizzazione | Accepted |
| [D-005](#d-005) | 2026-11-07 | LiteLLM: profilo minimo e profilo esteso | Accepted |
| [D-006](#d-006) | 2026-11-07 | openSUSE: `zypper` al posto di YaST | Proposed |
| [D-007](#d-007) | 2026-11-07 | Provider *Custom Endpoint* al posto di `customOAIModels` | Proposed |
| [D-008](#d-008) | 2026-11-07 | Hugging Face nativo: estensione ufficiale HF | Proposed |
| [D-009](#d-009) | 2026-11-07 | Installazione di `uv` su Linux con installer ufficiale | Proposed |
| [D-010](#d-010) | 2026-11-07 | File di esempio in `examples/` | Proposed |
| [D-011](#d-011) | 2026-11-07 | GitHub Flow con rebase merge su `main` protetto | Accepted |
| [D-012](#d-012) | 2026-11-07 | Lingua italiana con regole ASD-STE100 adattate | Accepted |

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

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO

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

- **Data:** 2026-11-07 — **Stato:** Proposed — **Decisore:** assistente, conferma PO

**Contesto.** La richiesta cita `yast`. YaST è lo strumento di amministrazione (GUI/TUI) di openSUSE. Il package manager a riga di comando è `zypper`; YaST usa la stessa libreria.

**Opzioni considerate.** (1) Comandi `zypper`, con nota su YaST Software Management. (2) Procedura grafica YaST.

**Decisione.** Proponiamo l'opzione 1.

**Razionale.** Un comando è copiabile, ripetibile e registrabile nelle evidenze. La documentazione VS Code e la wiki openSUSE usano `zypper` ([S-009](Sources.md#s-009), [S-064](Sources.md#s-064)).

**Conseguenze.** Il documento d'installazione mostra `zypper` e cita YaST come alternativa grafica.

**Fonti.** [S-009](Sources.md#s-009), [S-064](Sources.md#s-064).

---

<a id="d-007"></a>
## D-007 — Provider *Custom Endpoint* al posto di `customOAIModels`

- **Data:** 2026-11-07 — **Stato:** Proposed — **Decisore:** assistente, conferma PO

**Contesto.** Molte guide in rete usano l'impostazione `github.copilot.chat.customOAIModels` o il provider *OpenAI Compatible*. La documentazione VS Code attuale li dichiara deprecati e li sostituisce con il provider *Custom Endpoint* (`vendor: customendpoint`), che supporta le API `chat-completions`, `responses` e `messages`.

**Opzioni considerate.** (1) Custom Endpoint. (2) `customOAIModels` deprecato.

**Decisione.** Proponiamo l'opzione 1 per OpenRouter, Hugging Face (alternativa all'estensione) e LiteLLM.

**Razionale.** Una configurazione deprecata può smettere di funzionare dopo il talk. Custom Endpoint permette di scegliere il formato API: con LiteLLM possiamo mostrare la stessa route in formato OpenAI e in formato Anthropic.

**Conseguenze.** Gli esempi usano `chatLanguageModels.json`. Le guide di terze parti con `customOAIModels` sono citate solo come contesto storico.

**Fonti.** [S-001](Sources.md#s-001).

---

<a id="d-008"></a>
## D-008 — Hugging Face nativo: estensione ufficiale HF

- **Data:** 2026-11-07 — **Stato:** Proposed — **Decisore:** assistente, conferma PO

**Contesto.** VS Code non ha un provider built-in Hugging Face. Hugging Face pubblica l'estensione *Hugging Face Provider for GitHub Copilot Chat*, che aggiunge un provider al Language Models editor. Il router HF è anche OpenAI-compatible.

**Opzioni considerate.** (1) Estensione ufficiale HF come configurazione "nativa". (2) Solo Custom Endpoint verso `router.huggingface.co/v1`. (3) Entrambe.

**Decisione.** Proponiamo l'opzione 3: l'estensione come percorso principale, il Custom Endpoint come alternativa senza estensione.

**Razionale.** L'estensione usa l'API ufficiale *Language Model Chat Provider* di VS Code ed è il percorso documentato da HF. Il Custom Endpoint mostra che lo stesso risultato non dipende da un'estensione.

**Conseguenze.** Il token HF deve essere *fine-grained* con il permesso *Make calls to Inference Providers* ([S-047](Sources.md#s-047)).

**Fonti.** [S-001](Sources.md#s-001), [S-047](Sources.md#s-047), [S-048](Sources.md#s-048), [S-049](Sources.md#s-049).

---

<a id="d-009"></a>
## D-009 — Installazione di `uv` su Linux con installer ufficiale

- **Data:** 2026-11-07 — **Stato:** Proposed — **Decisore:** assistente, conferma PO

**Contesto.** La richiesta chiede i package manager `apt` e `zypper`. La documentazione di `uv` non cita pacchetti di distribuzione Linux; cita `winget` e `brew`.

**Opzioni considerate.** (1) Installer ufficiale `astral.sh` su Linux. (2) Pacchetti di distribuzione, se presenti. (3) `pipx install uv`.

**Decisione.** Proponiamo l'opzione 1 su Linux; `winget` su Windows; `brew` su macOS.

**Razionale.** LiteLLM ≥ 1.84.0 richiede Python ≥ 3.10; `uv tool install` installa un Python compatibile ([S-021](Sources.md#s-021)). Un pacchetto di distribuzione può essere vecchio o assente.

**Conseguenze.** Su Linux il documento indica un'eccezione esplicita alla regola "solo package manager".

**Fonti.** [S-021](Sources.md#s-021), [S-060](Sources.md#s-060).

---

<a id="d-010"></a>
## D-010 — File di esempio in `examples/`

- **Data:** 2026-11-07 — **Stato:** Proposed — **Decisore:** assistente, conferma PO

**Contesto.** I documenti contengono configurazioni lunghe (`config.yaml`, Compose, `chatLanguageModels.json`, unit di servizio). Il pubblico deve poterle scaricare e usare.

**Opzioni considerate.** (1) Solo blocchi di codice nei documenti. (2) File pronti in `examples/` e blocchi di codice brevi nei documenti.

**Decisione.** Proponiamo l'opzione 2.

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
