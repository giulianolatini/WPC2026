#!/usr/bin/env bash
# AZ-02: verifica la firma cosign dell'immagine LiteLLM e stampa i digest da scrivere in .env.
# Requisiti: docker, cosign. Parametri: LITELLM_TAG (default v1.108.2), POSTGRES_TAG (default 16).
# Fonti: docs/Sources.md#s-104 (chiave del commit e82a3c6), #s-109.
set -euo pipefail
LITELLM_TAG="${LITELLM_TAG:-v1.108.2}"
POSTGRES_TAG="${POSTGRES_TAG:-16}"
REPO="ghcr.io/berriai/litellm-non_root"
KEY_URL="https://raw.githubusercontent.com/BerriAI/litellm/e82a3c646908ba0a6ee0beddc4310d7a6cac4065/cosign.pub"
# Impronta SHA-256 PUBBLICA di cosign.pub (docs/Sources.md#s-104): non è un segreto.
KEY_SHA256="e3fe3e08c44b16407fe0b37c43b4f8b603b3a0f4ee74c29e647bc022d762c2c0" # gitleaks:allow

tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$KEY_URL" -o "$tmp/cosign.pub"
got=$( (sha256sum "$tmp/cosign.pub" 2>/dev/null || shasum -a 256 "$tmp/cosign.pub") | awk '{print $1}')
[ "$got" = "$KEY_SHA256" ] || { echo "Impronta di cosign.pub NON valida: $got" >&2; exit 1; }

docker pull -q "$REPO:$LITELLM_TAG" > /dev/null
docker pull -q "postgres:$POSTGRES_TAG" > /dev/null
lit=$(docker inspect --format='{{index .RepoDigests 0}}' "$REPO:$LITELLM_TAG")
pg=$(docker inspect --format='{{index .RepoDigests 0}}' "postgres:$POSTGRES_TAG")
# Firma verificata sul digest immutabile, non sul tag mobile (R-agy-15).
cosign verify --key "$tmp/cosign.pub" "$lit" > /dev/null
echo "# Firma verificata il $(date -u +%Y-%m-%dT%H:%M:%SZ). Copia in .env:"
echo "LITELLM_IMAGE=$lit"
echo "POSTGRES_IMAGE=$pg"
