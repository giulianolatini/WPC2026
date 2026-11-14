# Regole di scrittura e dizionario

Lo Scrittore applica queste regole a tutti i documenti. Il Pianificatore le mantiene.
Le regole si ispirano ai principi dell'inglese tecnico semplificato (ASD-STE100) e sono adattate all'italiano. Sono testo originale di questo progetto: questo file non contiene testo dello standard.

## Regole

### Parole

1. Usa una parola per un solo significato e un solo termine per una cosa. Usa i termini del dizionario.
2. Non tradurre i nomi tecnici, i comandi e gli identificatori.
3. Scrivi i verbi in italiano, alla forma attiva.
4. Non usare sinonimi per variare il testo.

### Frasi

5. Una frase contiene un solo concetto. Lunghezza massima: 20 parole per un'istruzione, 25 per una descrizione.
6. Un'istruzione inizia con il verbo all'imperativo: «Apri il file», «Esegui il comando».
7. Metti la condizione prima dell'azione: «Se il test fallisce, leggi il messaggio».
8. Scrivi il soggetto in modo esplicito. Non usare «esso», «questo» senza il nome a cui si riferiscono.
9. Usa il presente. Usa il futuro solo per un evento che avviene dopo.

### Struttura

10. Un paragrafo tratta un solo argomento e ha al massimo 6 frasi.
11. Una procedura è una lista numerata: un passo, un'azione.
12. Metti gli avvisi di sicurezza prima del passo a cui si riferiscono.
13. Indica per ogni procedura il risultato atteso.
14. Usa una tabella per dati che si confrontano e una lista per elementi dello stesso tipo.

### Codice

15. Ogni frammento di codice è in un blocco con il linguaggio indicato e si può eseguire o compilare.
16. Non scrivere segreti nei frammenti: usa segnaposto come `<API_KEY>`.

## Dizionario dei termini

Il Pianificatore aggiunge i termini del progetto. Lo Scrittore usa solo il termine approvato.

| Termine approvato | Significato in questo progetto | Non usare |
|---|---|---|
| Epic | Obiettivo del progetto che si scompone in Feature | Epica, macro-attività |
| Feature | Parte di un'Epic che si chiude con una PR in `develop` | Funzionalità (per questo significato) |
| Task | Unità atomica di lavoro di una Feature | Compito, attività, ticket |
| backlog | Elenco ordinato di Epic, Feature e Task | Lista dei lavori |
| PO | Product Owner: la persona che esprime le esigenze e approva i risultati | Cliente, committente |
| manuale utente | Documento per chi usa il prodotto | Guida, help |
| manuale per sviluppatori | Documento per chi chiama le API del prodotto | Guida tecnica |
| Definition of Done | Elenco delle voci che una Feature o un'Epic deve soddisfare, con un'evidenza, per essere conclusa | Fatto, chiusura, DoD (nei manuali) |
| criterio di accettazione | Comportamento che un Task deve avere, scritto come «Dato…, quando…, allora…» con una verifica | Requisito (per questo significato) |
| evidenza | Comando, esito o file che dimostra una voce della Definition of Done | Prova, conferma |
