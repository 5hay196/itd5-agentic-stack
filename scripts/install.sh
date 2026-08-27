#!/usr/bin/env bash
# ITD5 Agentic Stack — remote one-line installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/5hay196/itd5-agentic-stack/main/scripts/install.sh | bash
#
# Override the destination with ITD5_STACK_DIR=/path/to/stack.

set -Eeuo pipefail

REPO_URL="${ITD5_STACK_REPO:-https://github.com/5hay196/itd5-agentic-stack.git}"
REF="${ITD5_STACK_REF:-main}"
INSTALL_DIR="${ITD5_STACK_DIR:-${HOME}/.itd5-agentic-stack}"

fail() {
  printf '[itd5] error: %s\n' "$*" >&2
  exit 1
}

command -v git >/dev/null 2>&1 || fail "git is required. Install git and run this command again."

if [ -e "$INSTALL_DIR" ] && [ ! -d "$INSTALL_DIR" ]; then
  fail "install path exists but is not a directory: $INSTALL_DIR"
fi

if [ -d "$INSTALL_DIR/.git" ]; then
  printf '[itd5] updating %s\n' "$INSTALL_DIR"
  git -C "$INSTALL_DIR" fetch --depth 1 origin "$REF"
  git -C "$INSTALL_DIR" pull --ff-only origin "$REF" || fail "local changes or divergent history found in $INSTALL_DIR; update it manually, then retry"
elif [ -e "$INSTALL_DIR" ] && [ "$(find "$INSTALL_DIR" -mindepth 1 -maxdepth 1 -print -quit)" ]; then
  fail "install path is not an empty Git checkout: $INSTALL_DIR"
else
  printf '[itd5] cloning %s into %s\n' "$REPO_URL" "$INSTALL_DIR"
  git clone --depth 1 --branch "$REF" "$REPO_URL" "$INSTALL_DIR"
fi

exec bash "$INSTALL_DIR/scripts/launch.sh" "$@"
