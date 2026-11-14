# GitFlow del progetto

Questo file descrive i rami e le regole di merge che tutte le figure del team rispettano.

## Rami

| Ramo | Nasce da | Si chiude in | Chi esegue il merge | Condizioni |
|---|---|---|---|---|
| `main` | — | — | — | Fonte di verità del progetto. Cambia solo con una PR. |
| `develop` | `main` | — | — | Ramo di integrazione. Cambia solo con una PR. |
| `feature/<NNN>-<slug>` | `develop` | `develop` | Organizzatore | Definition of Done della Feature completa fino a DoD-F7 ([backlog.md](backlog.md#definition-of-done-di-una-feature)). |
| `release/<versione>` | `develop` | `main`, poi `develop` | PO | Definition of Done dell'Epic completa fino a DoD-E6, con l'approvazione esplicita del PO ([backlog.md](backlog.md#definition-of-done-di-unepic)). |
| `hotfix/<versione>-<nome>` | `main` | `main`, poi `develop` | PO | Test che riproduce il difetto; i due Reviewer approvano; approvazione esplicita del PO. |

Il ramo `feature/<NNN>-<slug>` è il ramo che l'estensione `git` di Spec Kit crea con `branch_prefix: "feature"` ([git-config.yml](../../.specify/extensions/git/git-config.yml)).

## Regole

1. Nessun commit diretto su `main` e `develop`.
2. Un ramo `feature/*` contiene una sola Feature del backlog.
3. Su un ramo `release/*` entrano solo correzioni e test d'integrazione, non funzioni nuove.
4. Dopo il merge di una Release o di un hotfix in `main`, l'Organizzatore apre la PR di riallineamento verso `develop` (*back-merge*).
5. Ogni versione in `main` ha un tag `v<versione>`. Se esiste un ramo `release/*` aperto, un hotfix si riallinea in quel ramo e non in `develop`.
6. Il merge usa sempre un merge commit (`gh pr merge --merge`). Nessuna figura usa `gh pr merge --admin`.
7. **Nessun merge senza Definition of Done.** Una PR non si unisce se una voce richiesta per quel merge non è soddisfatta o non ha un'evidenza: da DoD-F1 a DoD-F7 per `develop`, da DoD-E1 a DoD-E6 per `main`. Le voci restanti si chiudono dopo il merge e servono per lo stato `done`.

## Regola di qualità di `main`

Obiettivo: gli artefatti prodotti da `main` non contengono eccezioni non gestite e non si fermano per un'anomalia prevedibile.

Nessuna pratica garantisce che un processo non termini mai. Il team applica questi controlli:

- il Pianificatore scrive un criterio di accettazione per ogni input non valido e per ogni errore previsto;
- il Tester scrive un test per ognuno di questi criteri;
- chi implementa valida gli input, cattura le eccezioni previste nel punto in cui le può gestire e registra un gestore globale che scrive l'errore nel log e termina con un codice di uscita diverso da zero;
- il Reviewer antagonista controlla le evidenze della voce DoD-E4 e assegna severità `alta` a ogni eccezione non gestita in una PR verso `main`; il suo esito entra nella voce DoD-E6.

## Protezione dei rami su GitHub

Le istruzioni di un agente non sono un controllo di sicurezza: GitHub deve rifiutare le operazioni non permesse. Il template contiene due ruleset in [`.github/rulesets/`](../../.github/rulesets/):

| Ruleset | Rami | Regole | Chi può aggirarlo |
|---|---|---|---|
| `main-develop` | `main`, `develop` | PR obbligatoria; nessun force-push; nessuna eliminazione; controlli di stato `build`, `test-dotnet`, `test-powershell` di [ci.yml](../../.github/workflows/ci.yml); ramo aggiornato; solo merge commit | Nessuno |
| `main-release-approval` | `main` | 1 approvazione di un *code owner*; un nuovo commit annulla le approvazioni | Solo il team di emergenza, e solo con una PR |

- Un ruleset non può nominare un utente: l'approvazione del PO si ottiene con [`.github/CODEOWNERS`](../../.github/CODEOWNERS), che contiene **solo** il PO.
- Applica i ruleset con [`scripts/Set-Rulesets.ps1`](../../scripts/Set-Rulesets.ps1), prima con `-WhatIf`. Applica i ruleset dopo la prima esecuzione verde di `ci.yml` su `main` e `develop`.
- ⚠️ I ruleset e lo script non sono stati provati su GitHub. Provali prima in un repository di laboratorio.
- ⚠️ Lo script richiede un'organizzazione GitHub con un team di emergenza. Con il piano Free i ruleset funzionano solo nei repository pubblici.

## Identità dell'agente

L'Organizzatore esegue `git` e `gh` con un'identità **diversa** da quella del PO:

- una GitHub App o un account di servizio, con i soli permessi *Contents: write* e *Pull requests: write*;
- senza il permesso *Administration*, senza il permesso *Workflows* e fuori dalla lista di bypass dei ruleset;
- il PO resta l'unico *code owner*: approva le PR verso `main` e ne esegue il merge.

Senza il permesso *Workflows* GitHub rifiuta un push dell'agente che modifica un file in `.github/workflows/`: l'agente non può cambiare `ci.yml` per rendere verdi i controlli.

⚠️ Rischio che resta: `develop` non richiede approvazioni, quindi una PR dell'agente può cambiare i test. Il Reviewer antagonista segnala con severità `alta` ogni test cancellato o reso sempre verde e ogni modifica in `.github/`. Per un controllo più forte richiedi l'approvazione del PO anche su `develop` ([D-043](https://github.com/giulianolatini/WPC2026/blob/main/docs/Decisions.md#d-043)).

Con il token del PO l'agente avrebbe i diritti del PO, compreso `gh pr merge --admin`. Con un'identità separata GitHub rifiuta il merge se manca l'approvazione o un controllo di stato.

## Messaggi di commit

`<tipo>(<ambito>): <descrizione>` con l'ID del task nel corpo, per esempio `feat(orders): add order validation` e `Task: E01-F02-T03`.
