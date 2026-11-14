# Backlog: Epic, Feature, Task

Il Pianificatore scrive il backlog. L'Organizzatore aggiorna lo stato. Le altre figure leggono solo il task ricevuto.

## Struttura delle cartelle

```text
specs/                                  # specifiche e piani di GitHub Spec Kit
docs/backlog/
├── README.md                           # indice delle Epic con lo stato
├── decisions.md                        # scelte del PO registrate nel brainstorming
└── E01-<nome-epic>/
    ├── epic.md                         # obiettivo, risultato atteso, elenco delle Feature
    └── F01-<nome-feature>/
        ├── feature.md                  # descrizione, ramo, criteri di chiusura, elenco dei Task
        ├── T01-<nome-task>.md
        └── T02-<nome-task>.md
```

## Identificativi

`E<nn>` Epic, `E<nn>-F<nn>` Feature, `E<nn>-F<nn>-T<nn>` Task. Un identificativo non cambia e non si riusa.

## Formato di un Task

```markdown
---
id: E01-F02-T03
titolo: Validazione dell'ordine
figura: sviluppatore        # tester | sviluppatore | operativo | scrittore
stato: todo                 # todo | in-corso | in-review | done | bloccato
dipende-da: [E01-F02-T02]   # il task di test viene prima del task di implementazione
ramo: feature/E01-F02-ordini
---

## Obiettivo
Una frase.

## Contesto
File da leggere: specifica, piano, test, codice.

## Criteri di accettazione
- [ ] Criterio che si può verificare con un comando o un test.
- [ ] Gestione degli errori: input non validi ed eccezioni previste.

## Risultato
File prodotti e comando di verifica. L'Organizzatore compila questa sezione alla chiusura.
```

## Regole per un Task atomico

- Una sola figura lo completa.
- Ha un solo risultato, che si può verificare.
- Non richiede scelte di prodotto: le scelte sono già in `decisions.md`.
- Per il codice: un task `tester` (test che falliscono) e poi un task `sviluppatore` o `operativo` che dipende dal primo.

## Chiusura

- **Feature:** tutti i Task `done`, documentazione della Feature scritta, PR in `develop` unita.
- **Epic:** tutte le Feature chiuse e presenti in una Release unita in `main`.
