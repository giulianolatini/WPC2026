# Team di agenti per lo sviluppo spec-driven

Questa cartella è un **template**: copia il suo contenuto nella radice del repository del progetto software.
Il documento [docs/05-Team-Agenti.md](../../docs/05-Team-Agenti.md) descrive il team, i modelli e la procedura.
I documenti [06](../../docs/06-BYOK-GitHub-Copilot.md) e [07](../../docs/07-LiteLLM-Introduzione.md) spiegano il BYOK di GitHub Copilot e il gateway LiteLLM.

## Contenuto

| Percorso | Contenuto |
|---|---|
| `.github/agents/*.agent.md` | Le 10 figure del team come *custom agents* di VS Code |
| `.vscode/mcp.json` | Server MCP `microsoft-learn` per il Cercatore |
| `docs/team/workflow.md` | Figure, modelli, flusso di lavoro, ciclo TDD |
| `docs/team/backlog.md` | Epic, Feature, Task; **Definition of Done**; criteri di accettazione |
| `docs/team/templates/` | Modelli di `epic.md`, `feature.md`, `task.md`, `decisions.md` (registro ADR) |
| `docs/team/gitflow.md` | Rami GitFlow, regole di merge, protezione dei rami, identità dell'agente |
| `docs/team/writing-rules.md` | Regole di scrittura e dizionario per lo Scrittore |
| `.github/rulesets/*.json` | Tre ruleset per `main` e `develop`: PR e controlli, approvazione su `main`, approvazione su `develop` ⚠️ |
| `.github/CODEOWNERS` | Il PO come unico *code owner* (nome di esempio) ⚠️ |
| `.github/workflows/ci.yml` | CI con i controlli `build`, `test-dotnet`, `test-powershell` ⚠️ |
| `scripts/Set-Rulesets.ps1` | Applica i ruleset dai file JSON ⚠️ |
| `.specify/extensions/git/git-config.yml` | Estensione `git` di Spec Kit con `branch_prefix: "feature"` |
| `.gitignore` | Esclude la cartella di lavoro `.team/` |

⚠️ **Non provato.** Ruleset, `CODEOWNERS`, CI e script vengono da una sessione di Spec Kit ([esempio](../speckit-ruleset/README.md)). I file JSON rispettano lo schema della REST API, ma nessuno li ha applicati a un repository GitHub. Provali prima in un repository di laboratorio.

I nomi `contoso`, `sample-app`, `release-approver`, `release-emergency` e `contoso-copilot-agent` sono esempi: sostituiscili.

## Uso rapido

- [ ] Copia i file nel repository del progetto (ramo `develop`).
- [ ] Configura in VS Code i modelli BYOK di Anthropic, OpenAI e OpenRouter ([02 §3](../../docs/02-Configurazione-Copilot.md#3-configurazione-nativa-verso-i-provider)).
- [ ] Attiva le impostazioni dell'harness Copilot ([05 §5](../../docs/05-Team-Agenti.md#5-vincoli-tecnici-di-vs-code)).
- [ ] Controlla il campo `model` di ogni file `.agent.md`: usa l'ID che il completamento di VS Code propone.
- [ ] Leggi `.vscode/mcp.json` e avvia il server `microsoft-learn`. In Copilot CLI il comando è `/plugin install microsoftdocs/mcp`.
- [ ] Sostituisci i nomi di esempio in `CODEOWNERS` e applica i ruleset ([gitflow.md](docs/team/gitflow.md#protezione-dei-rami-su-github)). Con il piano Free leggi [Piani GitHub](docs/team/gitflow.md#piani-github).
- [ ] Apri la chat con l'agente **Pianificatore** per il brainstorming, poi con l'agente **Organizzatore** per lo sviluppo.

Regola del team: lo sviluppo di una Feature o di un'Epic è concluso solo quando la sua Definition of Done è completa ([backlog.md](docs/team/backlog.md)).
