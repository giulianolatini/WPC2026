# 03 — Security: best practice per VS Code, GitHub Copilot e LiteLLM

Questo documento raccoglie le best practice di sicurezza della documentazione Microsoft (VS Code, GitHub) e LiteLLM ([D-022](Decisions.md#d-022)).
Ogni regola indica il **comportamento corretto** e, quando esiste, la **configurazione sicura**.

L'analisi delle configurazioni di esempio rispetto a OWASP e ISO/IEC 27001 è in [04-Security-Review-OWASP-ISO27001.md](04-Security-Review-OWASP-ISO27001.md).

## Indice

1. [Principi](#1-principi)
2. [Visual Studio Code](#2-visual-studio-code)
3. [GitHub Copilot in VS Code](#3-github-copilot-in-vs-code)
4. [Policy enterprise](#4-policy-enterprise)
5. [LiteLLM proxy](#5-litellm-proxy)
6. [Chiavi API dei provider](#6-chiavi-api-dei-provider)
7. [Baseline di configurazione](#7-baseline-di-configurazione)
8. [Checklist rapida](#8-checklist-rapida)

---

## 1. Principi

| # | Principio | Applicazione |
|---|-----------|--------------|
| P1 | **Il contenuto è dato, non istruzione.** Output dei tool, pagine web, file del repo e risposte MCP possono contenere istruzioni ostili (*prompt injection*) | Workspace Trust, approvazione delle fetch, review delle modifiche ([S-130](Sources.md#s-130)) |
| P2 | **Minimo privilegio per l'agente** (*least agency*) | Approvazioni manuali, sandbox, niente auto-approvazione globale ([S-130](Sources.md#s-130), [S-138](Sources.md#s-138)) |
| P3 | **Le istruzioni guidano, non impongono.** `copilot-instructions.md` e skill non sono controlli di sicurezza | I controlli sono policy, sandbox, hook, permessi del sistema operativo ([S-130](Sources.md#s-130)) |
| P4 | **Difesa a livelli.** Nessun controllo è sufficiente da solo | Restricted Mode + approvazioni + sandbox + review ([S-130](Sources.md#s-130)) |
| P5 | **Segreti fuori dal contesto del modello** | Niente chiavi in file del workspace o nell'output del terminale ([S-130](Sources.md#s-130)) |
| P6 | **Versioni fissate e verificate** | Pin di versione e digest, firma cosign ([S-108](Sources.md#s-108), [S-109](Sources.md#s-109)) |

---

## 2. Visual Studio Code

### 2.1 Workspace Trust

**Comportamento corretto**

- [ ] Apri ogni cartella sconosciuta in **Restricted Mode**. In Restricted Mode gli agenti, il terminale, i task, il debug e le impostazioni del workspace sono disattivati o limitati ([S-133](Sources.md#s-133)).
- [ ] Concedi la fiducia solo a cartelle di autori fidati. Se hai dubbi, resta in Restricted Mode ([S-133](Sources.md#s-133)).
- [ ] Tieni i repository sconosciuti in una cartella padre separata e non fidata ([S-133](Sources.md#s-133)).
- [ ] Prima di concedere la fiducia, leggi `.vscode/mcp.json` e `.mcp.json`: le configurazioni MCP del repo ereditano Workspace Trust ([S-130](Sources.md#s-130)).

**Configurazione sicura** ([S-133](Sources.md#s-133))

| Setting | Valore sicuro | Default |
|---------|---------------|---------|
| `security.workspace.trust.enabled` | `true` | `true` |
| `security.workspace.trust.startupPrompt` | `once` | `never` |
| `security.workspace.trust.emptyWindow` | `false` | `true` |
| `security.workspace.trust.untrustedFiles` | `prompt` | `prompt` |
| `terminal.integrated.allowInUntrustedWorkspace` | `false` | `false` |

> Non usare `--disable-workspace-trust` e non forzare `extensions.supportUntrustedWorkspaces` senza un motivo documentato ([S-133](Sources.md#s-133)).

### 2.2 Estensioni

- [ ] Installa estensioni solo da publisher fidati. Workspace Trust non impedisce a un'estensione malevola di eseguire codice ([S-133](Sources.md#s-133)).
- [ ] Usa estensioni ufficiali per i provider (es. *Hugging Face Provider*, *Ollama*) ([D-008](Decisions.md#d-008)).
- [ ] In azienda limita i marketplace di plugin con le policy `ChatStrictMarketplaces` e `ChatExtraMarketplaces` ([S-131](Sources.md#s-131)).

### 2.3 Connessioni remote

- [ ] Connettiti solo da client fidati. Richiedi autenticazione per i tunnel. Proteggi credenziali SSH e account dei tunnel ([S-130](Sources.md#s-130)).
- [ ] Ricorda: la disconnessione non ferma i task in esecuzione ([S-130](Sources.md#s-130)).

---

## 3. GitHub Copilot in VS Code

### 3.1 Approvazione di tool e modifiche

**Comportamento corretto** ([S-130](Sources.md#s-130))

- [ ] Usa il livello **Manual permissions** per la demo e per repository sensibili. *Allow all* e *Autopilot* eliminano le conferme. Nell'harness Copilot *Autopilot* è una modalità dell'agente; nell'harness Local è un livello di permesso (P-09).
- [ ] Concedi i permessi a livello di **sessione**: scadono con la sessione. I permessi di workspace o utente restano.
- [ ] Controlla ogni modifica nel diff editor prima del commit. Le modifiche fatte con comandi di terminale non sono nel working set dell'editor: controllale a parte.
- [ ] Non usare `chat.tools.global.autoApprove`: elimina tutte le approvazioni.

**Configurazione sicura** ([S-130](Sources.md#s-130))

```jsonc
{
  // Richiedi approvazione per le modifiche ai file sensibili
  "chat.tools.edits.autoApprove": {
    "**/.env": false,
    "**/.env.*": false,
    "**/*.pem": false,
    "**/.github/workflows/**": false,
    "**/.vscode/*.json": false
  },
  "chat.tools.global.autoApprove": false
}
```

### 3.2 Terminale

- [ ] Usa l'auto-approvazione del terminale solo con regole per comandi sicuri e precisi. Ogni sottocomando di un comando composto deve corrispondere a una regola ([S-130](Sources.md#s-130)).
- [ ] Non affidarti solo alle regole: alias, concatenazione di stringhe e sintassi complessa possono aggirarle ([S-130](Sources.md#s-130)).

### 3.3 Sandbox dell'agente

- [ ] **Attiva la sandbox**: `chat.agent.sandbox.enabled` vale `off` di default su tutte le piattaforme. Imposta `"on"` ([S-145](Sources.md#s-145)).
- [ ] Controlla i requisiti: macOS 15+; Linux glibc o WSL2 con bubblewrap ≥ 0.5.0, slirp4netns, util-linux ≥ 2.35; Windows 11 (sperimentale). Non supportati: WSL1, Alpine e altre distribuzioni musl ([S-145](Sources.md#s-145)).
- [ ] Limita la rete in uscita: `chat.agent.sandbox.network.allowNetwork` è `true` di default. Con `false` la rete è bloccata, anche per il browser integrato. Con `true` limita le destinazioni con `chat.agent.sandbox.network.allowedDomains` e `deniedDomains` (i negati prevalgono) ([S-145](Sources.md#s-145)).
- [ ] Verifica la policy effettiva con `/sandbox policy` in chat: la documentazione non dice se `allowedDomains` è una allowlist esclusiva ([S-145](Sources.md#s-145)).
- [ ] Su Windows, proxy e restrizioni per hostname richiedono `chat.agent.sandbox.network.allowLocalNetwork: true` ([S-145](Sources.md#s-145)).
- [ ] I server MCP avviati in locale girano nella sandbox (`chat.agent.sandbox.mcpServers`, default `true`) ([S-145](Sources.md#s-145)).
- [ ] Ricorda i limiti: la sandbox non è una VM né un confine di account. Credenziali iniettate, rete libera e fallback senza sandbox la indeboliscono. Un dev container aggiunge un confine ([S-130](Sources.md#s-130)).

### 3.4 MCP server

- [ ] Verifica la fonte di ogni MCP server prima di avviarlo ([S-130](Sources.md#s-130)).
- [ ] Richiedi l'approvazione per le chiamate ai tool MCP e limita lo scope dell'approvazione ([S-130](Sources.md#s-130)).
- [ ] Con server MCP stdio in sandbox (macOS, Linux) le chiamate sono auto-approvate: limita percorsi e domini consentiti ([S-130](Sources.md#s-130)).
- [ ] I parametri MCP sensibili vanno nelle variabili di input: VS Code li salva nel secure credentials store ([S-130](Sources.md#s-130)).

### 3.5 Fetch e contenuti web

- [ ] Approva prima il **dominio** (Trusted Domains), poi controlla il **contenuto** scaricato prima che il modello lo veda ([S-130](Sources.md#s-130)).

### 3.6 Prompt injection

- [ ] Considera non fidati l'output dei tool e le pagine web. Le istruzioni ostili si nascondono in commenti e formattazione ([S-130](Sources.md#s-130)).
- [ ] Gli hook (`preToolUse`) possono negare chiamate, ma non coprono ogni tool e ogni forma di argomento. Prova la copertura e il comportamento in caso di errore ([S-130](Sources.md#s-130), [S-006](Sources.md#s-006)).
- [ ] Non usare impostazioni di bypass come `allowDangerouslySkipPermissions` (harness Claude), salvo in ambienti isolati ([S-130](Sources.md#s-130)).

### 3.7 Segreti e dati

- [ ] Tieni chiavi e credenziali fuori dai file del workspace e dall'output del terminale: il contesto inviato al modello può includerli ([S-130](Sources.md#s-130)).
- [ ] Nei modelli BYOK usa `"${input:...}"` per `apiKey`: la chiave resta nel secret storage di VS Code ([S-001](Sources.md#s-001)).
- [ ] (Business/Enterprise) Configura la **content exclusion** per file sensibili, ad esempio `"*": ["**/.env"]`. Vale anche per gli agenti in VS Code. Limiti: accessi indiretti, symlink, filesystem remoti e server MCP di terzi non sono garantiti; non sostituisce i permessi del sistema operativo; le modifiche richiedono fino a 30 minuti o un reload della finestra ([S-134](Sources.md#s-134), P-09).
- [ ] ⚠️ **Content exclusion e BYOK:** nessuna fonte dice che l'esclusione vale per i modelli BYOK. La policy arriva da GitHub con l'account: senza login, nell'harness Local, è probabile che non sia applicata (P-09). Per i file sensibili usa anche `chat.tools.edits.autoApprove` e i permessi del sistema operativo.
- [ ] Con BYOK i dati vanno al provider scelto. Verifica le condizioni del provider (conservazione, zero data retention) prima di inviare codice riservato ([S-015](Sources.md#s-015)).

---

## 4. Policy enterprise

Le policy si distribuiscono con Group Policy, Microsoft Intune o profili di configurazione macOS ([S-131](Sources.md#s-131), [S-132](Sources.md#s-132)).

| Rischio | Policy | Effetto | Fonte |
|---------|--------|---------|-------|
| Account non aziendali | `ChatApprovedAccountOrganizations` | Limita le funzioni AI alle organizzazioni GitHub approvate | [S-131](Sources.md#s-131) |
| Auto-approvazione globale | `ChatToolsAutoApprove` | Blocca l'auto-approvazione globale | [S-130](Sources.md#s-130) |
| Tool critici | `ChatToolsEligibleForAutoApproval` | Approvazione manuale obbligatoria per tool specifici | [S-130](Sources.md#s-130) |
| Terminale | `ChatToolsTerminalEnableAutoApprove` | Disattiva l'auto-approvazione a regole | [S-130](Sources.md#s-130) |
| MCP non controllati | `ChatMCP` (`registryOnly` o `off`), `McpGalleryServiceUrl` | Solo registry privato o nessun MCP | [S-130](Sources.md#s-130) |
| Tool di estensioni | `ChatAgentExtensionTools` | Blocca i tool forniti da estensioni | [S-130](Sources.md#s-130) |
| Rete dell'agente | `ChatAgentNetworkFilter`, `ChatAgentAllowedNetworkDomains`, `ChatAgentDeniedNetworkDomains` | Filtro per dominio; i domini negati hanno precedenza | [S-131](Sources.md#s-131) |
| Hook non gestiti | `ChatAllowManagedHooksOnly` | Solo hook da fonti gestite | [S-131](Sources.md#s-131) |
| Customization non gestite | `ChatStrictPluginOnlyCustomization` | Blocca customization utente e workspace fuori dai plugin | [S-131](Sources.md#s-131) |
| Harness di terze parti | `Claude3PIntegration`, `Codex3PIntegration` | Controlla gli harness Claude e Codex | [S-131](Sources.md#s-131) |
| BYOK | *Bring Your Own Language Model Key in VS Code* (GitHub.com) | Disattiva il BYOK locale | [S-018](Sources.md#s-018) |
| Osservabilità | `CopilotOtel*` | Export OpenTelemetry | [S-131](Sources.md#s-131) |

> ⚠️ Le sessioni dell'harness Copilot non applicano completamente tre policy ([S-130](Sources.md#s-130), [S-131](Sources.md#s-131)): `ChatAgentMode` non toglie le opzioni dell'Agent Host dal selettore *Session Target*; `ChatMCP` non vale per i server MCP che il runtime Copilot scopre da solo; `ChatToolsEligibleForAutoApproval` toglie *Allow all*, ma *Assisted permissions* e le approvazioni salvate nella sessione possono ancora approvare il tool. I setting gestiti dall'enterprise in Copilot (`permissions.*`, `sandbox`, `allowedMcpServers`) hanno precedenza sulle policy del dispositivo (P-09). Le policy `ChatAgentSandbox*` sono deprecate e valgono solo per l'harness Local ([S-131](Sources.md#s-131)). Verifica le note dell'harness prima di affidarti a queste policy.

---

## 5. LiteLLM proxy

Fonti: [S-108](Sources.md#s-108) (Security Best Practices), [S-109](Sources.md#s-109) (Docker Image Security), [S-104](Sources.md#s-104) (incidente 2026-10-21).

### 5.1 Release e immagini

- [ ] Fissa una versione esatta o un digest. Mai `latest`, `main-latest`, `main-stable` ([S-108](Sources.md#s-108), [D-018](Decisions.md#d-018)).
- [ ] Verifica la firma dell'immagine con la chiave cosign del commit `e82a3c6`. Impronta SHA-256 di `cosign.pub`: `e3fe3e08c44b16407fe0b37c43b4f8b603b3a0f4ee74c29e647bc022d762c2c0` ([S-104](Sources.md#s-104), [S-109](Sources.md#s-109)). L'ordine dei passi è importante:

  1. Scarica `cosign.pub` e controlla la sua impronta SHA-256: una chiave non verificata non prova nulla.
  2. Esegui `docker pull` del tag e leggi il digest (`docker inspect … RepoDigests`).
  3. Esegui `cosign verify` sul **digest** (`@sha256:…`), non sul tag: il tag è mobile, il digest no.
  4. Usa nel deploy il digest verificato.

  Lo script [`scripts/pin-images.sh`](../examples/litellm/scripts/pin-images.sh) esegue i quattro passi:

```bash
./scripts/pin-images.sh        # stampa LITELLM_IMAGE=…@sha256:… e POSTGRES_IMAGE=…@sha256:… da copiare in .env
```

- [ ] Preferisci l'immagine `ghcr.io/berriai/litellm-non_root` ([S-109](Sources.md#s-109)).
- [ ] Segui gli avvisi di sicurezza del progetto e aggiorna alla release stabile ([S-108](Sources.md#s-108)).

### 5.2 Identità e privilegi

- [ ] Ruoli RBAC minimi; pochi `proxy_admin` ([S-108](Sources.md#s-108)).
- [ ] Agli utenti e ai workload solo **virtual keys** con scope; mai la master key ([S-108](Sources.md#s-108)).
- [ ] `general_settings.disable_env_credential_login: true` blocca il login della UI con `UI_USERNAME`/`UI_PASSWORD` e master key. Serve un utente `proxy_admin` con password (o l'SSO), altrimenti nessuno accede all'Admin UI ([S-108](Sources.md#s-108), [S-148](Sources.md#s-148)). La guida LiteLLM crea l'utente prima di attivare l'opzione. Gli esempi la attivano già in `config.yaml`: l'API accetta sempre la master key, quindi crei l'utente anche dopo l'avvio ([01 §5.2](01-Installazione.md#52-profilo-esteso-postgresql--admin-ui--virtual-keys)):
  1. Con la master key: `POST /user/new` con `user_role: proxy_admin` e `auto_create_key: false`.
  2. `POST /user/update` con la password (almeno 12 caratteri, maiuscole, minuscole, cifre, simboli).
  3. Verifica il login con email e password.

  Lo script [`scripts/bootstrap-admin.sh`](../examples/litellm/scripts/bootstrap-admin.sh) esegue i passi 1–2. Con SSO e `disable_password_login_when_sso_enabled` anche il `proxy_admin` di emergenza (`/fallback/login`) è bloccato ([S-148](Sources.md#s-148)).
- [ ] SSO per l'Admin UI; JWT per il traffico API; SCIM per il ciclo di vita degli utenti ([S-108](Sources.md#s-108)).
- [ ] Limiti di login falliti: imposta `general_settings.trusted_proxy_ranges` (CIDR dell'ingress, o `[]` con client diretti) ([S-108](Sources.md#s-108)).

### 5.3 Rete e TLS

- [ ] Bind su `127.0.0.1` per l'uso locale (il default è `0.0.0.0`) ([S-118](Sources.md#s-118)).
- [ ] In rete: rete privata, solo le route necessarie, TLS client→gateway e gateway→provider, verifica dei certificati attiva ([S-108](Sources.md#s-108)).
- [ ] Dietro un reverse proxy TLS: imposta `PROXY_BASE_URL` all'origine `https://` esatta ([S-108](Sources.md#s-108)).

### 5.4 Segreti, rotazione, audit

- [ ] Chiavi dei provider, `LITELLM_MASTER_KEY` e `LITELLM_SALT_KEY` in un secret store, mai in `config.yaml` (usa `os.environ/...`) ([S-108](Sources.md#s-108)).
- [ ] Ruota la master key con la procedura ufficiale. Non ruotare `LITELLM_SALT_KEY` dopo il salvataggio di credenziali ([S-108](Sources.md#s-108)).
- [ ] Attiva gli audit log e controlla le modifiche a chiavi, ruoli e team ([S-108](Sources.md#s-108)).
- [ ] Se hai eseguito `1.82.7`, `1.82.8` o `1.107.0`: considera rubate le credenziali e ruotale tutte ([S-104](Sources.md#s-104)).

### 5.5 Superficie esposta

- [ ] Disattiva la documentazione API in produzione: `NO_DOCS="True"`, `NO_REDOC="True"`, `NO_OPENAPI="True"` ([S-108](Sources.md#s-108)).
- [ ] Limita gli upload: `general_settings.allowed_file_extensions` (allowlist), `max_file_size_mb`, `max_request_size_mb` ([S-108](Sources.md#s-108)).
- [ ] Non mostrare l'header `Server` se un reverse proxy lo aggiunge ([S-108](Sources.md#s-108)).
- [ ] (Opzionale) Guardrail per contenuti e PII per chiave, team o modello ([S-108](Sources.md#s-108)).

### 5.6 Inoltro di header

- [ ] Non attivare `forward_llm_provider_auth_headers` senza motivo: LiteLLM inoltra `x-api-key` del client al provider (P-04).

---

## 6. Chiavi API dei provider

- [ ] Una chiave per scopo (demo, sviluppo, produzione); revocala dopo il talk.
- [ ] Imposta limiti di spesa nella console del provider, indipendenti dal gateway.
- [ ] Hugging Face: token *fine-grained* con il solo permesso *Make calls to Inference Providers* ([S-047](Sources.md#s-047)).
- [ ] OpenRouter: chiavi con limite di credito e guardrail di organizzazione (budget, allowlist di modelli, ZDR) ([S-115](Sources.md#s-115)).
- [ ] Hugging Face Router: fissa il provider di inferenza con il suffisso `:<provider>` per sapere chi tratta i dati; `:fastest` e `:cheapest` scelgono il provider in automatico ([S-047](Sources.md#s-047)).

---

## 7. Baseline di configurazione

File: [`examples/vscode/settings.secure.jsonc`](../examples/vscode/settings.secure.jsonc). Copialo in `.vscode/settings.json` o nelle impostazioni utente.

> La baseline **attiva** la sandbox (default `off`) e blocca la rete dell'agente. Se un agente deve scaricare pacchetti, imposta `allowNetwork: true` con `allowedDomains` espliciti invece della rete completa ([S-145](Sources.md#s-145)).

---

## 8. Checklist rapida

| # | Controllo | Dove |
|---|-----------|------|
| 1 | Restricted Mode per repo sconosciuti | VS Code |
| 2 | Manual permissions, nessuna auto-approvazione globale | Copilot |
| 3 | Sandbox attivata (`chat.agent.sandbox.enabled: "on"`), rete limitata | Copilot |
| 4 | MCP solo da fonti verificate, con approvazione | Copilot |
| 5 | Chiavi solo in `${input:...}` o secret store | VS Code, LiteLLM |
| 6 | LiteLLM con versione e digest fissati, firma verificata | LiteLLM |
| 7 | LiteLLM su `127.0.0.1`, virtual keys, niente master key agli utenti | LiteLLM |
| 8 | Documentazione API disattivata, limiti di upload | LiteLLM |
| 9 | Limiti di spesa nelle console dei provider | Provider |
| 10 | Policy enterprise distribuite e verificate per l'harness in uso | Organizzazione |
