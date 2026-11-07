#!/usr/bin/env bash
# Carica un file .env come coppie CHIAVE=valore, SENZA eseguirlo come script (AZ-08).
# Uso: . load-env.sh && load_env_file /percorso/.env   (il file definisce solo la funzione)
# Rifiuta il file se non appartiene all'utente corrente o se altri utenti possono leggerlo o scriverlo (AZ-01, R-agy-06).
load_env_file() {
  local file="$1" perms line key value
  [ -f "$file" ] || { echo "load-env: file non trovato: $file" >&2; return 1; }
  [ -O "$file" ] || { echo "load-env: $file non appartiene all'utente corrente" >&2; return 1; }
  perms=$(stat -c '%a' "$file" 2>/dev/null || stat -f '%Lp' "$file")
  if [ "${perms: -2}" != "00" ]; then
    echo "load-env: permessi $perms su $file: esegui 'chmod 600 $file'" >&2; return 1
  fi
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%$'\r'}"
    [[ -z "$line" || "$line" == \#* ]] && continue
    if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
      key="${BASH_REMATCH[1]}"; value="${BASH_REMATCH[2]}"
      # rimuove virgolette esterne, nessuna espansione di variabili o comandi
      [[ "$value" =~ ^\"(.*)\"$ || "$value" =~ ^\'(.*)\'$ ]] && value="${BASH_REMATCH[1]}"
      export "$key=$value"
    else
      echo "load-env: riga ignorata (formato non valido)" >&2
    fi
  done < "$file"
}
