#!/usr/bin/env bash
# AZ-04: crea il primo utente proxy_admin con password (profilo esteso).
# L'API accetta la master key anche con disable_env_credential_login: true (docs/Sources.md#s-148).
# Parametri: ADMIN_ID (default wpc-admin), ADMIN_EMAIL (obbligatorio), PROXY_URL (default http://localhost:${LITELLM_PORT:-4000}),
#            RESUME=1 per ripetere solo l'impostazione della password se l'utente esiste già (es. dopo un errore).
# La password è chiesta in modo interattivo: almeno 12 caratteri con maiuscole, minuscole, cifre e simboli.
# Su Windows usa scripts/Bootstrap-Admin.ps1.
set -euo pipefail
WPC_DIR="${WPC_DIR:-$HOME/wpc2026-litellm}"
. "$WPC_DIR/service/load-env.sh"; load_env_file "$WPC_DIR/.env"
: "${LITELLM_MASTER_KEY:?LITELLM_MASTER_KEY vuota in .env}"          # fail-closed (R-agy-12)
ADMIN_ID="${ADMIN_ID:-wpc-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:-}"
PROXY_URL="${PROXY_URL:-http://localhost:${LITELLM_PORT:-4000}}"
RESUME="${RESUME:-0}"
[ "$RESUME" = 1 ] || [ -n "$ADMIN_EMAIL" ] || { echo "Imposta ADMIN_EMAIL" >&2; exit 1; }

read -r -s -p "Password per $ADMIN_ID: " ADMIN_PASSWORD; echo
# Policy password LiteLLM controllata PRIMA di ogni chiamata API (R-agy-12, R-codex-11):
# così un errore di policy non lascia un utente senza password.
if ! { [ "${#ADMIN_PASSWORD}" -ge 12 ] && [[ "$ADMIN_PASSWORD" =~ [A-Z] ]] && [[ "$ADMIN_PASSWORD" =~ [a-z] ]] \
       && [[ "$ADMIN_PASSWORD" =~ [0-9] ]] && [[ "$ADMIN_PASSWORD" =~ [^A-Za-z0-9] ]]; }; then
  echo "Password non valida: minimo 12 caratteri con maiuscole, minuscole, cifre e simboli." >&2; exit 1
fi

# La master key va in un file temporaneo (curl -H @file): non compare nella lista dei processi.
umask 077; hdr=$(mktemp); trap 'rm -f "$hdr"' EXIT
printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$LITELLM_MASTER_KEY" > "$hdr"
auth=(-H @"$hdr")

if [ "$RESUME" != 1 ]; then
  # JSON costruito con json.dumps: niente interpolazione di stringhe (R-agy-02, R-codex-09).
  python3 -c 'import json,sys;print(json.dumps({"user_id":sys.argv[1],"user_email":sys.argv[2],"user_role":"proxy_admin","auto_create_key":False}))' "$ADMIN_ID" "$ADMIN_EMAIL" \
    | curl -fsS -X POST "$PROXY_URL/user/new" "${auth[@]}" --data-binary @- > /dev/null \
    || { echo "Creazione fallita. Se l'utente '$ADMIN_ID' esiste già, ripeti con RESUME=1." >&2; exit 1; }
fi
# Password (e ruolo, per la ripresa) in un'unica chiamata; il JSON arriva da stdin (password fuori da ps).
python3 -c 'import json,sys;print(json.dumps({"user_id":sys.argv[1],"user_role":"proxy_admin","password":sys.stdin.read().rstrip("\n")}))' "$ADMIN_ID" <<<"$ADMIN_PASSWORD" \
  | curl -fsS -X POST "$PROXY_URL/user/update" "${auth[@]}" --data-binary @- > /dev/null \
  || { echo "Impostazione della password fallita. Correggi la causa e ripeti con RESUME=1." >&2; exit 1; }
echo "proxy_admin '$ADMIN_ID' pronto. Verifica il login su $PROXY_URL/ui con email e password."
