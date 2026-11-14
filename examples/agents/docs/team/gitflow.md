# GitFlow del progetto

Questo file descrive i rami e le regole di merge che tutte le figure del team rispettano.

## Rami

| Ramo | Nasce da | Si chiude in | Chi esegue il merge | Condizioni |
|---|---|---|---|---|
| `main` | — | — | — | Fonte di verità del progetto. Cambia solo con una PR. |
| `develop` | `main` | — | — | Ramo di integrazione. Cambia solo con una PR. |
| `feature/<epic>-<feature>-<nome>` | `develop` | `develop` | Organizzatore | Tutti i task della Feature `done`; test verdi; i due Reviewer approvano. |
| `release/<versione>` | `develop` | `main`, poi `develop` | PO | Test d'integrazione del Tester verdi; i due Reviewer approvano; approvazione esplicita del PO. |
| `hotfix/<versione>-<nome>` | `main` | `main`, poi `develop` | PO | Test che riproduce il difetto; i due Reviewer approvano; approvazione esplicita del PO. |

## Regole

1. Nessun commit diretto su `main` e `develop`.
2. Un ramo `feature/*` contiene una sola Feature del backlog.
3. Su un ramo `release/*` entrano solo correzioni e test d'integrazione, non funzioni nuove.
4. Dopo il merge di una Release o di un hotfix in `main`, l'Organizzatore apre la PR di riallineamento verso `develop` (*back-merge*).
5. Ogni versione in `main` ha un tag `v<versione>`.
6. Regola di qualità di `main`: gli artefatti prodotti da `main` non contengono eccezioni non gestite e non si fermano per un'anomalia prevedibile. Il Reviewer antagonista e i test d'integrazione controllano questa regola prima del merge.

## Protezione dei rami su GitHub

Proteggi `main` e `develop` con un ruleset: PR obbligatoria, nessun push diretto, nessun force-push, controlli di stato richiesti (build e test).
Per `main` richiedi l'approvazione del PO.

## Messaggi di commit

`<tipo>(<ambito>): <descrizione>` con l'ID del task nel corpo, per esempio `feat(orders): add order validation` e `Task: E01-F02-T03`.
