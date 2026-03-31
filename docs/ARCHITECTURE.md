# ITD5 Agentic Stack — Architecture

## Overview

The ITD5 Agentic Stack is a multi-agent AI system built on **Paperclip** (project management) and **gstack** (AI coding sprints). It runs 4 specialized Claude agents that autonomously manage ITD5's operations.

## Stack Layers

```
┌─────────────────────────────────────────┐
│           Claude Agents (x4)            │
│   CEO | CTO | CSO | QA                  │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│              Paperclip                  │
│   Ticket management, project tracking   │
│   Self-hosted via Docker                │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│               gstack                   │
│   AI coding sprints, git integration   │
│   Weekly retros, 100k+ LOC target      │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│         Infrastructure (AWS)            │
│   EC2, S3, RDS, CloudWatch             │
└─────────────────────────────────────────┘
```

## Agent Roles

| Agent | Role | Primary Tool | KPI |
|-------|------|-------------|-----|
| CEO   | Strategy & coordination | Paperclip | 2+ client projects |
| CTO   | Technical delivery | gstack | 100k+ LOC |
| CSO   | Security & compliance | Paperclip | 10+ audits |
| QA    | Quality assurance | Paperclip | 20+ tickets/week |

## Data Flow

1. CEO Agent sets weekly priorities in Paperclip
2. CTO Agent runs gstack sprints based on priorities
3. QA Agent reviews and tests all code before merge
4. CSO Agent audits completed features for compliance
5. All agents report KPIs back to CEO Agent weekly

## Security

- All agents run within VPC (no public exposure)
- Paperclip self-hosted — no data leaves ITD5 infrastructure
- ISO 27001 controls enforced by CSO Agent
- GDPR compliance checked on all client-facing features
- OWASP + STRIDE audits before each client release

## File Structure

```
itd5-agentic-stack/
├── CLAUDE.md              # Claude/gstack config
├── AGENTS.md              # Multi-agent instructions
├── docker-compose.yml     # Paperclip + services
├── .env.example           # Environment template
├── scripts/
│   └── bootstrap.sh       # Setup script
├── companies/
│   └── itd5/
│       ├── company.json   # Company profile
│       ├── agents/        # Agent configs
│       │   ├── ceo.json
│       │   ├── cto.json
│       │   ├── cso.json
│       │   └── qa.json
│       └── goals/
│           └── q2-2026.md # Quarterly goals
└── docs/
    ├── ARCHITECTURE.md    # This file
    └── WORKFLOW.md        # Sprint workflow
```
