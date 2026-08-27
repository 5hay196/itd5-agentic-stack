# Self-hosted and cost-aware operation

Paperclip and the ITD5 scripts can be self-hosted without a Paperclip SaaS account. That does not make model inference, electricity, storage, backups, or optional infrastructure free.

## Keep the control plane local

- Run the official Paperclip container on a machine you control.
- Persist `/paperclip` through `data/paperclip` or an approved host path.
- Keep the deployment private and authenticated by default.
- Use the optional provider variables only for providers you have approved.

## Control model spend

- Configure budgets and approval gates in Paperclip.
- Start with one agent and one bounded ticket.
- Prefer local or already-paid-for agent adapters where appropriate.
- Review spend weekly and investigate sudden increases.
- Never place provider secrets in company JSON, goals, Git history, or logs.

## Backups and updates

Back up `data/paperclip` before upgrading the image. Pin `PAPERCLIP_IMAGE` to an approved tag or digest for repeatable environments. Test upgrades on a copy first when the instance contains important work.

## Optional gstack

gstack is a separate MIT-licensed project. It is optional for Paperclip runtime operation and requires its own host requirements, including Bun for setup and the selected AI coding host. The ITD5 launcher skips it when those prerequisites are absent.
