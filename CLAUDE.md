# CLAUDE.md — ITD5 Agentic Stack

## Project purpose

ITD5 Agentic Stack combines the Paperclip company operating system with optional gstack specialist workflows. This repository owns the ITD5 operating model and the safe Docker/operator experience.

## Runtime

- Canonical start: `bash scripts/launch.sh`
- Diagnostics: `bash scripts/doctor.sh`
- Compose service: official `ghcr.io/paperclipai/paperclip` image
- Dashboard: `http://localhost:3100`
- Readiness: `GET /api/health`
- Persistent state: `data/paperclip`
- Company definitions: `companies/itd5/`, mounted read-only

Do not run onboarding from a container restart command. Do not delete `data/paperclip` to fix a startup problem. Back it up before upgrades.

## Delivery workflow

1. `/office-hours` or `/plan-ceo-review` for intent and scope
2. `/plan-eng-review` for architecture and failure modes
3. Build the smallest useful change
4. `/review` for production risks
5. `/qa` or `/qa-only` for browser behavior
6. `/cso` for client-facing or data-handling changes
7. `/ship` only after evidence is complete
8. `/retro` to capture the process improvement

## Safety

- Keep secrets in `.env`, never in tracked files.
- Keep Paperclip private and authenticated by default.
- Treat client, WEEE, and data-destruction information as sensitive.
- Avoid speculative scope and unrelated cleanup.
- Prefer reversible changes with explicit validation and rollback steps.
