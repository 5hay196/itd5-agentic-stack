# ITD5 Agentic Stack

> Paperclip is the operating system. gstack is the specialist execution layer. ITD5 is the operating model that connects them.

The ITD5 Agentic Stack is a self-hosted foundation for running AI-assisted company operations: goals, agents, work queues, governance, delivery workflows, security review, and quality gates.

## The flagship promise

A fresh Linux machine with Docker and Git can go from zero to a persistent Paperclip dashboard with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/5hay196/itd5-agentic-stack/main/scripts/install.sh | bash
```

The installer clones or updates the stack in `~/.itd5-agentic-stack`, creates secure local secrets, starts the official Paperclip image, waits for `/api/health`, and prints the dashboard URL. It installs gstack only when Claude Code and Bun are already present; Paperclip remains useful without that optional integration.

For a more inspectable install, download the script first:

```bash
curl -fsSL https://raw.githubusercontent.com/5hay196/itd5-agentic-stack/main/scripts/install.sh -o install-itd5.sh
bash install-itd5.sh
```

## Requirements

For the Docker path:

- Linux, macOS, or WSL2
- Docker Engine or Docker Desktop with Docker Compose v2
- Git and curl
- A browser

Node.js, pnpm, and Bun are not required to run Paperclip in Docker. Claude Code and Bun are optional and are needed only if you want the launcher to install gstack automatically.

## Run from a checkout

```bash
git clone https://github.com/5hay196/itd5-agentic-stack.git
cd itd5-agentic-stack
bash scripts/launch.sh
```

The launcher is idempotent. Running it again reuses the same `.env`, secrets, and `data/paperclip` directory.

Open `http://localhost:3100`. On a fresh authenticated/private instance, use Paperclip's browser setup to sign in or claim the first admin. Then configure the ITD5 company and agents using the versioned definitions in `companies/itd5/`.

## Operator commands

```bash
bash scripts/doctor.sh       # prerequisites, secrets, JSON, Compose, health
bash scripts/validate.sh     # local CI-equivalent validation
bash scripts/backup.sh       # timestamped backup of Paperclip state
make logs                   # follow Paperclip logs
make ps                     # show service status
make restart                # restart Paperclip
make down                   # stop the stack without deleting data
```

To remove the container but keep all data:

```bash
docker compose --env-file .env down
```

To start over, stop the stack and deliberately remove `data/paperclip`. This deletes the local Paperclip database, uploads, local secrets key, and agent workspace data.

## Configuration

`.env.example` is safe to commit. `scripts/launch.sh` copies it to `.env` and generates:

- `BETTER_AUTH_SECRET` for authenticated sessions
- `PAPERCLIP_TOOL_ACTION_SIGNING_SECRET` for signed tool actions

Never commit `.env` or expose these values. Set `PAPERCLIP_PUBLIC_URL` when accessing Paperclip through a LAN hostname, Tailscale address, reverse proxy, or HTTPS URL. Keep `PAPERCLIP_DEPLOYMENT_EXPOSURE=private` unless you have TLS, a firewall, and an explicit public deployment plan.

The default deployment uses the official stable image `ghcr.io/paperclipai/paperclip:latest`, one host port (`3100`), and a bind-mounted data directory. For controlled environments, set `PAPERCLIP_IMAGE` to an approved release tag or immutable digest in `.env`.

## What is included

- Official Paperclip self-hosted container
- Persistent embedded database and Paperclip home directory
- Authentication and signed-action secrets generated on first run
- Health-checked restartable Compose service
- ITD5 company, agent, goals, and governance definitions under `companies/itd5/`
- Optional gstack installation for Claude Code
- `doctor.sh`, Make targets, and CI validation

The ITD5 JSON files are deliberately mounted as read-only reference material. Paperclip's supported Docker image does not automatically import arbitrary company JSON on startup; the dashboard setup and company/agent configuration remain an explicit operator step rather than a hidden mutation.

## Architecture

```text
                         optional local skills
                  ┌────────────────────────────┐
                  │ Claude Code + gstack        │
                  │ /office-hours /review /qa   │
                  └─────────────┬──────────────┘
                                │
┌───────────────┐      ┌────────▼────────┐      ┌───────────────────────┐
│ ITD5 source   │─────▶│ Paperclip       │─────▶│ Persistent /paperclip │
│ company model │ read │ control plane   │      │ database + workspaces │
└───────────────┘ only └────────┬────────┘      └───────────────────────┘
                                │
                         browser dashboard
                             localhost:3100
```

Paperclip handles company state, goals, work, budgets, governance, and agent coordination. gstack supplies repeatable specialist workflows for product thinking, engineering, QA, security, shipping, and retrospectives. API keys are optional at container startup but an agent provider must be configured before an agent can execute AI work.

## ITD5 operating model

| Role | Responsibility | Primary gstack workflows |
|---|---|---|
| CEO | Strategy, priorities, clients, budget | `/office-hours`, `/plan-ceo-review`, `/autoplan` |
| CTO | Architecture, delivery, infrastructure | `/plan-eng-review`, `/review`, `/ship` |
| CSO | Security, GDPR, ISO/NIST alignment | `/cso`, `/careful`, `/guard` |
| QA | Test planning, regression, acceptance | `/qa`, `/qa-only`, `/canary` |

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md), [`docs/WORKFLOW.md`](docs/WORKFLOW.md), and [`companies/itd5/`](companies/itd5/).

## Install gstack separately

The launcher detects Claude Code and Bun and installs gstack automatically by default. To run Paperclip only:

```bash
GSTACK_INSTALL=never bash scripts/launch.sh
```

To install or update it explicitly:

```bash
bash scripts/install-gstack.sh
```

gstack is maintained by [Garry Tan](https://github.com/garrytan/gstack) and is licensed separately under MIT. Its current setup supports Claude Code and other hosts; use the upstream documentation for host-specific options.

## Mobile and LAN access

For a private network or Tailscale deployment, set the reachable URL before starting:

```bash
PAPERCLIP_PUBLIC_URL=http://100.x.y.z:3100 bash scripts/launch.sh
```

Do not expose an unauthenticated or plain-HTTP Paperclip instance directly to the public internet. Put public deployments behind HTTPS, a firewall, and an explicit access policy.

## License

The ITD5 configuration and scripts in this repository are MIT licensed. Paperclip and gstack remain separate upstream projects with their own licenses and release schedules.
