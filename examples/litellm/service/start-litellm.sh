#!/usr/bin/env bash
# Avvia LiteLLM proxy installato con `uv tool install 'litellm[proxy]'`.
# Usato dal LaunchAgent macOS. Parametri: WPC_DIR (default ~/wpc2026-litellm), LITELLM_PORT (default 4000).
set -euo pipefail
WPC_DIR="${WPC_DIR:-$HOME/wpc2026-litellm}"
LITELLM_PORT="${LITELLM_PORT:-4000}"
cd "$WPC_DIR"
set -a; . ./.env; set +a
exec "$HOME/.local/bin/litellm" --config "$WPC_DIR/config.yaml" --host 127.0.0.1 --port "$LITELLM_PORT"
