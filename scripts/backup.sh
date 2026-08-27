#!/usr/bin/env bash
# ITD5 Agentic Stack — backup Paperclip state
# Usage: bash scripts/backup.sh [destination-directory]
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ITD5_ENV_FILE:-${ROOT_DIR}/.env}"
DEST_DIR="${1:-${ROOT_DIR}/backups}"

fail() { printf '[itd5] error: %s\n' "$*" >&2; exit 1; }

command -v tar >/dev/null 2>&1 || fail "tar is required"
[ -f "$ENV_FILE" ] || fail "missing $ENV_FILE; run scripts/launch.sh first"

DATA_DIR="$(awk -F= '$1 == "PAPERCLIP_DATA_DIR" { print $2; exit }' "$ENV_FILE")"
DATA_DIR="${DATA_DIR:-./data/paperclip}"
case "$DATA_DIR" in
  /*) ;;
  *) DATA_DIR="${ROOT_DIR}/${DATA_DIR#./}" ;;
esac

[ -d "$DATA_DIR" ] || fail "Paperclip data directory does not exist: $DATA_DIR"
mkdir -p "$DEST_DIR"

STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
ARCHIVE="${DEST_DIR%/}/paperclip-${STAMP}.tar.gz"
TEMP_ARCHIVE="${ARCHIVE}.tmp"

# Archive the directory itself so restoring preserves the expected layout.
tar -C "$(dirname "$DATA_DIR")" -czf "$TEMP_ARCHIVE" "$(basename "$DATA_DIR")"
mv -f "$TEMP_ARCHIVE" "$ARCHIVE"
chmod 600 "$ARCHIVE" 2>/dev/null || true

printf '[itd5] backup created: %s\n' "$ARCHIVE"
printf '[itd5] restore only after stopping Paperclip, then extract into the project data directory.\n'
