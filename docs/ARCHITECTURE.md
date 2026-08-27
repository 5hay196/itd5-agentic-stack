# ITD5 Agentic Stack architecture

## Design goal

The stack has one boring, reliable runtime path and one optional productivity path:

1. Docker runs the official Paperclip control plane.
2. A bind mount preserves the entire Paperclip home directory.
3. The ITD5 operating model is versioned in this repository and mounted read-only for reference.
4. Claude Code plus gstack runs locally when installed, or can be connected to Paperclip through its supported agent adapters.

This separation means Paperclip restarts do not reinstall packages, rerun onboarding, or destroy state.

## Runtime topology

```text
Browser / Tailscale / reverse proxy
              │
              ▼
     host port ${PAPERCLIP_PORT:-3100}
              │
┌─────────────▼──────────────────────────────────────┐
│ official ghcr.io/paperclipai/paperclip image       │
│ HOST=0.0.0.0  PORT=3100  SERVE_UI=true             │
│ authenticated/private by default                   │
│                                                     │
│ /paperclip  ← persistent host bind mount           │
│ /opt/itd5-agentic-stack/companies ← read-only      │
└─────────────────────────────────────────────────────┘
```

## Persistence

`PAPERCLIP_DATA_DIR` defaults to `./data/paperclip`. The directory contains the embedded database, local secrets key, uploaded assets, and agent workspace data. Losing it is a destructive reset. The repository's `.gitignore` excludes it.

For a serious deployment, back up this directory using the host's encrypted backup policy. `bash scripts/backup.sh` creates a timestamped, mode-restricted archive in `backups/` by default. Do not put the live data directory in a public sync folder or commit it to Git.

## Configuration flow

- `.env.example` documents supported knobs.
- `scripts/launch.sh` copies `.env.example` to `.env` only when `.env` does not exist.
- Missing Paperclip secrets are generated locally with OpenSSL or `/dev/urandom`.
- `docker-compose.yml` validates required secrets and starts one service.
- `scripts/launch.sh` waits for `GET /api/health` before reporting success.
- `scripts/doctor.sh` checks the same assumptions without mutating state.

## ITD5 source model

`companies/itd5/` is the portable ITD5 operating model:

- `company.json` — mission, values, owner, budget, and agent roster
- `agents/*.json` — responsibilities, tools, KPIs, and prompts
- `goals/*.md` — current strategic goals and checkpoints

These files are mounted read-only. They are not silently imported because Paperclip's official container does not advertise an arbitrary JSON import contract. The operator can use them as the source of truth while creating or updating the corresponding Paperclip company, projects, goals, and agents through supported Paperclip workflows.

## Security boundaries

- Default exposure is private and authenticated.
- No API key is printed by the scripts.
- Secrets are generated into a mode-600 `.env` where supported.
- ITD5 configuration is read-only in the container.
- No host Docker socket is mounted.
- No privileged container mode is used.
- `pids_limit` and `init` provide basic process containment and child reaping.

Public exposure requires a separate deployment review: HTTPS, firewall rules, trusted origins, backups, update policy, and an incident recovery plan.

## Upgrade strategy

The default image tag tracks Paperclip stable. For a controlled environment, set `PAPERCLIP_IMAGE` to an approved release tag or immutable digest. Upgrade with:

```bash
docker compose --env-file .env pull
docker compose --env-file .env up -d
docker compose --env-file .env ps
curl --fail http://localhost:3100/api/health
```

Keep a backup of `data/paperclip` before upgrading. If the health check fails, inspect `docker compose --env-file .env logs --tail=200 paperclip` and restore the previous approved image tag rather than deleting the data directory.
