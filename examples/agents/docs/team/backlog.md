# Backlog: Epic, Feature, Task

Il Pianificatore scrive il backlog. L'Organizzatore aggiorna lo stato e le evidenze. Le altre figure leggono solo il task ricevuto.

> **Regola di completamento.** Lo sviluppo di una Feature o di un'Epic è concluso **solo** quando la sua *Definition of Done* è completa: ogni voce è soddisfatta e ha un'evidenza. Una voce non soddisfatta, o senza evidenza, significa «non concluso». Non esiste lo stato «concluso, tranne…».
>
> **Due soglie.** Alcune voci esistono solo dopo il merge. Il **merge** in `develop` richiede le voci da DoD-F1 a DoD-F7; il merge in `main` richiede le voci da DoD-E1 a DoD-E6. Lo stato **`done`** richiede tutte le voci: da DoD-F1 a DoD-F9, da DoD-E1 a DoD-E8.

## Struttura delle cartelle

```text
specs/                                  # specifiche e piani di GitHub Spec Kit (una cartella NNN-<slug> per Feature)
docs/backlog/
├── README.md                           # indice delle Epic con lo stato
├── decisions.md                        # scelte del PO registrate nel brainstorming
└── E01-<nome-epic>/
    ├── epic.md                         # obiettivo, risultati misurabili, Definition of Done, Feature
    └── F01-<nome-feature>/
        ├── feature.md                  # obiettivo, ramo, Definition of Done, Task
        ├── T01-<nome-task>.md
        └── T02-<nome-task>.md
```

I modelli dei tre file sono in [templates/](templates/): [epic.md](templates/epic.md), [feature.md](templates/feature.md), [task.md](templates/task.md). Il Pianificatore copia il modello e non toglie sezioni.

## Identificativi

`E<nn>` Epic, `E<nn>-F<nn>` Feature, `E<nn>-F<nn>-T<nn>` Task. Un identificativo non cambia e non si riusa.
Il ramo di una Feature è il ramo che Spec Kit crea: `feature/<NNN>-<slug>`. Il file `feature.md` registra il ramo e la cartella `specs/<NNN>-<slug>/`.

## Due controlli diversi

| | Criteri di accettazione | Definition of Done |
|---|---|---|
| Domanda | «Questo Task fa quello che deve fare?» | «Questa Feature (o Epic) è finita?» |
| Livello | Task | Feature, Epic |
| Contenuto | Comportamenti del prodotto, diversi per ogni Task | Stato di qualità richiesto, uguale per tutte le Feature (o per tutte le Epic) |
| Chi li scrive | Pianificatore | Standard del team in questo file; il Pianificatore aggiunge voci, non ne toglie |
| Chi li verifica | Tester (con i test), Organizzatore | Organizzatore, i due Reviewer, PO |
| Esito | Ogni criterio: superato o non superato | Completa o non completa |

I criteri di accettazione superati sono **una** voce della Definition of Done, non la sostituiscono.

## Definition of Done di una Feature

Il file `feature.md` contiene questa tabella. L'Organizzatore compila la colonna **Evidenza**.

| ID | Voce | Evidenza richiesta | Chi verifica |
|---|---|---|---|
| DoD-F1 | Tutti i Task della Feature sono `done` e ogni criterio di accettazione è superato | Elenco dei Task con stato e test collegati | Organizzatore, Reviewer |
| DoD-F2 | La build termina senza errori | Comando `dotnet build` ed esito | Organizzatore, Reviewer |
| DoD-F3 | Tutti i test automatici sono verdi sul ramo della Feature | Comandi `dotnet test` e `Invoke-Pester`, numero di test superati e falliti | Organizzatore, Reviewer |
| DoD-F4 | Ogni input non valido e ogni errore previsto dai Task ha un test verde | Nomi dei test di errore | Reviewer antagonista |
| DoD-F5 | La documentazione della Feature è scritta e rispetta [writing-rules.md](writing-rules.md) | Percorsi dei file: log, riferimento API, manuali | Reviewer ottimista |
| DoD-F6 | I controlli di stato della PR sono verdi sull'ultimo commit (`build`, `test-dotnet`, `test-powershell`) | Esito di `gh pr checks <numero>` e hash del commit, in un commento della PR | Organizzatore, Reviewer |
| DoD-F7 | I due Reviewer hanno esito `APPROVA` sull'ultimo commit; nessun rilievo `alta` o `media` è aperto | Esito, data e hash del commit delle due review, in un commento della PR | Organizzatore |
| DoD-F8 | La PR è unita in `develop` con un merge commit | Numero della PR e hash del merge | Organizzatore |
| DoD-F9 | Il backlog è aggiornato con una PR che modifica solo `docs/backlog/`: evidenze da DoD-F6 a DoD-F8 compilate | Numero della PR di aggiornamento | Organizzatore, Reviewer ottimista |

