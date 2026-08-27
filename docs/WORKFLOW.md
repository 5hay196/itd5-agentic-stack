# ITD5 operating workflow

## First boot

1. Run `bash scripts/launch.sh` or the one-line installer.
2. Open the printed dashboard URL.
3. Complete Paperclip's first-admin setup.
4. Create or configure the ITD5 company using `companies/itd5/company.json`.
5. Create the CEO, CTO, CSO, and QA agents using the files under `companies/itd5/agents/`.
6. Load the current goals from `companies/itd5/goals/`.
7. Configure an approved LLM provider and agent adapter before enabling execution.
8. Run `bash scripts/doctor.sh` and record the first healthy state.

The repository stores the operating model; Paperclip stores the live execution state. Keep both aligned through reviewed changes.

## Weekly cycle

### Plan

- CEO reviews company goals, budget, client commitments, and open Paperclip work.
- Convert priorities into bounded tickets with an owner, acceptance criteria, risk, and target date.
- CTO, CSO, and QA confirm dependencies and review gates before work starts.

### Execute

- CTO owns implementation and technical decisions.
- CSO reviews security, privacy, data handling, and compliance impact.
- QA defines the validation path early and records evidence against the ticket.
- Agents report blockers, budget risk, and scope changes in Paperclip instead of silently expanding work.

### Review and release

Use the smallest applicable gstack sequence:

```text
product intent → /office-hours or /plan-ceo-review
architecture   → /plan-eng-review
implementation → build
code quality   → /review
browser QA     → /qa or /qa-only
security       → /cso
release        → /ship
reflection     → /retro
```

A client-facing or data-handling change does not ship until QA evidence and the required security review are complete.

### Friday retro

- Review completed, blocked, reopened, and failed tickets.
- Compare spend and activity with the Paperclip budget.
- Capture one process improvement and one risk for the next sprint.
- Update the goals file only through a reviewed repository change.

## Recovery and operations

```bash
bash scripts/doctor.sh
bash scripts/validate.sh
docker compose --env-file .env ps
docker compose --env-file .env logs --tail=200 paperclip
curl --fail http://localhost:3100/api/health
```

A restart is safe and preserves data:

```bash
make restart
```

Do not delete `data/paperclip` as a troubleshooting shortcut. Treat that directory as the system of record and back it up before upgrades or migrations.

## Change control

Every change to deployment, secrets, agent prompts, company goals, or governance must be:

- reviewed in Git;
- validated by CI;
- tested against a disposable or backed-up instance where practical;
- documented if it changes the operator path;
- rolled back by changing the image/configuration to the last known-good version, not by destroying state.
