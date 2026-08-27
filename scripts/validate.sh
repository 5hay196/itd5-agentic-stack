#!/usr/bin/env bash
# ITD5 Agentic Stack — local validation
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

command -v bash >/dev/null 2>&1 || { echo '[itd5] error: bash is required' >&2; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo '[itd5] error: python3 is required' >&2; exit 1; }
command -v docker >/dev/null 2>&1 || { echo '[itd5] error: docker is required' >&2; exit 1; }

echo '[itd5] checking shell syntax'
while IFS= read -r -d '' file; do
  bash -n "$file"
done < <(find "$ROOT_DIR/scripts" -type f -name '*.sh' -print0)

echo '[itd5] checking JSON configuration'
while IFS= read -r -d '' file; do
  python3 -m json.tool "$file" >/dev/null
done < <(find "$ROOT_DIR/companies" -type f -name '*.json' -print0)

echo '[itd5] checking Compose configuration'
if [ -f "${ITD5_ENV_FILE:-$ROOT_DIR/.env}" ]; then
  ENV_FILE="${ITD5_ENV_FILE:-$ROOT_DIR/.env}"
else
  ENV_FILE="$ROOT_DIR/.env.example"
  export BETTER_AUTH_SECRET="${BETTER_AUTH_SECRET:-ci-validation-secret}"
  export PAPERCLIP_TOOL_ACTION_SIGNING_SECRET="${PAPERCLIP_TOOL_ACTION_SIGNING_SECRET:-ci-validation-signing-secret}"
fi
docker compose --env-file "$ENV_FILE" -f "$ROOT_DIR/docker-compose.yml" config --quiet

echo '[itd5] validation passed'
