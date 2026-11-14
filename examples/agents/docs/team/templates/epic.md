---
id: E01
titolo: <titolo dell'Epic>
stato: todo                 # todo | in-corso | done
versione: <versione della Release che contiene l'Epic>
---

# E01 — <titolo dell'Epic>

> **Obiettivo di completamento.** Lo sviluppo di questa Epic è concluso solo quando la Definition of Done qui sotto è completa: ogni voce è soddisfatta e ha un'evidenza. Due soglie: la PR `release/*` si unisce in `main` solo con le voci da DoD-E1 a DoD-E6 soddisfatte; lo stato diventa `done` solo con tutte le voci, da DoD-E1 a DoD-E8.

## Obiettivo

Una o due frasi: quale esigenza del PO soddisfa questa Epic.

## Risultati misurabili

Ogni risultato si verifica con un test o con un comando.

| ID | Risultato | Verifica |
|---|---|---|
| R1 | <risultato con un valore che si può osservare> | <test o comando> |

## Feature

| ID | Titolo | Stato | Definition of Done |
|---|---|---|---|
| E01-F01 | <titolo> | todo | non completa |

## Definition of Done

Le voci vengono da `docs/team/backlog.md`. Il Pianificatore può aggiungere voci (da `DoD-E9`). Solo il PO può togliere una voce, con una ADR in `decisions.md`.

| ID | Voce | Soddisfatta | Evidenza |
|---|---|---|---|
| DoD-E1 | Tutte le Feature hanno la Definition of Done completa | ☐ | |
| DoD-E2 | Ogni risultato misurabile è verificato | ☐ | |
| DoD-E3 | Test d'integrazione verdi sul ramo `release/*` | ☐ | |
| DoD-E4 | Regola di qualità di `main`: test degli errori verdi, gestore globale presente | ☐ | |
| DoD-E5 | Manuali e log di sviluppo aggiornati | ☐ | |
| DoD-E6 | I due Reviewer approvano; PR `release/*` → `main` approvata dal PO | ☐ | |
| DoD-E7 | Release unita in `main` con il tag `v<versione>` | ☐ | |
| DoD-E8 | PR di riallineamento verso `develop` unita | ☐ | |

## Punti aperti

Domande per il PO che non hanno ancora una risposta.
