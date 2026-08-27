#!/usr/bin/env bash
# ITD5 Agentic Stack — diagnostics
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ITD5_ENV_FILE:-${ROOT_DIR}/.env}"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.yml"

ok() { printf '  [ok]   %s\n' "$*"; }
warn() { printf '  [warn] %s\n' "$*"; }
fail_check() { printf '  [fail] %s\n' "$*"; }

printf 'ITD5 Agentic Stack doctor\n\n'

if command -v docker >/dev/null 2>&1; then ok "Docker installed"; else fail_check "Docker is not installed"; fi
if docker compose version >/dev/null 2>&1; then ok "Docker Compose v2 available"; else fail_check "Docker Compose v2 unavailable"; fi
if docker info >/dev/null 2>&1; then ok "Docker daemon reachable"; else warn "Docker daemon is not reachable"; fi

if [ -f "$ENV_FILE" ]; then
  ok "environment file exists: $ENV_FILE"
  if grep -q '^BETTER_AUTH_SECRET=.' "$ENV_FILE"; then ok "BETTER_AUTH_SECRET is set"; else fail_check "BETTER_AUTH_SECRET is empty"; fi
  if grep -q '^PAPERCLIP_TOOL_ACTION_SIGNING_SECRET=.' "$ENV_FILE"; then ok "tool-action signing secret is set"; else fail_check "PAPERCLIP_TOOL_ACTION_SIGNING_SECRET is empty"; fi
else
  warn "no .env file; run ./scripts/launch.sh"
fi

if command -v python3 >/dev/null 2>&1; then
  while IFS= read -r file; do
    if python3 -m json.tool "$file" >/dev/null 2>&1; then ok "valid JSON: ${file#"$ROOT_DIR/"}"; else fail_check "invalid JSON: ${file#"$ROOT_DIR/"}"; fi
  done < <(find "$ROOT_DIR/companies" -type f -name '*.json' -print 2>/dev/null)
else
  warn "python3 unavailable; skipped JSON validation"
fi

if [ -f "$ENV_FILE" ] && docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" config --quiet >/dev/null 2>&1; then
  ok "Compose configuration is valid"
elif [ -f "$ENV_FILE" ]; then
  fail_check "Compose configuration is invalid"
fi

if command -v curl >/dev/null 2>&1; then
  port=3100
  if [ -f "$ENV_FILE" ]; then port="$(awk -F= '$1 == "PAPERCLIP_PORT" { print $2; exit }' "$ENV_FILE")"; fi
  if curl --fail --silent --max-time 4 "http://localhost:${port:-3100}/api/health" >/dev/null 2>&1; then ok "Paperclip health endpoint is ready"; else warn "Paperclip health endpoint is not responding"; fi
fi

if command -v claude >/dev/null 2>&1; then ok "Claude Code detected"; else warn "Claude Code not detected (gstack integration will be skipped)"; fi
if command -v bun >/dev/null 2>&1; then ok "Bun detected"; else warn "Bun not detected (gstack installation requires it)"; fi

printf '\nDoctor complete.\n'
if [ "$FAILURES" -gt 0 ]; then
  printf '[itd5] %s hard check(s) failed.\n' "$FAILURES" >&2
  exit 1
fi
