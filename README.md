# WPC2026 — GitHub Copilot in VS Code con LLM via API: nativo o LiteLLM?

Materiali del talk presentato a **WPC 2026** (30 minuti + 5 minuti di domande).

## Argomento

Il talk mostra come configurare **GitHub Copilot in Visual Studio Code** per usare modelli di provider diversi via API (*Bring Your Own Key*, BYOK):

- **Claude.AI** — Anthropic API
- **Codex** — OpenAI API
- **Gemini Pro** — Gemini API di Google AI Studio
- **OpenRouter**
- **Hugging Face** — Inference Providers

Il talk confronta due percorsi:

| | Configurazione nativa | Gateway LiteLLM |
|---|---|---|
| Come | VS Code chiama ogni provider con la sua chiave | VS Code chiama un proxy locale; il proxy chiama i provider |
| Esecuzione | — | Docker oppure servizio locale con `uv` |
| Punto di forza | Nessun componente in più, nessun punto singolo di guasto | Una chiave sul client, alias stabili, budget e chiavi per utente |
| Punto debole | Chiavi su ogni client, nessuna governance centrale | Concentrazione delle credenziali, rischio supply chain, traduzione dei formati |
| Quando | Singolo sviluppatore | Team che richiede governance, con hardening |

Il talk non dichiara un vincitore: presenta i **criteri di scelta** ([docs/Decisions.md#d-017](docs/Decisions.md#d-017)).

## Organizzazione del repository

```text
.
├── README.md                     # questo file
├── LICENSE                       # GPL-3.0
├── docs/                         # documentazione Markdown
│   ├── 01-Installazione.md       # VS Code, Docker, uv, LiteLLM su Windows/macOS/Linux
│   ├── 02-Configurazione-Copilot.md  # Copilot: uso, architettura, BYOK nativo, LiteLLM, Spec Kit
│   ├── 03-Security-Best-Practices.md # best practice Microsoft e LiteLLM, baseline sicura
│   ├── 04-Security-Review-OWASP-ISO27001.md # review degli esempi: OWASP LLM/Agentic, ISO 27001
│   ├── Decisions.md              # registro cronologico delle decisioni (ADR con razionale)
│   ├── Sources.md                # fonti documentali (titolo + URL, ancore S-NNN)
│   └── Review-Perplexity.md      # prompt di verifica con un secondo LLM
└── examples/
    ├── litellm/                  # config.yaml, Compose minimo/esteso, .env.example, unit di servizio
    └── vscode/                   # chatLanguageModels.json (nativo, LiteLLM), settings.secure.jsonc
```

## Da dove iniziare

1. Leggi [docs/01-Installazione.md](docs/01-Installazione.md) e installa gli strumenti.
2. Segui [docs/02-Configurazione-Copilot.md](docs/02-Configurazione-Copilot.md): prima il percorso nativo (§3), poi LiteLLM (§4).
3. Usa i file in [examples/](examples/) come base.
4. Prima di usarli in un team, leggi [docs/03-Security-Best-Practices.md](docs/03-Security-Best-Practices.md) e i rischi in [docs/04-Security-Review-OWASP-ISO27001.md](docs/04-Security-Review-OWASP-ISO27001.md).

Ogni scelta è documentata in [docs/Decisions.md](docs/Decisions.md). Ogni affermazione punta a una fonte in [docs/Sources.md](docs/Sources.md).

## Avvertenze

- **Non fare commit delle chiavi API.** Usa `.env` (escluso da `.gitignore`) e `.env.example`.
- Gli ID dei modelli e alcune impostazioni di VS Code cambiano spesso. Il simbolo ⚠️ nei documenti indica un punto da verificare.
- I costi delle chiamate API sono a carico del titolare della chiave.

## Licenza

[GPL-3.0](LICENSE).
