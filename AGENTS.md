# AGENTS.md — ITD5 Agentic Stack

## Mission

This repository is the reviewed operating model and deployment wrapper for ITD5. Keep the runtime simple, persistent, private by default, and observable.

## Runtime rules

- Use `bash scripts/launch.sh` as the canonical local start command.
- Use `scripts/install.sh` for the remote one-line Linux bootstrap.
- Do not reintroduce `npx paperclipai onboard` into a restart command; onboarding is stateful and must not run on every container restart.
- Do not expose `.env`, `data/paperclip`, or provider credentials in commits, logs, screenshots, or tickets.
- Treat `data/paperclip` as the system of record; back it up before image upgrades.
- Keep `companies/itd5/` read-only inside the container. Changes go through Git review.

## gstack hosts

The optional gstack installer targets Claude Code by default. For other hosts, use the upstream gstack setup options rather than copying skills into undocumented locations:

```bash
bash scripts/install-gstack.sh
# or, after cloning gstack:
./setup --host codex
./setup --host cursor
./setup --host auto
```

## Delivery loop

```text
intent → plan → build → review → QA → security → ship → retro
```

Use `/cso` for client-facing or data-handling work, `/qa` for browser behavior, `/review` for code quality, and `/ship` only after the requested validation is complete.
