# Review con Perplexity Pro — prompt di verifica

Questo documento contiene i prompt per la review preliminare con un LLM diverso (Perplexity Pro).
Lo scopo è confermare o confutare le affermazioni di [01-Installazione.md](01-Installazione.md) e [02-Configurazione-Copilot.md](02-Configurazione-Copilot.md).

## Procedura

- [ ] Esegui un prompt alla volta in Perplexity Pro, in un thread nuovo.
- [ ] Copia la risposta Markdown completa nella chat del progetto, con l'ID del prompt (es. `P-03`).
- [ ] L'assistente confronta la risposta con le fonti in [Sources.md](Sources.md) e registra l'esito.
- [ ] Le correzioni che cambiano una scelta diventano una nuova decisione in [Decisions.md](Decisions.md).

## Istruzioni comuni (incluse in ogni prompt)

Ogni prompt termina con questo blocco. Non rimuoverlo.

```text
FORMATO DELLA RISPOSTA
- Rispondi in italiano, Markdown. Nomi tecnici, comandi e setting in inglese.
- Data di riferimento: novembre 2026. Usa solo fonti consultate ora; indica la data di pubblicazione o aggiornamento di ogni fonte.
- Preferisci documentazione ufficiale. Tagga ogni fonte: [PRIMARY], [VENDOR-DOC], [OPINION].
- Per ogni affermazione numerata (A1, A2, …) dai: esito CONFERMATA / CONFUTATA / PARZIALE / NON VERIFICABILE, una frase di motivazione, l'URL della fonte.
- Se un'affermazione è confutata, scrivi il valore corretto (comando, nome di setting, ID modello, percorso).
- Chiudi con una tabella riepilogativa e con una sezione "Elementi che non ho considerato" (max 5 punti).
- Non inventare URL. Se non trovi una fonte, scrivi NON VERIFICABILE.
```

---

## P-01 — VS Code BYOK e provider Custom Endpoint

```text
Verifica lo stato attuale (novembre 2026) del Bring Your Own Key (BYOK) di GitHub Copilot in Visual Studio Code.
Affermazioni da verificare:
A1. Il Language Models editor si apre con il comando "Chat: Manage Language Models" o dall'ingranaggio del model picker.
A2. I provider built-in includono Anthropic, OpenAI, Gemini, Azure. È presente anche un provider built-in OpenRouter? Elenca i provider built-in attuali.
A3. Il provider "Custom Endpoint" (vendor "customendpoint") sostituisce il provider "OpenAI Compatible" e il setting "github.copilot.chat.customOAIModels", ora deprecati.
A4. Custom Endpoint supporta apiType "chat-completions", "responses", "messages"; proprietà dei modelli: id, name, url, toolCalling, vision, maxInputTokens, maxOutputTokens, editTools, thinking, streaming, requestHeaders.
A5. I dettagli dei modelli sono nel file chatLanguageModels.json. In quale percorso del profilo utente si trova su Windows, macOS, Linux?
A6. Con apiType "messages", quale header HTTP invia VS Code per apiKey: "x-api-key" o "Authorization: Bearer"?
A7. BYOK non copre inline suggestions, semantic search, embeddings; solo modelli con tool calling sono visibili agli agenti.
A8. Nelle sessioni Local i modelli BYOK funzionano senza login GitHub; nell'harness Copilot serve il setting sperimentale "chat.agentHost.byokModels.enabled".
A9. Setting per i modelli di utilità: "chat.utilityModel", "chat.utilitySmallModel", "chat.byokUtilityModelDefault". Quale formato di valore accettano (esempio)?
A10. Il provider built-in Ollama è deprecato a favore dell'estensione ufficiale Ollama.
Fonte di partenza: https://code.visualstudio.com/docs/copilot/customization/language-models
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-02 — Policy Copilot Business/Enterprise per BYOK

```text
Verifica le policy di GitHub Copilot per Business ed Enterprise sul BYOK (novembre 2026).
A1. Per gli utenti Business/Enterprise un amministratore deve abilitare la policy "Bring Your Own Language Model Key in VS Code". Nome esatto e percorso nelle impostazioni (organization ed enterprise).
A2. Esistono due meccanismi: "local BYOK" (chiavi sul client) ed "Enterprise BYOK" (public preview, chiavi lato server, policy "Enable custom models").
A3. I piani individuali (Free, Pro, Pro+) usano il BYOK locale senza policy. Ci sono limiti per il piano Free?
A4. L'uso di modelli BYOK consuma premium requests di Copilot? Come è fatturato?
A5. Quali clienti supportano il local BYOK (VS Code, JetBrains, Xcode, Copilot CLI, …)?
Fonti di partenza: https://docs.github.com/en/copilot/concepts/models/bring-your-own-key ; https://docs.github.com/en/copilot/how-tos/administer-copilot/manage-for-organization/manage-policies
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-03 — Architettura delle customizations e filesystem

