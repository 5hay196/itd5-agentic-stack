#!/usr/bin/env bash
# =============================================================
# ITD5 Agentic Stack — Bootstrap Script
# Sets up Paperclip + gstack in one shot
# Usage: chmod +x scripts/bootstrap.sh && ./scripts/bootstrap.sh
# =============================================================

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "  _____ _______ _____  ____"
echo " |_   _|__   __|  __ \\|___ \\"
echo "   | |    | |  | |  | | __) |"
echo "   | |    | |  | |  | ||__ <"
echo "  _| |_   | |  | |__| |___) |"
echo " |_____|  |_|  |_____/|____/"
echo ""
echo "  Agentic Stack Bootstrap"
echo -e "${NC}"

echo -e "${YELLOW}Step 1: Checking requirements...${NC}"

# Check Node.js
if ! command -v node &> /dev/null; then
  echo "ERROR: Node.js 20+ is required. Install from https://nodejs.org"
  exit 1
fi
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  echo "ERROR: Node.js 20+ required. Found v$NODE_VERSION"
  exit 1
fi
echo "  Node.js: OK ($(node -v))"

# Check pnpm
if ! command -v pnpm &> /dev/null; then
  echo "  pnpm not found. Installing..."
  npm install -g pnpm@9
fi
echo "  pnpm: OK ($(pnpm -v))"

# Check bun
if ! command -v bun &> /dev/null; then
  echo "  Bun not found. Installing..."
  curl -fsSL https://bun.sh/install | bash
  export PATH="$HOME/.bun/bin:$PATH"
fi
echo "  Bun: OK ($(bun -v))"

echo ""
echo -e "${YELLOW}Step 2: Setting up Paperclip...${NC}"

if [ -f ".env" ]; then
  echo "  .env found — keeping existing config"
else
  cp .env.example .env
  echo "  Created .env from .env.example"
  echo -e "  ${YELLOW}ACTION REQUIRED: Add your ANTHROPIC_API_KEY to .env${NC}"
fi

echo "  Starting Paperclip onboarding..."
npx paperclipai onboard --yes
echo -e "  ${GREEN}Paperclip ready at http://localhost:3100${NC}"

echo ""
echo -e "${YELLOW}Step 3: Installing gstack skills for Claude Code...${NC}"

GSTACK_DIR="$HOME/.claude/skills/gstack"
if [ -d "$GSTACK_DIR" ]; then
  echo "  gstack already installed at $GSTACK_DIR"
  echo "  Upgrading..."
  cd "$GSTACK_DIR" && git pull && ./setup
  cd - > /dev/null
else
  git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$GSTACK_DIR"
  cd "$GSTACK_DIR" && ./setup
  cd - > /dev/null
fi
echo -e "  ${GREEN}gstack installed — 31 skills available in Claude Code${NC}"

echo ""
echo -e "${GREEN}==================================================${NC}"
echo -e "${GREEN}  ITD5 Agentic Stack is ready!${NC}"
echo -e "${GREEN}==================================================${NC}"
echo ""
echo "  Paperclip Dashboard: http://localhost:3100"
echo ""
echo "  Next steps:"
echo "  1. Open http://localhost:3100 and set up your ITD5 company"
echo "  2. Open Claude Code and run: /office-hours"
echo "  3. For mobile access, install Tailscale (https://tailscale.com)"
echo ""
echo -e "  Happy shipping! 🚀"
