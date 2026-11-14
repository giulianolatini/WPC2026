# Team di agenti per lo sviluppo spec-driven

Questa cartella è un **template**: copia il suo contenuto nella radice del repository del progetto software.
Il documento [docs/05-Team-Agenti.md](../../docs/05-Team-Agenti.md) descrive il team, i modelli e la procedura.

## Contenuto

| Percorso | Contenuto |
|---|---|
| `.github/agents/*.agent.md` | Le 9 figure del team come *custom agents* di VS Code |
| `docs/team/workflow.md` | Figure, modelli, flusso di lavoro, ciclo TDD |
| `docs/team/gitflow.md` | Rami GitFlow e regole di merge |
| `docs/team/backlog.md` | Formato di Epic, Feature e Task |
| `docs/team/writing-rules.md` | Regole di scrittura e dizionario per lo Scrittore |
| `.gitignore` | Esclude la cartella di lavoro `.team/` |

## Uso rapido

- [ ] Copia i file nel repository del progetto (ramo `develop`).
- [ ] Configura in VS Code i modelli BYOK di Anthropic, OpenAI e OpenRouter ([02 §3](../../docs/02-Configurazione-Copilot.md#3-configurazione-nativa-verso-i-provider)).
- [ ] Controlla il campo `model` di ogni file `.agent.md`: usa l'ID che il completamento di VS Code propone.
- [ ] Apri la chat con l'agente **Pianificatore** per il brainstorming, poi con l'agente **Organizzatore** per lo sviluppo.
