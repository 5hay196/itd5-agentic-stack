#!/usr/bin/env bash
# ITD5 Agentic Stack — Docker launcher
#
# Run from the repository:
#   ./scripts/launch.sh
#
# Or use the remote one-liner:
#   curl -fsSL https://raw.githubusercontent.com/5hay196/itd5-agentic-stack/main/scripts/install.sh | bash

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ITD5_ENV_FILE:-${ROOT_DIR}/.env}"
COMPOSE_FILE="${ROOT_DIR}/docker-compose.yml"
GSTACK_INSTALL="${GSTACK_INSTALL:-auto}"
WAIT_SECONDS="${ITD5_WAIT_SECONDS:-120}"

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() { printf '%b\n' "${BLUE}[itd5]${NC} $*"; }
warn() { printf '%b\n' "${YELLOW}[itd5]${NC} $*" >&2; }
fail() { printf '%b\n' "${RED}[itd5] error:${NC} $*" >&2; exit 1; }

set_env_if_blank() {
  local key="$1"
  local value="$2"
  if grep -q "^${key}=" "$ENV_FILE"; then
    if grep -q "^${key}=$" "$ENV_FILE"; then
      awk -v k="$key" -v v="$value" 'BEGIN { changed=0 } $0 == k "=" { print k "=" v; changed=1; next } { print } END { if (!changed) exit 1 }' "$ENV_FILE" > "${ENV_FILE}.tmp"
      mv "${ENV_FILE}.tmp" "$ENV_FILE"
    fi
  else
    printf '\n%s=%s\n' "$key" "$value" >> "$ENV_FILE"
  fi
}

random_secret() {
  if command -v openssl >/dev/null 2>&1; then
    openssl rand -hex 32
  elif command -v od >/dev/null 2>&1; then
    od -An -N32 -tx1 /dev/urandom | tr -d ' \n'
  else
    fail "openssl or /dev/urandom is required to generate secure Paperclip secrets"
  fi
}

compose() {
  docker compose --env-file "$ENV_FILE" -f "$COMPOSE_FILE" "$@"
}

require_tools() {
  command -v docker >/dev/null 2>&1 || fail "Docker is required. Install Docker Engine or Docker Desktop, then retry."
  docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 is required (the 'docker compose' command)."
  docker info >/dev/null 2>&1 || fail "Docker is installed but the daemon is not reachable. Start Docker and retry."
  command -v curl >/dev/null 2>&1 || fail "curl is required for the readiness check."
}

prepare_env() {
  if [ ! -f "$ENV_FILE" ]; then
    [ -f "${ROOT_DIR}/.env.example" ] || fail "missing .env.example"
    cp "${ROOT_DIR}/.env.example" "$ENV_FILE"
    chmod 600 "$ENV_FILE" 2>/dev/null || true
    log "created $ENV_FILE"
  fi

  set_env_if_blank BETTER_AUTH_SECRET "$(random_secret)"
  set_env_if_blank PAPERCLIP_TOOL_ACTION_SIGNING_SECRET "$(random_secret)"
}

health_url() {
  local port
  port="$(awk -F= '$1 == "PAPERCLIP_PORT" { print $2; exit }' "$ENV_FILE")"
  printf 'http://localhost:%s/api/health' "${port:-3100}"
}

wait_for_health() {
  local url="$1"
  local deadline=$((SECONDS + WAIT_SECONDS))
  log "waiting for Paperclip readiness at ${url}"
  while [ "$SECONDS" -lt "$deadline" ]; do
    if curl --fail --silent --show-error --max-time 4 "$url" >/dev/null 2>&1; then
      return 0
    fi
    sleep 2
  done
  return 1
}

install_gstack_if_requested() {
  case "$GSTACK_INSTALL" in
    0|false|no|never) return 0 ;;
    1|true|yes|always) ;;
    auto)
      if ! command -v claude >/dev/null 2>&1; then
        log "Claude Code not found; skipping optional gstack installation"
        return 0
      fi
      if ! command -v bun >/dev/null 2>&1; then
        warn "Claude Code found but Bun is missing; skipping gstack (set GSTACK_INSTALL=never to silence this)"
        return 0
      fi
      ;;
    *) fail "GSTACK_INSTALL must be auto, always, or never" ;;
  esac

  bash "${ROOT_DIR}/scripts/install-gstack.sh"
}

main() {
  cd "$ROOT_DIR"
  require_tools
  prepare_env

  log "validating Compose configuration"
  compose config --quiet

  log "starting Paperclip"
  compose up -d

  local url
  url="$(health_url)"
  if ! wait_for_health "$url"; then
    warn "Paperclip did not become ready within ${WAIT_SECONDS}s"
    compose ps
    compose logs --tail=100 paperclip >&2 || true
    exit 1
  fi

  install_gstack_if_requested

  printf '\n%b\n' "${GREEN}ITD5 Agentic Stack is ready.${NC}"
  printf '  Dashboard: %s\n' "${url%/api/health}"
  printf '  Health:    %s\n' "$url"
  printf '  Data:      %s\n' "${ROOT_DIR}/data/paperclip"
  printf '\n  First run: open the dashboard, create/claim the first admin, then configure your ITD5 agents.\n'
  printf '  Inspect:   %s/scripts/doctor.sh\n' "$ROOT_DIR"
  printf '  Logs:      docker compose --env-file .env logs -f paperclip\n\n'
}

main "$@"
