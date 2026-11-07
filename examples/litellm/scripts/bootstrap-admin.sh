#!/usr/bin/env bash
# AZ-04: crea il primo utente proxy_admin con password (profilo esteso).
# L'API accetta la master key anche con disable_env_credential_login: true (docs/Sources.md#s-148).
# Parametri: ADMIN_ID (default wpc-admin), ADMIN_EMAIL (obbligatorio), PROXY_URL (default http://localhost:4000).
# La password è chiesta in modo interattivo: almeno 12 caratteri con maiuscole, minuscole, cifre e simboli.
set -euo pipefail
WPC_DIR="${WPC_DIR:-$HOME/wpc2026-litellm}"
. "$WPC_DIR/service/load-env.sh"; load_env_file "$WPC_DIR/.env"
ADMIN_ID="${ADMIN_ID:-wpc-admin}"
ADMIN_EMAIL="${ADMIN_EMAIL:?imposta ADMIN_EMAIL}"
PROXY_URL="${PROXY_URL:-http://localhost:4000}"
read -r -s -p "Password per $ADMIN_ID: " ADMIN_PASSWORD; echo
# La master key va in un file temporaneo (curl -H @file): non compare nella lista dei processi.
umask 077; hdr=$(mktemp); trap 'rm -f "$hdr"' EXIT
printf 'Authorization: Bearer %s\nContent-Type: application/json\n' "$LITELLM_MASTER_KEY" > "$hdr"
auth=(-H @"$hdr")
curl -fsS -X POST "$PROXY_URL/user/new" "${auth[@]}" \
  -d "{\"user_id\":\"$ADMIN_ID\",\"user_email\":\"$ADMIN_EMAIL\",\"user_role\":\"proxy_admin\",\"auto_create_key\":false}" > /dev/null
# Il JSON con la password è costruito da stdin: la password non compare nella riga di comando (ps).
python3 -c 'import json,sys;print(json.dumps({"user_id":sys.argv[1],"password":sys.stdin.read().rstrip("\n")}))' "$ADMIN_ID" <<<"$ADMIN_PASSWORD" \
  | curl -fsS -X POST "$PROXY_URL/user/update" "${auth[@]}" -d @- > /dev/null
echo "Creato proxy_admin '$ADMIN_ID'. Verifica il login su $PROXY_URL/ui con email e password."
