# ITD5 Agentic Stack

> **Paperclip** (company OS) + **gstack** (Claude Code skill engine) = a fully autonomous AI-powered business, self-hosted and 100% free.

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Paperclip](https://img.shields.io/badge/Paperclip-OSS-black)](https://github.com/paperclipai/paperclip)
[![gstack](https://img.shields.io/badge/gstack-OSS-orange)](https://github.com/garrytan/gstack)

---

## What is this?

This repo is the **ITD5 Agentic Stack** — a batteries-included, self-hosted setup that combines:

| Tool | Role | Cost |
|---|---|---|
| **[Paperclip](https://github.com/paperclipai/paperclip)** | Company OS — org charts, goals, tickets, budgets, heartbeats, governance dashboard | Free / MIT |
| **[gstack](https://github.com/garrytan/gstack)** | 31 Claude Code slash-command skills — CEO, Eng Manager, Designer, QA, CSO, Release Engineer | Free / MIT |

**Paperclip** orchestrates *who* works on *what* and *why*.  
**gstack** gives your Claude Code agents the *how* — 31 specialist skills to execute with.

---

## Quick Start (Local — 100% Free)

### Requirements
- Node.js 20+
- pnpm 9.15+
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Git, Bun v1.0+

### 1. Clone this repo

```bash
git clone https://github.com/Shay196/itd5-agentic-stack.git
cd itd5-agentic-stack
```

### 2. Run bootstrap (sets up everything)

```bash
chmod +x scripts/bootstrap.sh
./scripts/bootstrap.sh
```

Or run manually:

```bash
# Start Paperclip
npx paperclipai onboard --yes
# Paperclip runs at http://localhost:3100

# Install gstack skills into Claude Code
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

### 3. Open Paperclip Dashboard

Navigate to `http://localhost:3100` — you'll see the ITD5 company org chart, goals, and agent queue.

### 4. Open Claude Code and start your first sprint

```
/office-hours
```

---

## Docker (Alternative)

```bash
cp .env.example .env
# Fill in your API keys in .env
docker compose up -d
```

Paperclip API: `http://localhost:3100`  
Paperclip UI: `http://localhost:3101`

---

## Repository Structure

```
itd5-agentic-stack/
├── README.md                    # This file
├── .env.example                 # All config in one place
├── docker-compose.yml           # One-command local launch
├── CLAUDE.md                    # gstack skills pre-configured for Claude Code
├── AGENTS.md                    # Multi-agent adapter map (Codex, Gemini, Cursor)
├── LICENSE
├── .gitignore
├── scripts/
│   ├── bootstrap.sh             # Full stack setup in one shot
│   ├── start-paperclip.sh       # Launch Paperclip server
│   └── install-gstack.sh        # Install gstack globally
├── companies/
│   └── itd5/
│       ├── company.json         # ITD5 company definition for Paperclip
│       ├── agents/
│       │   ├── ceo.json         # CEO agent config
│       │   ├── cto.json         # CTO / gstack-powered dev agent
│       │   ├── cso.json         # Security Officer (maps to /cso skill)
│       │   └── qa.json          # QA Lead (maps to /qa skill)
│       └── goals/
│           └── q2-2026.md       # Company goals flowing to all agents
└── docs/
    ├── ARCHITECTURE.md          # How Paperclip + gstack connect
    ├── WORKFLOW.md              # Sprint workflow guide
    └── PAPERCLIP-FREE-GUIDE.md  # Stay 100% free and self-hosted
```

---

## How It All Connects

```
[You / Shay196]
     |
     v
[Paperclip Dashboard :3100]
  - Define goals
  - Review tickets
  - Set budgets
  - Approve strategy
     |
     v
[AI Agents (Claude Code + gstack skills)]
  CEO   --> /office-hours, /plan-ceo-review
  CTO   --> /plan-eng-review, /review, /ship
  CSO   --> /cso (OWASP + STRIDE audits)
  QA    --> /qa, /qa-only, /canary
     |
     v
[Your Codebase / Client Projects]
```

---

## gstack Skills Available

Once installed, these slash commands are available inside Claude Code:

| Skill | Specialist | Purpose |
|---|---|---|
| `/office-hours` | YC Office Hours | Start here — reframes your product idea |
| `/plan-ceo-review` | CEO | 10-section product review |
| `/plan-eng-review` | Eng Manager | Architecture, diagrams, edge cases |
| `/design-consultation` | Design Partner | Full design system from scratch |
| `/review` | Staff Engineer | Finds production bugs, auto-fixes |
| `/qa` | QA Lead | Real browser, real clicks, fixes bugs |
| `/cso` | Chief Security Officer | OWASP Top 10 + STRIDE threat model |
| `/ship` | Release Engineer | Sync, test, push, open PR |
| `/retro` | Eng Manager | Weekly team retro across all projects |
| `/investigate` | Debugger | Systematic root-cause debugging |
| `/browse` | QA Engineer | Real Chromium browser automation |
| `/learn` | Memory | Compound learnings across sessions |
| `/autoplan` | Review Pipeline | CEO + design + eng review in one command |

> Full list of 31 skills: see [CLAUDE.md](CLAUDE.md)

---

## Mobile Access

To access your Paperclip dashboard from your phone:

1. Install [Tailscale](https://tailscale.com/) on your machine and phone (free tier)
2. Start Paperclip: `npx paperclipai onboard --yes`
3. Access via your Tailscale IP: `http://[tailscale-ip]:3100`

---

## Sources

- Paperclip: https://github.com/paperclipai/paperclip
- gstack: https://github.com/garrytan/gstack
- Paperclip website: https://paperclip.ing

---

## License

MIT — built for ITD5 by Seamus Walsh (Shay196)
