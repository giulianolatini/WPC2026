# Registro delle decisioni del progetto (ADR)

Il Pianificatore scrive questo file in `docs/backlog/decisions.md`. Il registro cresce solo in coda: una decisione accettata non si modifica. Una decisione nuova che ne cambia una precedente la **sostituisce**: la decisione vecchia riceve lo stato `Sostituita da ADR-NNN`.

| ADR | Data | Titolo | Stato |
|---|---|---|---|
| ADR-001 | <data> | Versione di Spec Kit | Accettata |

---

## ADR-001 — Versione di Spec Kit

- **Data:** <data> — **Stato:** Accettata — **Decisore:** PO (code owner)
- **Sostituisce:** nessuna

**Contesto.** Il progetto usa GitHub Spec Kit per specifiche, piani e rami di Feature.

**Decisione.** Il progetto usa Spec Kit `<versione installata>` (esito di `specify version`).

**Conseguenze.** A ogni nuova pianificazione il Pianificatore controlla se esiste una versione più recente e chiede al PO se aggiornare. Un aggiornamento accettato produce una ADR nuova che sostituisce questa.

---

## ADR-NNN — <titolo>

- **Data:** <data> — **Stato:** Accettata — **Decisore:** PO
- **Sostituisce:** <ADR-NNN oppure nessuna>

**Contesto.** <domanda e motivo della scelta>

**Alternative.** <al massimo 2 alternative, con il what-if dell'Avversario>

**Decisione.** <scelta del PO>

**Conseguenze.** <effetti sul piano, sul backlog, sui file>