```text
Verifica l'organizzazione delle customizations di GitHub Copilot in VS Code (novembre 2026) e il concetto di "harness".
A1. Gli harness sono Copilot, Claude, Codex; esiste anche la sessione "Local". Spiega la differenza e quale supporta BYOK.
A2. Percorsi workspace: .github/copilot-instructions.md, AGENTS.md, CLAUDE.md, .github/instructions/*.instructions.md (frontmatter applyTo, description), .github/prompts/*.prompt.md, .github/agents/*.agent.md, .github/skills/<nome>/SKILL.md, .github/hooks/*.json, .vscode/mcp.json (chiave "servers").
A3. Percorsi utente: ~/.copilot/skills, ~/.claude/skills, ~/.agents/skills; ~/.copilot/hooks; ~/.copilot/settings.json. Quali sono i percorsi utente per instructions, prompt files, agents e mcp.json?
A4. SKILL.md: name (minuscole, numeri, trattini, max 64, uguale alla cartella), description (max 1024), argument-hint, user-invocable, disable-model-invocation, context: fork.
A5. Eventi hooks: sessionStart, userPromptSubmitted, preToolUse, postToolUse, preCompact, subagentStart, subagentStop, agentStop, sessionEnd.
A6. Frontmatter custom agent: name, description, tools, handoffs (label, agent, prompt, send), user-invocable, disable-model-invocation, model, target.
Fonte di partenza: https://code.visualstudio.com/docs/copilot/customization/overview
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-04 — LiteLLM proxy: installazione, deploy, servizio

```text
Verifica l'installazione e il deploy di LiteLLM proxy (novembre 2026).
A1. Il metodo raccomandato di installazione locale è `uv tool install 'litellm[proxy]'`; LiteLLM >= 1.84.0 richiede Python >= 3.10.
A2. Immagini Docker: ghcr.io/berriai/litellm e il mirror docker.litellm.ai/berriai/litellm. Qual è l'ultimo tag stabile consigliato? Esistono tag "main-stable" o suffissi "-stable"?
A3. Variabili: LITELLM_MASTER_KEY (obbligatoria, password admin della UI), LITELLM_SALT_KEY (non rigenerabile), DATABASE_URL (postgresql://user:password@host:5432/litellm), STORE_MODEL_IN_DB.
A4. Endpoint di health: /health/liveliness e /health/readiness. /health richiede autenticazione?
A5. Il proxy espone /v1/chat/completions, /v1/responses (bridge per Anthropic e Gemini) e /v1/messages (formato Anthropic anche per modelli non Anthropic). /v1/messages accetta "Authorization: Bearer" oltre a "x-api-key"?
A6. Le opzioni CLI `--host` e `--port` esistono? Default host 0.0.0.0, porta 4000?
A7. Esiste una guida ufficiale per eseguire LiteLLM come servizio (systemd, launchd, Windows service)?
A8. Ci sono stati incidenti di sicurezza o supply chain sul pacchetto PyPI o sulle immagini LiteLLM nel 2025–2026? Quali versioni evitare?
Fonti di partenza: https://docs.litellm.ai/docs/proxy/docker_quick_start ; https://docs.litellm.ai/docs/proxy/deploy
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-05 — Provider: endpoint e ID dei modelli

```text
Verifica endpoint e ID modello correnti (novembre 2026) per l'uso via API con chiave.
A1. Anthropic: endpoint https://api.anthropic.com/v1/messages, header x-api-key e anthropic-version: 2023-06-01; ID correnti claude-opus-5-5, claude-sonnet-5-5, claude-haiku-5-5, claude-fable-5-1.
A2. OpenAI: quali modelli della famiglia "Codex" sono disponibili via OpenAI API con chiave (Responses API)? È valido l'ID "gpt-6.1-sol"? Codex supporta ancora Chat Completions?
A3. Google: Gemini API (AI Studio) con GEMINI_API_KEY; endpoint OpenAI-compatible https://generativelanguage.googleapis.com/v1beta/openai/; ID Pro corrente "gemini-3.1-pro-preview"; esiste un Pro stabile?
A4. OpenRouter: base URL https://openrouter.ai/api/v1; è disponibile l'ID "openai/gpt-oss-120b"? Header consigliati (HTTP-Referer, X-Title)?
A5. Hugging Face: router https://router.huggingface.co/v1, token fine-grained "Make calls to Inference Providers", suffissi :fastest :cheapest :preferred :<provider>; "openai/gpt-oss-120b:groq" è servito?
A6. LiteLLM: prefissi anthropic/, openai/, gemini/ (AI Studio; senza prefisso = Vertex AI), openrouter/, huggingface/<provider>/<org>/<model>.
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-06 — Comandi dei package manager

```text
Verifica i comandi di installazione (novembre 2026).
A1. Windows: `winget install --id Microsoft.VisualStudioCode -e` installa la User setup; esiste un'opzione per la System setup via winget (--scope machine)?
A2. Windows: `winget install --id Docker.DockerDesktop -e`; `winget install --id=astral-sh.uv -e`.
A3. macOS: `brew install --cask visual-studio-code`; `brew install --cask docker-desktop`; `brew install uv`.
A4. Debian/Ubuntu: repository VS Code con file deb822 /etc/apt/sources.list.d/vscode.sources e chiave /usr/share/keyrings/microsoft.gpg; Docker Engine con /etc/apt/sources.list.d/docker.sources e /etc/apt/keyrings/docker.asc; differenze per Debian.
A5. openSUSE: file /etc/zypp/repos.d/vscode.repo (testo esatto); `zypper install docker docker-compose docker-compose-switch` (solo Tumbleweed?); equivalente per Leap 16.
A6. uv: esistono pacchetti ufficiali apt o zypper? Altrimenti l'installer https://astral.sh/uv/install.sh è il metodo consigliato.
A7. YaST: è ancora lo strumento predefinito di openSUSE Leap 16 / Tumbleweed o è sostituito (es. Cockpit, Myrlyn)?
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-07 — GitHub Spec Kit con Copilot

```text
Verifica GitHub Spec Kit (novembre 2026).
A1. Installazione: `uv tool install specify-cli` (PyPI) e `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@vX.Y.Z`. Qual è l'ultima release?
A2. Init: `specify init <nome> --integration copilot`; opzioni --script sh|ps|py, --here, --force, --non-interactive, --ignore-agent-tools. L'opzione --ai è stata rimossa?
A3. Comandi in chat: /speckit-constitution, /speckit-specify, /speckit-clarify, /speckit-plan, /speckit-tasks, /speckit-analyze, /speckit-implement, /speckit-checklist, /speckit-converge. Sono skill o prompt file in Copilot? In quale cartella li genera `specify init` (.github/skills, .github/prompts, .github/agents)?
A4. Comandi di verifica: `specify version`, `specify self check`. Esiste ancora `specify check`?
A5. Estensioni: `specify extension add bug`, `specify extension add assess`.
Fonti di partenza: https://github.com/github/spec-kit ; https://github.github.io/spec-kit/installation.html
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

## P-08 — Contraddittorio: nativo vs gateway

```text
Agisci da revisore critico. Tesi del talk: "Per un team, LiteLLM come gateway locale è preferibile al BYOK nativo di VS Code verso 5 provider (Anthropic, OpenAI, Gemini, OpenRouter, Hugging Face)".
A1. Elenca gli argomenti più forti CONTRO la tesi (sicurezza, latenza, compatibilità tool calling/streaming/thinking, manutenzione, punto singolo di guasto).
A2. LiteLLM traduce correttamente tool calling, streaming e reasoning/thinking tra formati OpenAI, Responses e Anthropic Messages? Problemi noti (issue GitHub) nel 2026?
A3. OpenRouter è già un gateway: che senso ha LiteLLM davanti a OpenRouter?
A4. Rischi di esporre il proxy sulla rete locale; buone pratiche (bind 127.0.0.1, virtual keys, TLS).
A5. Alternative a LiteLLM come gateway per Copilot BYOK (es. Portkey, Azure AI Foundry, Cloudflare AI Gateway): confronto sintetico.
[INCOLLA QUI LE ISTRUZIONI COMUNI]
```

---

## Registro degli esiti

Risposte ricevute il 2026-11-07. L'assistente ha riletto direttamente le fonti primarie dei punti critici (colonna **Verifica diretta**).

| Prompt | Esito sintetico | Verifica diretta | Azioni sui documenti | Decisioni |
|--------|-----------------|------------------|----------------------|-----------|
| P-01 | 8 confermate, 2 parziali (A2 provider built-in, A5 percorso file) | Header `x-api-key`/`api-key`/Bearer e `${apiKey}`: confermato ([S-071](Sources.md#s-071)). Percorso file e formato `vendor/id`: non nella doc ufficiale | OpenRouter built-in; percorsi `chatLanguageModels.json` con ⚠️; formato utility model; NES esclusa | [D-019](Decisions.md#d-019) |
| P-02 | 2 confermate, 3 parziali | Policy "enabled by default": confermato ([S-018](Sources.md#s-018)); FAQ VS Code dice "must enable" ([S-071](Sources.md#s-071)) → incoerenza segnalata | §2.5 riscritta: default, percorsi enterprise/org, AI Credits, piani Max/Student | [D-013](Decisions.md#d-013) |
| P-03 | 2 confermate, 4 parziali | Harness e Cloud come execution target: confermato ([S-068](Sources.md#s-068)); instructions per harness: confermato ([S-069](Sources.md#s-069)) | Tabella harness in §1; tabella filesystem per harness in §2.3; `.mcp.json`; `errorOccurred` | — |
| P-04 | 6 confermate, 1 parziale (tag), 1 non verificabile (servizio) | Incidente 1.107.0, tag mobili, nuova chiave cosign: confermato ([S-104](Sources.md#s-104)) | Pin `1.108.2`; §5.0 supply chain; `--host 127.0.0.1`; health senza/con chiave | [D-018](Decisions.md#d-018) |
| P-05 | 2 confermate, 4 parziali | `anthropic-version: 2026-10-21`: confermato ([S-116](Sources.md#s-116)); `gemini-4-argon` stabile: confermato ([S-103](Sources.md#s-103)) | Codex → `gpt-6.1-sol` via `openai/responses/`; Gemini doppio alias; header OpenRouter | [D-015](Decisions.md#d-015), [D-016](Decisions.md#d-016), [D-021](Decisions.md#d-021) |
| P-06 | 4 confermate, 2 parziali, 1 confutata (YaST Leap 16) | Non riletta (fonti P-06 in [Sources.md](Sources.md)) | `--scope machine`; Docker Desktop solo machine; Debian; Leap 16 vs Tumbleweed; nota YaST | [D-014](Decisions.md#d-014) |
| P-07 | 3 confermate, 1 parziale, 1 confutata (`specify check` esiste) | Layout skills di default e `--commands`: confermato ([S-083](Sources.md#s-083)) | Release `v1.3.2`; tabella layout; `--ai` rimossa; `specify check` | — |
| P-08 | Tesi PARZIALE | Perdita `thinking_blocks` con Chat Completions: confermato ([S-110](Sources.md#s-110)) | §4.1 riscritta (criteri, rischi, hardening); §4.6 alternative | [D-017](Decisions.md#d-017), [D-019](Decisions.md#d-019), [D-020](Decisions.md#d-020) |

**Punti ancora aperti (⚠️), da provare prima del talk**

- [ ] Percorso di `chatLanguageModels.json` su macOS e Linux.
- [ ] Formato `vendor/id` di `chat.utilitySmallModel` con un modello Custom Endpoint.
- [ ] `requestHeaders` con `Authorization: Bearer ${apiKey}` verso LiteLLM `/v1/messages`.
- [ ] Pacchetti Docker su openSUSE Leap 16.
- [ ] LTS e digest correnti di LiteLLM.
- [ ] Accesso a `gemini-4-argon` con la chiave Gemini del demo.
