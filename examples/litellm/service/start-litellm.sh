#!/usr/bin/env bash
# Avvia LiteLLM proxy installato con `uv tool install 'litellm[proxy]==1.108.2'`.
# Usato in primo piano e dal LaunchAgent macOS. Parametri: WPC_DIR (default ~/wpc2026-litellm), LITELLM_PORT (default 4000).
set -euo pipefail
umask 077                                   # AZ-09: file creati solo per l'utente
WPC_DIR="${WPC_DIR:-$HOME/wpc2026-litellm}"
LITELLM_PORT="${LITELLM_PORT:-4000}"
cd "$WPC_DIR"
# shellcheck source=load-env.sh
. "$WPC_DIR/service/load-env.sh"
load_env_file "$WPC_DIR/.env"               # AZ-01, AZ-08: niente '. ./.env'
exec "$HOME/.local/bin/litellm" --config "$WPC_DIR/config.yaml" --host 127.0.0.1 --port "$LITELLM_PORT"
