# Feature Specification: Ruleset GitHub per i rami main e develop

**Feature Branch**: `feature/001-github-ruleset-main-develop`

**Created**: 2026-11-14

**Status**: Planned

**Input**: User description: "Ruleset GitHub per i rami `main` e `develop` di un repository gestito con GitFlow: PR obbligatoria su entrambi i rami, approvazione di un utente specifico su `main`, blocco dei push diretti e dei force-push, status check obbligatori; un agente AI che esegue `gh pr merge` con il token dell'utente non deve poter aggirare le regole. Rami di feature con prefisso `feature/`."

## Clarifications

### Session 2026-11-14

- Q: Quali status check sono obbligatori per il merge su `main` e `develop`? → A: Tre job CI, con questi nomi esatti: `build` (compilazione .NET), `test-dotnet` (test NUnit con `dotnet test`) e `test-powershell` (test Pester con `Invoke-Pester`). Valgono per entrambi i rami.
- Q: Chi è l'approvatore designato di `main`, e chi lo sostituisce in emergenza? → A: Approvatore designato `@release-approver`, unico code owner di `main`. Sostituto `@release-approver-backup`, che non è code owner ed è l'unico membro del team `release-emergency`. Quel team è l'unico attore di bypass, in modalità "For pull requests only".
- Q: Chi possiede il repository e con quale piano GitHub? → A: Repository privato `contoso/sample-app` dell'organizzazione `contoso`, su piano GitHub Team. L'agente AI opera tramite la GitHub App `contoso-copilot-agent`, con permesso write e senza bypass.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Nessuna modifica diretta ai rami protetti (Priority: P1)

Come maintainer voglio che nessuno, nemmeno un amministratore o un agente AI, possa fare push diretti, force-push o eliminare `main` e `develop`. Così la storia dei rami di integrazione e di rilascio resta integra e tracciabile.

**Why this priority**: è la protezione minima. Senza di essa le altre regole (PR, approvazioni, check) si aggirano con un semplice `git push`.

**Independent Test**: da un clone con permessi di scrittura, prova un push diretto, un force-push e un'eliminazione remota su `main` e su `develop`. Tutti e sei i tentativi devono essere rifiutati dal server.

**Acceptance Scenarios**:

1. **Given** un utente con ruolo write o admin non membro del team `release-emergency`, **When** esegue `git push origin main` con un commit nuovo, **Then** il push viene rifiutato con un messaggio che cita la regola violata.
2. **Given** lo stesso utente, **When** esegue `git push --force origin develop`, **Then** il push viene rifiutato.
3. **Given** lo stesso utente, **When** esegue `git push origin --delete main`, **Then** l'eliminazione viene rifiutata.
4. **Given** un utente qualsiasi, **When** fa push su un ramo `feature/001-esempio`, **Then** il push è accettato, perché le regole non si applicano ai rami di feature.

---

### User Story 2 - Integrazione solo tramite Pull Request con controlli superati (Priority: P1)

Come team di sviluppo voglio che ogni modifica a `develop` e a `main` arrivi da una Pull Request i cui status check obbligatori siano tutti superati. Così ogni integrazione è revisionabile e verificata automaticamente.

**Why this priority**: è il flusso operativo quotidiano di GitFlow (`feature/*` → `develop`, `release/*` e `hotfix/*` → `main`) e va garantito insieme alla User Story 1.

**Independent Test**: apri una PR da `feature/001-esempio` verso `develop` con il check `test-dotnet` che fallisce e verifica che il merge sia bloccato. Correggi il codice, attendi che il check passi e verifica che il merge sia consentito.

**Acceptance Scenarios**:

1. **Given** una PR verso `develop` con almeno uno status check obbligatorio fallito o in attesa, **When** un utente prova il merge, **Then** il merge è bloccato.
2. **Given** una PR verso `develop` con tutti gli status check obbligatori superati, **When** un utente con permesso write esegue il merge, **Then** il merge riesce senza approvazioni obbligatorie (vedi Assumptions).
3. **Given** una PR verso `main` con check superati ma senza l'approvazione richiesta dalla User Story 3, **When** si prova il merge, **Then** il merge è bloccato.
4. **Given** un ramo di PR non aggiornato rispetto al ramo base, **When** si prova il merge, **Then** il merge è bloccato finché il ramo non viene aggiornato.
5. **Given** una PR in cui uno dei check `build`, `test-dotnet` o `test-powershell` non è mai stato riportato, **When** si prova il merge, **Then** il merge è bloccato come se il check fosse fallito.

---

### User Story 3 - Approvazione obbligatoria dell'approvatore designato su main (Priority: P2)

