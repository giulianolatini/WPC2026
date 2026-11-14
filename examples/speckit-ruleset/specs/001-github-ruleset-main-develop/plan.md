# Implementation Plan: Ruleset GitHub per i rami main e develop

**Branch**: `feature/001-github-ruleset-main-develop` | **Date**: 2026-11-14 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-github-ruleset-main-develop/spec.md`

## Summary

La protezione di `main` e `develop` usa **due ruleset** di repository su `contoso/sample-app`, versionati in `.github/rulesets/`:

- **`main-develop`** (su `main` e `develop`): PR obbligatoria, i tre status check `build`, `test-dotnet` e `test-powershell` vincolati a GitHub Actions, ramo aggiornato (strict), blocco di force-push ed eliminazione. **Nessun attore di bypass.**
- **`main-release-approval`** (solo su `main`): 1 approvazione con code owner obbligatorio (`@release-approver`, unico in `CODEOWNERS`) e approvazioni invalidate dai nuovi commit. Unico bypass: team `release-emergency`, in modalità `pull_request`.

I due ruleset vanno separati perché i requisiti di approvazione sono diversi sui due rami (0 su `develop`, code owner su `main`) e un ruleset applica le stesse regole a tutti i rami bersaglio. GitHub li somma e applica la versione più restrittiva ([About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)). Tenere il bypass solo sul secondo ruleset fa sì che il merge di emergenza salti soltanto l'approvazione: PR e check restano obbligatori anche per `@release-approver-backup`.

La CI `ci.yml` produce i tre check. Lo script `scripts/Set-Rulesets.ps1` applica i ruleset dai file (FR-013). La verifica `--admin` con `contoso-copilot-agent` conferma che l'agente non aggira le regole.

## Technical Context

**Language/Version**: PowerShell 7.4+ (script e test); .NET SDK 10.0 (applicazione, job `build` e `test-dotnet`)

**Primary Dependencies**:
- GitHub CLI `gh` (autenticazione tramite `GH_TOKEN`, [gh environment](https://cli.github.com/manual/gh_help_environment)).
- GitHub REST API `2026-03-10`, endpoint dei ruleset di repository ([REST rules](https://docs.github.com/en/rest/repos/rules)).
- GitHub Actions: `actions/checkout@v7`, `actions/setup-dotnet@v6`, `actions/upload-artifact@v7`, `actions/create-github-app-token@v3` (versioni maggiori più recenti, controllate sui tag dei repository il 2026-11-14).

**Storage**: file nel repository (`.github/rulesets/*.json`, `.github/CODEOWNERS`).

**Testing**: NUnit 5 con `dotnet test`; Pester 6.2.0 con `Invoke-Pester`. I test con tag `Live` sono esclusi dalla CI.

**Target Platform**: GitHub.com, organizzazione `contoso` su piano GitHub Team; runner `ubuntu-latest`.

**Project Type**: configurazione del repository, CI e suite di verifica.

**Performance Goals**: CI completa in meno di 10 minuti per PR; ruleset riapplicati da zero in meno di 10 minuti (SC-005).

**Constraints**:
- Ogni check obbligatorio deve aver completato almeno un'esecuzione riuscita nel repository negli ultimi 7 giorni ([Troubleshooting required status checks](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks)): si applicano i ruleset **dopo** il primo giro verde di `ci.yml`.
- Un workflow saltato da filtri di path o branch lascia i check in "Pending" e blocca il merge (stessa fonte). Un job saltato invece "will report its status as 'Success'" anche se è un check obbligatorio ([Control jobs with conditions](https://docs.github.com/en/actions/how-tos/write-workflows/choose-when-workflows-run/control-jobs-with-conditions)). Per questo `ci.yml` non ha `paths`, `if` o `needs` sui job.
- L'app `contoso-copilot-agent` ha solo Contents write e Pull requests write. Niente Administration (FR-017), niente Commit statuses o Checks. In più i check sono vincolati all'app GitHub Actions (`integration_id` 15368), quindi l'agente non può pubblicare un check `build` falso.

**Scale/Scope**: 1 repository, 2 rami protetti, 2 ruleset, 3 check, 1 identità agente.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Nessun `.specify/memory/constitution.md` personalizzato nel pacchetto: gate non applicabile. Se il repository ha una constitution, ricontrollare in particolare i principi su test e sicurezza.

## Project Structure

### Documentation (this feature)

```text
specs/001-github-ruleset-main-develop/
├── spec.md
├── plan.md                                  # questo file
├── research.md                              # da generare (decisioni R1–R8 sotto)
├── quickstart.md                            # da generare
├── contracts/
│   └── admin-bypass-verification.md         # contratto della verifica --admin
├── checklists/requirements.md
└── tasks.md                                 # /speckit-tasks
```

### Source Code (repository root)

```text
.github/
├── CODEOWNERS                               # `* @release-approver` (FR-007)
├── rulesets/
│   ├── main-develop.json                    # main + develop, nessun bypass
│   └── main-release-approval.json           # solo main, code owner, bypass release-emergency
└── workflows/
    ├── ci.yml                               # job: build, test-dotnet, test-powershell (FR-005)
    └── verify-ruleset-admin.yml             # workflow_dispatch per la verifica --admin
scripts/
└── Set-Rulesets.ps1                         # crea/aggiorna i ruleset dai file (FR-013)
tests/
└── ruleset/
    └── AdminBypass.Tests.ps1                # suite Pester 6 (tag Live, AdminBypass)
```

**Structure Decision**: la configurazione GitHub sta in `.github/` (`CODEOWNERS` deve stare in `.github/`, nella root o in `docs/`; i JSON sono una convenzione di questo repository). Lo script di applicazione sta in `scripts/`, la verifica live in `tests/ruleset/`.

## Phase 0 – Decisioni di ricerca

| ID | Decisione | Motivo | Fonte |
|---|---|---|---|
| R1 | Approvazione di `@release-approver` tramite `CODEOWNERS` più `require_code_owner_review` | Il ruleset non ha un'opzione per un singolo utente; basta l'approvazione di un qualsiasi code owner, quindi il file ne elenca uno solo | [Available rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets), [About code owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) |
| R2 | Bypass solo per il team `release-emergency` con `bypass_mode: pull_request`, e solo su `main-release-approval` | `pull_request` consente il bypass "only ... on pull requests"; tenerlo fuori da `main-develop` lascia PR e check obbligatori anche in emergenza | [REST rules](https://docs.github.com/en/rest/repos/rules), [Creating rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository) |
| R3 | `--admin` va trattato come un tentativo di bypass, da far fallire lato server | `gh pr merge --admin` "uses administrator privileges to merge a pull request that does not meet requirements" | [gh pr merge](https://cli.github.com/manual/gh_pr_merge) |
| R4 | Token di installazione con permessi espliciti e ristretti al solo repository | Senza `permissions` il token eredita tutti i permessi dell'app | [Installation access token](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-an-installation-access-token-for-a-github-app) |
| R5 | Prove del rifiuto: output di `gh`, stato della PR e rule suites | `GET /repos/{owner}/{repo}/rulesets/rule-suites` filtra per `ref`, `actor_name` e `rule_suite_result`; serve Administration read | [Rule suites](https://docs.github.com/en/rest/repos/rule-suites) |
| R6 | Due ruleset invece di uno | Requisiti di approvazione diversi per ramo; i ruleset si sommano con la regola più restrittiva | [About rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) |
| R7 | Check vincolati a `integration_id` 15368 (app GitHub Actions) | `integration_id` è "the optional integration ID that this status check must originate from"; 15368 è l'ID dell'app `github-actions`, usato così in ruleset pubblici (da riconfermare con `GET /apps/github-actions`) | [REST rules](https://docs.github.com/en/rest/repos/rules), [esempio di terze parti](https://github.com/modelcontextprotocol/inspector/issues/2621) |
| R8 | `allowed_merge_methods: ["merge"]` su entrambi i ruleset | GitFlow integra con merge commit (`--no-ff`), che conserva la storia di release e hotfix; un solo metodo evita dubbi su come si combinano metodi diversi tra ruleset | [nvie.com](https://nvie.com/posts/a-successful-git-branching-model/), [REST rules](https://docs.github.com/en/rest/repos/rules) |

## Phase 1 – Design

### 1.1 Ruleset `main-develop` (`.github/rulesets/main-develop.json`)

| Regola | Parametri | Requisiti |
|---|---|---|
| `deletion` | — | FR-004 |
| `non_fast_forward` | — | FR-003 |
| `pull_request` | 0 approvazioni, solo `merge` | FR-002, FR-009 |
| `required_status_checks` | `build`, `test-dotnet`, `test-powershell` su 15368; `strict_required_status_checks_policy: true` | FR-005, FR-006 |
| `bypass_actors` | vuoto | FR-010, FR-011 |

```json
{
  "name": "main-develop",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [],
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main", "refs/heads/develop"],
      "exclude": []
    }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false,
        "allowed_merge_methods": ["merge"]
      }
    },
    {
      "type": "required_status_checks",
      "parameters": {
        "strict_required_status_checks_policy": true,
        "do_not_enforce_on_create": false,
        "required_status_checks": [
          { "context": "build", "integration_id": 15368 },
          { "context": "test-dotnet", "integration_id": 15368 },
          { "context": "test-powershell", "integration_id": 15368 }
        ]
      }
    }
  ]
}
```

### 1.2 Ruleset `main-release-approval` (`.github/rulesets/main-release-approval.json`)

| Regola | Parametri | Requisiti |
|---|---|---|
| `pull_request` | 1 approvazione, `require_code_owner_review: true`, `dismiss_stale_reviews_on_push: true` | FR-007, FR-008 |
| `bypass_actors` | team `release-emergency`, `bypass_mode: pull_request` | FR-010, US5 |

`actor_id: 0` è un segnaposto: `Set-Rulesets.ps1` lo sostituisce con l'ID reale del team (`gh api orgs/contoso/teams/release-emergency --jq .id`). Un import manuale con 0 fallisce, e non lascia un bypass sbagliato.

`require_last_push_approval` resta `false`. Con un solo code owner, se `@release-approver` facesse l'ultimo push su un ramo di release nessun altro potrebbe approvarlo e la PR resterebbe bloccata. FR-008 è già coperto da `dismiss_stale_reviews_on_push`.

```json
{
  "name": "main-release-approval",
  "target": "branch",
  "enforcement": "active",
  "bypass_actors": [
    {
      "actor_id": 0,
      "actor_type": "Team",
      "bypass_mode": "pull_request"
    }
  ],
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main"],
      "exclude": []
    }
  },
  "rules": [
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 1,
        "dismiss_stale_reviews_on_push": true,
        "require_code_owner_review": true,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false,
        "allowed_merge_methods": ["merge"]
      }
    }
  ]
}
```

### 1.3 `CODEOWNERS` (`.github/CODEOWNERS`)

```text
# Unico code owner: la sua approvazione è richiesta per ogni PR verso main
# (ruleset main-release-approval, require_code_owner_review = true).
# Non aggiungere altri owner: basta l'approvazione di UNO qualsiasi dei code owner.
# Il sostituto @release-approver-backup NON va elencato qui: usa il bypass
# del team release-emergency (spec 001, User Story 5).
* @release-approver
```

Vale il `CODEOWNERS` del ramo base della PR. Il file arriva su `develop` con i back-merge di GitFlow, ma lì è irrilevante perché `main-develop` non richiede code owner. `@release-approver` deve avere accesso in scrittura esplicito al repository.

### 1.4 CI `ci.yml` (`.github/workflows/ci.yml`)

I `name` dei job coincidono con i `context` richiesti. I job sono indipendenti tra loro (niente `needs`), così un errore in `build` non fa saltare `test-dotnet`, che risulterebbe "Success". `test-dotnet` presuppone una sola soluzione nella root e NUnit eseguito con VSTest (`NUnit3TestAdapter`). Se il repository usa Microsoft.Testing.Platform, gli argomenti `--logger` e `--results-directory` vanno adattati.

```yaml
name: CI

# I nomi dei job (build, test-dotnet, test-powershell) sono i "context" richiesti
# dal ruleset main-develop: non rinominarli senza aggiornare
# .github/rulesets/main-develop.json nella stessa PR.
# Niente filtri paths e niente if/needs sui job: un workflow saltato per filtro resta
# "Pending" e blocca il merge; un job saltato risulta "Success" e aggirerebbe il controllo.
on:
  pull_request:
    branches: [main, develop]
  push:
    branches: [main, develop]

permissions:
  contents: read

concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

env:
  DOTNET_NOLOGO: true
  DOTNET_CLI_TELEMETRY_OPTOUT: true

jobs:
  build:
    name: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-dotnet@v6
        with:
          dotnet-version: '10.0.x'
      - name: Restore
        run: dotnet restore
      - name: Build
        run: dotnet build --no-restore --configuration Release

  test-dotnet:
    name: test-dotnet
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - uses: actions/setup-dotnet@v6
        with:
          dotnet-version: '10.0.x'
      - name: Test (NUnit)
        run: >
          dotnet test --configuration Release
          --logger "trx;LogFileName=test-dotnet.trx"
          --results-directory TestResults
      - name: Risultati
        if: always()
        uses: actions/upload-artifact@v7
        with:
          name: test-dotnet-results
          path: TestResults/

  test-powershell:
    name: test-powershell
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v7
      - name: Installa Pester 6.2.0
        shell: pwsh
        run: Install-Module Pester -RequiredVersion 6.2.0 -Force -Scope CurrentUser
      - name: Test (Pester), esclusi i test Live
        shell: pwsh
        run: |
          $config = New-PesterConfiguration
          $config.Run.Path = './tests'
          $config.Run.Exit = $true
          $config.Filter.ExcludeTag = 'Live'
          $config.Output.Verbosity = 'Detailed'
          $config.TestResult.Enabled = $true
          $config.TestResult.OutputPath = 'test-powershell.xml'
          $config.TestResult.OutputFormat = 'NUnitXml'
          Invoke-Pester -Configuration $config
      - name: Risultati
        if: always()
        uses: actions/upload-artifact@v7
        with:
          name: test-powershell-results
          path: test-powershell.xml
```

### 1.5 Applicazione dei ruleset (`scripts/Set-Rulesets.ps1`)

1. Un maintainer con Administration write esegue `./scripts/Set-Rulesets.ps1 -Repository <repo> -WhatIf`, controlla l'anteprima, poi lo lancia senza `-WhatIf`.
2. Lo script crea o aggiorna ogni ruleset per nome (`POST`/`PUT /repos/{owner}/{repo}/rulesets`) e stampa le regole effettive di `main` e `develop`.
3. Ordine di rilascio: (a) merge di `ci.yml` e di `CODEOWNERS` su `develop` e poi su `main`, con un giro di CI verde; (b) applicazione in laboratorio più la verifica `--admin`; (c) applicazione su `contoso/sample-app` più la verifica `--admin`.

### 1.6 Copertura dei requisiti

| Requisito | Dove |
|---|---|
| FR-001 | `conditions.ref_name` dei due ruleset |
| FR-002, FR-009 | `pull_request` in `main-develop` |
| FR-003, FR-004 | `non_fast_forward`, `deletion` |
| FR-005, FR-006 | `required_status_checks` più `ci.yml` |
| FR-007, FR-008 | `main-release-approval` più `CODEOWNERS` |
| FR-010, FR-011, FR-017 | `bypass_actors`, permessi dell'app, verifica V1–V6 |
| FR-012 | `enforcement: active` |
| FR-013 | `.github/rulesets/*.json` più `Set-Rulesets.ps1` |
| FR-014 | `.specify/extensions/git/git-config.yml` (`branch_prefix: "feature"`) |
| FR-015 | messaggi di rifiuto nativi di GitHub, salvati come evidenza della verifica |
| FR-016 | rule suites con `rule_suite_result=bypass` più una issue di documentazione |

## Verifica di `--admin` con la GitHub App `contoso-copilot-agent`

Copre User Story 4 (scenari 1–4), FR-010, FR-011, FR-017 e SC-002. Usa la configurazione delle Fasi 1.1–1.3. Il contratto completo è in [contracts/admin-bypass-verification.md](./contracts/admin-bypass-verification.md).

### Precondizioni

1. I ruleset `main-develop` e `main-release-approval` sono `active`. `GET /repos/contoso/sample-app/rules/branches/main` e `.../develop` restituiscono le regole `pull_request`, `required_status_checks`, `non_fast_forward` e `deletion`. Questo endpoint esclude i ruleset in `evaluate` o `disabled` ([REST rules](https://docs.github.com/en/rest/repos/rules)).
2. `contoso-copilot-agent` è installata su `contoso/sample-app` con Contents write e Pull requests write, senza Administration.
3. `contoso-copilot-agent` non compare tra i `bypass_actors` di nessuno dei due ruleset. Lo verifica un maintainer, perché il campo viene restituito solo a chi ha accesso in scrittura al ruleset.
4. Esistono tre PR di test aperte, ciascuna con una modifica innocua (un file sotto `docs/ruleset-tests/`):
   - `PR_MAIN`: `release/0.0.0-ruleset-test` → `main`, check verdi, **senza** approvazione di `@release-approver`.
   - `PR_DEVELOP_RED`: `feature/900-ruleset-test-red` → `develop`, con `test-dotnet` fallito di proposito.
   - `PR_DEVELOP_GREEN`: `feature/901-ruleset-test-green` → `develop`, check verdi (controllo positivo).

### Matrice dei test

| ID | Azione dell'app (`GH_TOKEN` = token di `contoso-copilot-agent`) | Esito atteso | Requisito |
|---|---|---|---|
| V1 | `gh pr merge $PR_MAIN --merge` | Rifiutato; PR resta `OPEN` | US4-1, FR-007 |
| V2 | `gh pr merge $PR_MAIN --merge --admin` | Rifiutato; PR resta `OPEN` | US4-2, FR-011 |
| V3 | `gh pr merge $PR_DEVELOP_RED --merge --admin` | Rifiutato; PR resta `OPEN` | FR-005, FR-011 |
| V4 | `gh pr merge $PR_DEVELOP_GREEN --merge` | **Riuscito** (prova che il token ha i permessi giusti, quindi i rifiuti di V1–V3 vengono dal ruleset) | US2-2 |
| V5 | `gh api repos/contoso/sample-app/rulesets/$RULESET_ID` (ID di `main-release-approval`, l'unico con bypass) | Risposta senza `bypass_actors` (l'app non ha scrittura sul ruleset) | FR-017 |
| V6 | Push diretto su `develop` con il token dell'app | Rifiutato | US4-3, FR-002 |

### Criteri di superamento

- V1, V2, V3 e V6 terminano con exit code diverso da 0. Il messaggio **non** è un errore di autenticazione o di permessi (`HTTP 401`, `Resource not accessible by integration`), altrimenti il test è **non valido**, non superato.
- Dopo V1–V3 lo stato della PR (`gh pr view <n> --json state`) è ancora `OPEN`.
- V4 riesce. Se V4 fallisce, l'intera esecuzione è non valida, perché il token potrebbe essere sbagliato.
- V5 non restituisce `bypass_actors`.
- Il testo esatto dei messaggi di rifiuto viene salvato come evidenza: non è stabilito a priori e serve come baseline per le esecuzioni successive.

### Procedura

1. **Laboratorio**: crea `contoso/sample-app-ruleset-lab`, applica i due ruleset con `./scripts/Set-Rulesets.ps1 -Repository contoso/sample-app-ruleset-lab` e lancia `verify-ruleset-admin.yml`. Se V2 riesce in laboratorio, fermati e correggi la bypass list prima di toccare la produzione.
2. **Produzione**: lancia lo stesso workflow su `contoso/sample-app` con le tre PR di test.
3. **Evidenze**: allega l'output di Pester (`NUnitXml`) e l'esportazione delle rule suites filtrate su `actor_name=contoso-copilot-agent[bot]` all'issue di verifica. Il nome esatto dell'attore va confermato nella prima esecuzione.
4. **Pulizia**: chiudi `PR_MAIN` e `PR_DEVELOP_RED` senza merge e cancella i rami di test. Per `PR_DEVELOP_GREEN` apri una PR di revert verso `develop`.

### Rollback

Se V1, V2, V3 o V6 riescono per errore:
1. revert immediato del merge con una PR (la procedura di emergenza della User Story 5 vale anche per `main`);
2. rimozione di `contoso-copilot-agent` dalla bypass list o riduzione dei suoi permessi;
3. rotazione della chiave privata dell'app;
4. ripetizione della verifica in laboratorio.

### Frequenza

- A ogni modifica di `.github/rulesets/*.json`, di `CODEOWNERS` o dei permessi dell'app.
- Almeno una volta al mese (SC-002), con schedulazione manuale.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Due ruleset invece di uno | Requisiti di approvazione diversi su `main` e `develop` | Un ruleset unico applicherebbe il code owner anche a `develop` o lo toglierebbe a `main` |