Ordine: l'Organizzatore compila in `feature.md` le evidenze da DoD-F1 a DoD-F5 e registra DoD-F6 in un commento della PR, **prima** delle review. Un commit nuovo sul ramo avvia controlli nuovi: per questo DoD-F6 e DoD-F7 non entrano nel ramo prima del merge. I Reviewer controllano solo queste voci (e le voci aggiunte dal Pianificatore). L'Organizzatore chiude DoD-F7 quando ha i due esiti `APPROVA`, poi DoD-F8 e DoD-F9 dopo il merge. Per un'Epic i Reviewer controllano da DoD-E1 a DoD-E5; DoD-E6, DoD-E7 e DoD-E8 si chiudono dopo.

## Definition of Done di un'Epic

Il file `epic.md` contiene questa tabella.

| ID | Voce | Evidenza richiesta | Chi verifica |
|---|---|---|---|
| DoD-E1 | Tutte le Feature dell'Epic hanno la Definition of Done completa | Elenco delle Feature con stato | Organizzatore |
| DoD-E2 | Ogni risultato misurabile dell'Epic è verificato | Per ogni risultato: test o comando ed esito | Organizzatore, PO |
| DoD-E3 | I test d'integrazione del Tester sono verdi sul ramo `release/*` | Comando, numero di test superati e falliti | Organizzatore, Reviewer |
| DoD-E4 | Regola di qualità di `main`: nessun rilievo aperto su eccezioni non gestite; il prodotto ha un gestore globale degli errori | Esito del Reviewer antagonista sulla PR verso `main` | Reviewer antagonista |
| DoD-E5 | Manuale utente, manuale per sviluppatori e log di sviluppo sono aggiornati | Percorsi dei file | Reviewer ottimista |
| DoD-E6 | Il PO ha approvato la PR `release/*` → `main` | Review di approvazione del PO sulla PR | PO |
| DoD-E7 | La Release è unita in `main` e ha il tag `v<versione>` | Hash del merge e nome del tag | PO, Organizzatore |
| DoD-E8 | La PR di riallineamento verso `develop` è unita | Numero della PR | Organizzatore |

## Criteri di accettazione di un Task

Un criterio di accettazione descrive **un** comportamento che si può osservare. Usa questa forma:

```markdown
- [ ] **AC-1** — Dato <stato iniziale>, quando <azione>, allora <risultato che si può osservare>.
      Verifica: <nome del test o comando>
```

Regole:

1. Un criterio, un comportamento. Se la frase contiene «e» tra due risultati, scrivi due criteri.
2. Il risultato è un valore, un messaggio, un codice di uscita o uno stato. Scrivi il valore esatto.
3. Non usare parole che non si possono misurare: «corretto», «veloce», «robusto», «adeguato», «gestito bene».
4. Ogni Task di codice ha almeno un criterio per un input non valido e uno per un errore previsto.
5. Ogni criterio ha il campo **Verifica**. Il Tester scrive nel campo il nome del test che lo copre.

| Non chiaro | Chiaro |
|---|---|
| «L'ordine viene validato correttamente» | «Dato un ordine con quantità `0`, quando chiamo `OrderValidator.Validate`, allora il risultato contiene l'errore `QuantityOutOfRange`» |
| «Gli errori sono gestiti» | «Dato un file di configurazione che non esiste, quando avvio lo script, allora lo script scrive `Config file not found: <percorso>` e termina con codice `2`» |

## Regole per un Task atomico

- Una sola figura lo completa.
- Ha un solo risultato, che si può verificare.
- Non richiede scelte di prodotto: le scelte sono già in `decisions.md`.
- Per il codice: un task `tester` (test che falliscono) e poi un task `sviluppatore` o `operativo` che dipende dal primo. Il task `tester` è `done` con i test rossi: i criteri di accettazione risultano superati solo alla chiusura del task di implementazione.

## Stati

| Elemento | Stati | `done` significa |
|---|---|---|
| Task `tester` | `todo`, `in-corso`, `in-review`, `done`, `bloccato` | I test compilano, coprono ogni criterio di accettazione e falliscono perché l'implementazione manca (*red*) |
| Task `sviluppatore`, `operativo` | come sopra | Tutti i test passano: ogni criterio di accettazione ha la verifica superata (*green*) |
| Task `scrittore` | come sopra | I documenti indicati esistono e descrivono il codice del ramo |
| Feature | `todo`, `in-corso`, `in-review`, `done` | Definition of Done della Feature completa (da DoD-F1 a DoD-F9) |
| Epic | `todo`, `in-corso`, `done` | Definition of Done dell'Epic completa (da DoD-E1 a DoD-E8) |

Solo l'Organizzatore cambia uno stato in `done`, e solo dopo aver compilato le evidenze.