Come responsabile dei rilasci voglio che nessuna PR verso `main` possa essere integrata senza l'approvazione esplicita dell'approvatore designato. Così ogni rilascio e ogni hotfix in produzione passa da una decisione umana identificata.

**Why this priority**: è il controllo di governance sui rilasci. Dipende dalle User Story 1 e 2, che devono già impedire le scorciatoie.

**Independent Test**: apri una PR `release/1.0.0` → `main` con i check superati. Verifica che l'approvazione di un altro collaboratore con permesso write non basti e che il merge si sblocchi solo dopo l'approvazione di `@release-approver`.

**Acceptance Scenarios**:

1. **Given** una PR verso `main` approvata solo da collaboratori diversi da `@release-approver`, **When** si prova il merge, **Then** il merge è bloccato.
2. **Given** una PR verso `main` approvata da `@release-approver`, **When** l'autore aggiunge un nuovo commit, **Then** l'approvazione precedente non vale più e serve una nuova approvazione.
3. **Given** una PR verso `main` approvata da `@release-approver` e con `build`, `test-dotnet` e `test-powershell` superati, **When** un utente con permesso write esegue il merge, **Then** il merge riesce.

---

### User Story 4 - Un agente AI non può aggirare le regole (Priority: P2)

Come maintainer che delega lavoro a un agente AI (per esempio GitHub Copilot che usa `gh pr merge`) voglio che l'agente sia soggetto esattamente alle stesse regole di un collaboratore senza privilegi di bypass. Così un errore o un prompt malevolo non può portare codice non approvato su `main` o `develop`.

**Why this priority**: l'agente opera con un token reale. Se quell'identità ha diritti di bypass, tutte le protezioni precedenti sono annullate.

**Independent Test**: con un token della GitHub App `contoso-copilot-agent`, esegui `gh pr merge <n>` e `gh pr merge <n> --admin` su una PR verso `main` priva di approvazione. Entrambi devono fallire.

**Acceptance Scenarios**:

1. **Given** l'identità `contoso-copilot-agent` e una PR verso `main` senza approvazione di `@release-approver`, **When** l'agente esegue `gh pr merge`, **Then** il merge è rifiutato.
2. **Given** la stessa situazione, **When** l'agente esegue `gh pr merge --admin`, **Then** il merge è rifiutato, perché `contoso-copilot-agent` non è un attore di bypass.
3. **Given** l'identità dell'agente, **When** prova un push diretto su `develop`, **Then** il push è rifiutato come nella User Story 1.
4. **Given** una PR verso `develop` con check superati, **When** l'agente esegue `gh pr merge --auto`, **Then** il merge avviene solo dopo che tutti i requisiti sono soddisfatti.

---

### User Story 5 - Procedura di emergenza senza approvatore designato (Priority: P3)

Come responsabile dei rilasci voglio che, se `@release-approver` non è disponibile, `@release-approver-backup` possa integrare un hotfix urgente su `main`. Deve però passare comunque da una PR, e l'operazione deve restare tracciata. Così la produzione non resta bloccata e nessuno fa push diretti.

**Why this priority**: è un caso raro, ma senza una procedura il team sarebbe spinto ad allentare le regole in fretta.

**Independent Test**: apri una PR `hotfix/1.0.1` → `main` con i check superati e senza l'approvazione di `@release-approver`. Verifica che `@release-approver-backup` possa fare il merge e che un push diretto, anche da parte sua, resti rifiutato.

**Acceptance Scenarios**:

1. **Given** una PR `hotfix/*` → `main` con i check superati e senza approvazione del code owner, **When** `@release-approver-backup` esegue il merge, **Then** il merge riesce come bypass "For pull requests only" e resta tracciato con autore, PR e data (FR-016).
2. **Given** `@release-approver-backup`, **When** prova un push diretto su `main`, **Then** il push è rifiutato.
3. **Given** un membro qualsiasi dell'organizzazione diverso da `@release-approver-backup`, **When** prova lo stesso merge di emergenza, **Then** il merge è rifiutato.

---

### User Story 6 - Rami di feature con prefisso GitFlow (Priority: P3)

Come sviluppatore che usa Spec Kit voglio che `/speckit-specify` crei rami con il prefisso `feature/`, per esempio `feature/001-github-ruleset-main-develop`. Così i rami generati seguono la convenzione GitFlow del team e sono riconoscibili dalle regole e dalla CI.

**Why this priority**: migliora la coerenza ma non incide sulla sicurezza dei rami protetti.

