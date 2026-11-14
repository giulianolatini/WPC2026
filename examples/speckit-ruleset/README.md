# Esempio: una Feature sviluppata con Spec Kit (ruleset di `main` e `develop`)

Questa cartella è un **caso svolto**, non un template. Mostra i documenti che GitHub Spec Kit 1.4.0 produce per una Feature: la protezione dei rami `main` e `develop` di un repository GitFlow.
I file di configurazione che la Feature produce sono nel template [`examples/agents/`](../agents/README.md).

> ⚠️ **Non provato.** Nessun file di questo esempio è stato applicato a un repository GitHub. I nomi `contoso`, `sample-app`, `release-approver`, `release-approver-backup`, `release-emergency` e `contoso-copilot-agent` sono esempi.

## Contenuto

| Percorso | Contenuto | Comando Spec Kit |
|---|---|---|
| `specs/001-github-ruleset-main-develop/spec.md` | Specifica: 6 user story, 17 requisiti, 7 criteri di successo | `/speckit-specify`, `/speckit-clarify` |
| `specs/001-github-ruleset-main-develop/plan.md` | Piano: due ruleset, `CODEOWNERS`, CI, verifica di `--admin` | `/speckit-plan` |
| `specs/001-github-ruleset-main-develop/contracts/admin-bypass-verification.md` | Contratto della verifica | `/speckit-plan` |
| `specs/001-github-ruleset-main-develop/checklists/requirements.md` | Checklist di qualità della specifica | `/speckit-specify` |
| `.specify/feature.json` | Feature attiva | — |
| `tests/ruleset/AdminBypass.Tests.ps1` | Test Pester 6 (tag `Live`): l'identità dell'agente non aggira i ruleset | — |
| `.github/workflows/verify-ruleset-admin.yml` | Workflow manuale che esegue i test con il token della GitHub App | — |

Il passo `/speckit-tasks` non è stato eseguito: `tasks.md` non esiste.

## Cosa mostra l'esempio

1. **Dalla richiesta alla specifica.** La richiesta è una frase. La specifica la trasforma in requisiti che si possono provare (`FR-001`…`FR-017`) e in scenari «Given / When / Then».
2. **I chiarimenti sono decisioni.** La sezione `Clarifications` registra tre domande e le risposte. Nel team di agenti queste risposte sono del PO.
3. **Il piano collega ogni requisito a un file.** La tabella «Copertura dei requisiti» di `plan.md` è il modello per le evidenze della Definition of Done.
4. **Un controllo negativo ha bisogno di un controllo positivo.** Il test V4 prova che il token funziona: senza V4 un rifiuto può essere un errore di autenticazione.
5. **L'agente ha un'identità separata.** La GitHub App non ha il permesso *Administration* e non è nella lista di bypass: `gh pr merge --admin` deve fallire.

## Modifiche dopo la review

La suite `AdminBypass.Tests.ps1` è diversa dal pacchetto originale in tre punti (review R6-codex-04 e R6-codex-05):

- un contesto nuovo controlla lo stato delle tre PR di test prima dei rifiuti: aperta, ramo base, `MERGEABLE`, aggiornata rispetto alla base, check richiesti; un merge parte solo se questo controllo è superato (R7-codex-03, R7-codex-04);
- V4 (controllo positivo) è l'ultimo test di merge, perché fa avanzare `develop`;
- V5 controlla il codice di uscita di `gh api`, l'ID e il nome del ruleset.

Il workflow `verify-ruleset-admin.yml` ha gli input `owner` e `repo` separati (review R6-agy-02): l'azione che crea il token vuole il nome del repository senza il proprietario.

Il piano e il contratto descrivono la matrice V1–V6: l'ordine di esecuzione è quello della suite.

## Attenzione

- I test con il tag `Live` eseguono merge **reali**. Eseguili solo in un repository di laboratorio.
- `integration_id: 15368` (app GitHub Actions) viene da esempi pubblici: controlla il valore con `gh api apps/github-actions --jq .id`.
- Lo script e i ruleset richiedono un'organizzazione GitHub con un team di emergenza.

## Uso con Spec Kit

```bash
specify init --here --force --integration copilot
specify extension add git
# copia .specify/extensions/git/git-config.yml dal template examples/agents/
git switch develop
git switch -c feature/001-github-ruleset-main-develop
```

Poi in Copilot Chat: `/speckit-tasks` e `/speckit-implement`.
