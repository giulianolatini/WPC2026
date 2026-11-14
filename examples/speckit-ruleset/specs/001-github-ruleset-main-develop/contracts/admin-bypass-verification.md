# Contract: verifica di `gh pr merge --admin` con `contoso-copilot-agent`

**Feature**: [spec.md](../spec.md) · **Plan**: [plan.md](../plan.md)

## Input del workflow `verify-ruleset-admin.yml`

| Input | Tipo | Esempio | Note |
|---|---|---|---|
| `repository` | string | `contoso/sample-app` | Oppure `contoso/sample-app-ruleset-lab` |
| `pr_main` | number | `101` | PR → `main`, check verdi, senza approvazione |
| `pr_develop_red` | number | `102` | PR → `develop`, `test-dotnet` fallito |
| `pr_develop_green` | number | `103` | PR → `develop`, check verdi |
| `ruleset_id` | number | `4242` | ID del ruleset `main-release-approval` (l'unico con `bypass_actors`) |

## Segreti e variabili

| Nome | Tipo | Contenuto |
|---|---|---|
| `vars.COPILOT_AGENT_CLIENT_ID` | variabile | Client ID di `contoso-copilot-agent` |
| `secrets.COPILOT_AGENT_PRIVATE_KEY` | secret | Chiave privata dell'app |

## Permessi del token

`permission-contents: write`, `permission-pull-requests: write`. Nessun altro permesso esplicito, in particolare nessun `permission-administration`.

## Variabili d'ambiente passate a Pester

`GH_TOKEN`, `RULESET_REPO`, `PR_MAIN`, `PR_DEVELOP_RED`, `PR_DEVELOP_GREEN`, `RULESET_ID`.

## Output

| Artefatto | Formato | Contenuto |
|---|---|---|
| `ruleset-admin-results.xml` | NUnitXml | Esito di V1–V5 |
| `ruleset-admin-evidence.json` | JSON | Per ogni caso: comando, exit code, output, stato della PR |

## Classificazione degli esiti

| Esito del comando | Messaggio | Classificazione |
|---|---|---|
| exit ≠ 0 | regola del ruleset o requisiti di merge | **PASS** (rifiuto corretto) |
| exit ≠ 0 | `401`, `Bad credentials`, `Resource not accessible by integration` | **INVALID** (problema di token/permessi) |
| exit = 0 | — | **FAIL** (bypass riuscito: attivare il Rollback del piano) |

V6 (push diretto) si esegue a parte con `git push` autenticato dal token, perché richiede un clone. È tracciato nell'issue di verifica.