**Independent Test**: con l'estensione `git` installata e `branch_prefix: "feature"`, lancia `/speckit-specify` su una nuova descrizione e verifica il nome del ramo creato.

**Acceptance Scenarios**:

1. **Given** l'estensione `git` di Spec Kit con `branch_prefix: "feature"`, **When** si esegue `/speckit-specify` per una nuova feature, **Then** il ramo creato ha la forma `feature/NNN-<slug>` e parte da `develop`.
2. **Given** lo stesso ramo, **When** la feature è completa, **Then** viene integrata in `develop` solo tramite PR (User Story 2).

---

### Edge Cases

- **Approvatore designato autore della PR**: se `@release-approver` apre una PR verso `main`, il comportamento dell'auto-approvazione va verificato in fase di piano. L'agente usa sempre l'identità distinta `contoso-copilot-agent`, quindi le PR dell'agente non hanno questo problema.
- **Approvatore designato non disponibile**: si applica la procedura di emergenza della User Story 5. L'agente non viene mai aggiunto alla bypass list.
- **Approvatore designato che perde il permesso di scrittura** o lascia l'organizzazione: la sua approvazione non verrebbe più conteggiata. Il cambio di code owner passa da una PR su `main` integrata con la procedura di emergenza.
- **Status check rinominato o rimosso dalla CI**: se `build`, `test-dotnet` o `test-powershell` non vengono più riportati, tutti i merge si bloccano. Ogni rinomina dei job va fatta nella stessa PR che aggiorna il ruleset.
- **Hotfix in presenza di un ramo `release/*` aperto**: secondo GitFlow l'hotfix va integrato nel ramo di release invece che in `develop`. Il ruleset non deve impedirlo.
- **PR verso `main` da un ramo diverso da `release/*` o `hotfix/*`**: il ruleset non limita il ramo sorgente. Il controllo è demandato alla revisione dell'approvatore o a un check dedicato (fuori ambito, vedi Assumptions).
- **Ruleset sovrapposti**: se altri ruleset o branch protection rule colpiscono gli stessi rami, si applica la versione più restrittiva. Non devono esistere regole che allentino questi requisiti.
- **Fork**: le PR da fork usano il file dei code owner del ramo base del repository upstream.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Le regole MUST applicarsi esattamente ai rami `main` e `develop` e a nessun altro ramo, in particolare non a `feature/*`, `release/*` e `hotfix/*`.
- **FR-002**: Ogni modifica a `main` e a `develop` MUST passare da una Pull Request. I push diretti MUST essere rifiutati per chiunque non sia nella bypass list.
- **FR-003**: I force-push su `main` e `develop` MUST essere rifiutati.
- **FR-004**: L'eliminazione di `main` e `develop` MUST essere rifiutata.
- **FR-005**: Il merge verso `main` e verso `develop` MUST richiedere il superamento di tre status check obbligatori con questi nomi esatti: `build`, `test-dotnet` (NUnit) e `test-powershell` (Pester). Un check assente MUST essere trattato come non superato.
- **FR-006**: Il ramo della PR MUST essere aggiornato rispetto al ramo base prima del merge (modalità strict).
- **FR-007**: Il merge verso `main` MUST richiedere l'approvazione di `@release-approver`, unico code owner del ramo. L'approvazione di altri collaboratori MUST NOT bastare.
- **FR-008**: Un nuovo commit su una PR verso `main` MUST invalidare le approvazioni ricevute in precedenza.
- **FR-009**: Il merge verso `develop` MUST richiedere una PR con check superati. Le approvazioni obbligatorie sono 0 (vedi Assumptions).
- **FR-010**: L'unico attore di bypass, in tutti i ruleset che coprono `main` e `develop`, MUST essere il team `release-emergency` (unico membro `@release-approver-backup`), in modalità "For pull requests only" e solo per il requisito di approvazione su `main`. MUST NOT includere ruoli generici (admin, maintain, write), la GitHub App `contoso-copilot-agent` o altre automazioni.
- **FR-011**: Ogni merge eseguito dall'agente AI tramite `contoso-copilot-agent` MUST essere soggetto alle stesse regole di un collaboratore senza bypass, anche se richiesto con privilegi amministrativi (`gh pr merge --admin`).
- **FR-012**: Le regole MUST essere attive (enforcement attivo) e non in sola valutazione.
- **FR-013**: La configurazione dei ruleset MUST essere versionata nel repository, in un formato esportabile e reimportabile, così da poterla rivedere tramite PR e ricreare in modo identico.
- **FR-014**: I rami di feature generati da Spec Kit MUST seguire il formato `feature/NNN-<slug>` (estensione `git` con `branch_prefix: "feature"`).
- **FR-015**: Ogni violazione rifiutata MUST restituire all'utente o all'agente un messaggio che identifichi la regola violata.
- **FR-016**: Ogni merge di emergenza fatto con il bypass di `release-emergency` MUST essere tracciabile, con autore, PR e data, e MUST essere documentato con una issue entro 1 giorno lavorativo.
- **FR-017**: L'identità `contoso-copilot-agent` MUST NOT avere il permesso Administration sul repository, così non può modificare il ruleset, la bypass list o i propri permessi. La verifica di FR-011 e FR-017 MUST essere ripetibile e MUST distinguere un rifiuto del ruleset da un errore di autenticazione.

