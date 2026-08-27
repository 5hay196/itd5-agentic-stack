#!/usr/bin/env bash
# ITD5 Agentic Stack — optional gstack installer
set -Eeuo pipefail

GSTACK_REPO="${GSTACK_REPO:-https://github.com/garrytan/gstack.git}"
GSTACK_DIR="${GSTACK_DIR:-${HOME}/.claude/skills/gstack}"

fail() { printf '[itd5] error: %s\n' "$*" >&2; exit 1; }
command -v git >/dev/null 2>&1 || fail "git is required to install gstack"
command -v bun >/dev/null 2>&1 || fail "Bun is required by gstack. Install Bun, then run this script again."

if [ -d "$GSTACK_DIR/.git" ]; then
  printf '[itd5] updating gstack in %s\n' "$GSTACK_DIR"
  git -C "$GSTACK_DIR" pull --ff-only
else
  [ ! -e "$GSTACK_DIR" ] || fail "gstack destination exists but is not a Git checkout: $GSTACK_DIR"
  mkdir -p "$(dirname "$GSTACK_DIR")"
  printf '[itd5] cloning gstack into %s\n' "$GSTACK_DIR"
  git clone --single-branch --depth 1 "$GSTACK_REPO" "$GSTACK_DIR"
fi

( cd "$GSTACK_DIR" && ./setup )
printf '[itd5] gstack is installed for Claude Code\n'
