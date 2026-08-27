#!/usr/bin/env bash
# Backward-compatible entry point for starting Paperclip.
set -Eeuo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
exec bash "$ROOT_DIR/scripts/launch.sh" "$@"