### Key Entities *(include if feature involves data)*

- **Ruleset**: insieme nominato di regole con stato di enforcement, rami bersaglio (`main`, `develop`) e bypass list.
- **Ramo protetto**: `main` (produzione, con un tag per ogni versione) e `develop` (integrazione).
- **Pull Request**: unica via di modifica dei rami protetti. Ha un ramo sorgente (`feature/*`, `release/*`, `hotfix/*`), un ramo base, approvazioni e stato dei check.
- **Approvatore designato**: `@release-approver`, persona con permesso write la cui approvazione è necessaria e sufficiente per `main`.
- **Sostituto di emergenza**: `@release-approver-backup`, unico membro del team `release-emergency`. Può fare il merge di PR su `main` solo tramite bypass "For pull requests only".
- **Status check obbligatorio**: risultato della CI, identificato per nome (`build`, `test-dotnet`, `test-powershell`), che deve risultare superato.
- **Attore di bypass**: solo il team `release-emergency`, in modalità "For pull requests only".
- **Identità dell'agente**: GitHub App `contoso-copilot-agent`, con permesso write e senza diritti di bypass.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Il 100% dei tentativi di push diretto, force-push ed eliminazione su `main` e `develop` previsti dalla suite di verifica viene rifiutato (6 scenari su 6).
- **SC-002**: Il 100% dei tentativi di merge verso `main` senza approvazione di `@release-approver` viene rifiutato, compresi quelli fatti con `--admin` da `contoso-copilot-agent`. L'unica eccezione è il merge di emergenza di `@release-approver-backup`.
- **SC-003**: Nessuna PR viene integrata in `main` o `develop` con uno status check obbligatorio fallito o assente (0 casi nel registro dei merge dei primi 30 giorni).
- **SC-004**: Una PR `feature/*` → `develop` conforme si integra senza interventi manuali sulle regole entro 5 minuti dal superamento dei check.
- **SC-005**: Il ruleset si ricrea da zero dalla configurazione versionata in meno di 10 minuti, con un risultato identico all'originale.
- **SC-006**: Il 100% dei rami creati da `/speckit-specify` dopo l'attivazione rispetta il formato `feature/NNN-<slug>`.
- **SC-007**: Il 100% dei merge di emergenza ha una issue di documentazione collegata entro 1 giorno lavorativo.

## Assumptions

- Il repository è `contoso/sample-app`: privato, di proprietà dell'organizzazione `contoso`, ospitato su GitHub.com con piano GitHub Team. Su questo piano i ruleset sono disponibili anche per i repository privati.
- L'approvazione di un utente specifico si ottiene con la regola dei code owner. Il file dei code owner sul ramo `main` elenca solo l'approvatore designato, perché basta l'approvazione di uno qualsiasi dei code owner. Il ruleset non ha un'opzione nativa per nominare un singolo utente.
- L'agente AI usa la GitHub App `contoso-copilot-agent`, un'identità distinta dall'approvatore, con permesso write e senza bypass.
- Su `develop` non sono richieste approvazioni (0). La PR e i check bastano. Il valore si può alzare in seguito senza cambiare la specifica.
- Fuori ambito: limitare il ramo sorgente delle PR verso `main` a `release/*` e `hotfix/*`, proteggere i tag di versione, firmare i commit, imporre una storia lineare e gestire una merge queue. Possono diventare feature successive.
- I nomi `contoso`, `sample-app`, `release-approver`, `release-approver-backup`, `release-emergency` e `contoso-copilot-agent` sono valori di esempio, da sostituire con quelli reali prima di `/speckit-plan`.
- Il flusso di rami segue GitFlow (V. Driessen) con `main` al posto di `master`: `feature/*` da `develop` a `develop`, `release/*` da `develop` a `main` e `develop`, `hotfix/*` da `main` a `main` e `develop`.
- Spec Kit è alla versione 1.4.0 o successiva, con l'estensione `git` installata (`specify extension add git`).
