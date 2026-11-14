---
id: E01-F01
titolo: <titolo della Feature>
stato: todo                 # todo | in-corso | in-review | done
ramo: feature/001-<slug>    # ramo creato da Spec Kit
spec: specs/001-<slug>/     # spec.md, plan.md, tasks.md
pr: <numero della PR verso develop>
---

# E01-F01 — <titolo della Feature>

> **Obiettivo di completamento.** Lo sviluppo di questa Feature è concluso solo quando la Definition of Done qui sotto è completa: ogni voce è soddisfatta e ha un'evidenza. Fino a quel momento lo stato non è `done` e la PR non si unisce.

## Obiettivo

Una frase: cosa può fare l'utente quando la Feature è finita.

## Task

| ID | Titolo | Figura | Dipende da | Stato |
|---|---|---|---|---|
| E01-F01-T01 | <test di …> | tester | — | todo |
| E01-F01-T02 | <implementazione di …> | sviluppatore | E01-F01-T01 | todo |
| E01-F01-T03 | <documentazione di …> | scrittore | E01-F01-T02 | todo |

## Definition of Done

Le voci vengono da `docs/team/backlog.md`. Il Pianificatore può aggiungere voci (da `DoD-F10`). Solo il PO può togliere una voce, con una decisione in `decisions.md`.

| ID | Voce | Soddisfatta | Evidenza |
|---|---|---|---|
| DoD-F1 | Tutti i Task sono `done`; ogni criterio di accettazione è superato | ☐ | |
| DoD-F2 | Build senza errori | ☐ | |
| DoD-F3 | Tutti i test automatici verdi sul ramo | ☐ | |
| DoD-F4 | Ogni input non valido ed errore previsto ha un test verde | ☐ | |
| DoD-F5 | Documentazione scritta secondo le regole di scrittura | ☐ | |
| DoD-F6 | Controlli di stato della PR verdi | ☐ | |
| DoD-F7 | I due Reviewer approvano; nessun rilievo `alta` o `media` aperto | ☐ | |
| DoD-F8 | PR unita in `develop` con un merge commit | ☐ | |
| DoD-F9 | Backlog aggiornato | ☐ | |

## Log

Data, figura, azione, risultato. L'Organizzatore aggiunge una riga per ogni Task chiuso e per ogni review.
