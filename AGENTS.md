# AGENTS.md — ITD5 Agentic Stack

This file configures multi-agent support. gstack works on any agent that supports the SKILL.md standard.

## Supported Agents

| Agent | Install Path | Notes |
|---|---|---|
| Claude Code | `~/.claude/skills/gstack` | Primary — full feature support |
| Codex CLI | `~/.codex/skills/gstack` | `./setup --host codex` |
| Gemini CLI | `~/.gemini/skills/gstack` | `./setup --host auto` |
| Cursor | `.agents/skills/gstack` | `./setup --host auto` |
| Factory Droid | `~/.factory/skills/gstack-*/` | `./setup --host factory` |

## Install for Claude Code (Primary)

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

## Install for Codex

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.codex/skills/gstack
cd ~/.codex/skills/gstack && ./setup --host codex
```

## Install for Gemini CLI / Cursor (auto-detect)

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/gstack
cd ~/gstack && ./setup --host auto
```

## Repo Map (for agent context)

```
itd5-agentic-stack/
├── CLAUDE.md                 # Claude Code configuration
├── AGENTS.md                 # This file — multi-agent config
├── companies/itd5/           # ITD5 company definition
├── scripts/bootstrap.sh      # Full setup in one command
└── docs/ARCHITECTURE.md      # System architecture
```

## Paperclip Adapter

Paperclip (running at `http://localhost:3100`) orchestrates agent work.
Agents receive work via heartbeats and ticket assignments.

Heartbeat flow:
1. Paperclip sends heartbeat to agent
2. Agent checks its task queue
3. Agent picks up ticket and uses appropriate gstack skill
4. Agent reports back with result

## Skills Available to All Agents

All 31 gstack skills work across all supported agents:
`/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`,
`/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`,
`/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/connect-chrome`,
`/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`,
`/retro`, `/investigate`, `/document-release`, `/codex`, `/cso`, `/autoplan`,
`/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`

> Note: Hook-based safety skills (`/careful`, `/freeze`, `/guard`) use inline safety advisory prose on non-Claude hosts.
