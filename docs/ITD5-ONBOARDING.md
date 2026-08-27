# ITD5 onboarding checklist

The stack intentionally separates immutable source configuration from live Paperclip state. This makes startup safe and avoids an undocumented import API.

## Checklist

- [ ] Start the stack and complete first-admin setup.
- [ ] Create the ITD5 company from `companies/itd5/company.json`.
- [ ] Create the CEO, CTO, CSO, and QA agents from their JSON definitions.
- [ ] Add the goals from `companies/itd5/goals/`.
- [ ] Set budgets, approval rules, and allowed tools.
- [ ] Configure an approved adapter and provider secret through Paperclip's supported settings.
- [ ] Run a low-risk test ticket.
- [ ] Confirm the ticket, heartbeat, budget, and audit trail.
- [ ] Record any live-state differences as a reviewed repository change.

## Why this is explicit

A container startup script should be idempotent and safe to restart. Automatically creating companies, agents, or tickets would need a supported, authenticated, version-aware Paperclip API and could create duplicates or mutate a live instance after every restart. Until that contract is defined, the repository files are the reviewed operating model and the Paperclip dashboard is the deliberate provisioning surface.
