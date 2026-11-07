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
| [D-027](#d-027) | 2026-11-07 | Nerd Fonts in WOFF2 nel repository | Accepted |
| [D-028](#d-028) | 2026-11-07 | Architettura del sito offline e delle evidenze | Accepted |
| [D-029](#d-029) | 2026-11-07 | Deck finale come artefatto Slides | Accepted |
| [D-030](#d-030) | 2026-11-07 | PostgreSQL locale per il percorso uv con profilo esteso | Accepted |
| [D-031](#d-031) | 2026-11-07 | Diagrammi Mermaid disegnati nel sito offline | Accepted |

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

- **Data:** 2026-11-07 — **Stato:** Accepted — **Decisore:** PO ("WOFF2 nel repo")

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
