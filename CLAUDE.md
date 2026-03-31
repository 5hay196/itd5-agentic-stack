# CLAUDE.md — ITD5 Agentic Stack

This file configures Claude Code to use the gstack skill system for the ITD5 Agentic Stack project.

---

## gstack

Use `/browse` from gstack for all web browsing. Never use `mcp__claude-in-chrome__*` tools.

Available skills:
`/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/plan-design-review`, `/design-consultation`, `/design-shotgun`, `/design-html`, `/review`, `/ship`, `/land-and-deploy`, `/canary`, `/benchmark`, `/browse`, `/connect-chrome`, `/qa`, `/qa-only`, `/design-review`, `/setup-browser-cookies`, `/setup-deploy`, `/retro`, `/investigate`, `/document-release`, `/codex`, `/cso`, `/autoplan`, `/careful`, `/freeze`, `/guard`, `/unfreeze`, `/gstack-upgrade`, `/learn`

If gstack skills aren't working, run:
```bash
cd ~/.claude/skills/gstack && ./setup
```

---

## Project Context: ITD5

**Company:** ITD5 — IT consulting, digital transformation, cybersecurity, SaaS, and 3D printing services.

**Owner:** Seamus Walsh — Dublin, Ireland.

**Mission:** Build and operate autonomous AI-powered business systems for ITD5 and its clients.

**Key projects:**
- ITD5 client portal (SaaS platform)
- WEEE / data destruction service platform
- Cybersecurity tooling and red team automation
- B2B IT consultancy hub and SharePoint resource platform

---

## Sprint Workflow

Follow this order for all feature work:

1. `/office-hours` — start here, reframe the problem
2. `/plan-ceo-review` — 10-section product review
3. `/plan-eng-review` — architecture, diagrams, edge cases
4. Build
5. `/review` — staff engineer code review
6. `/qa` — real browser QA
7. `/cso` — security audit (for any client-facing or data-handling work)
8. `/ship` — sync, test, push, PR
9. `/document-release` — keep docs current
10. `/retro` — weekly reflection

---

## Agent Roles (Paperclip Integration)

| Paperclip Agent | gstack Skill Mapping |
|---|---|
| CEO | `/office-hours`, `/plan-ceo-review`, `/autoplan` |
| CTO | `/plan-eng-review`, `/review`, `/investigate`, `/ship` |
| CSO | `/cso`, `/careful`, `/guard` |
| QA Lead | `/qa`, `/qa-only`, `/canary`, `/benchmark` |
| Designer | `/design-consultation`, `/design-shotgun`, `/design-html`, `/design-review` |
| Release Eng | `/ship`, `/land-and-deploy`, `/document-release` |

---

## Security Notes

- Always run `/cso` before shipping any client-facing feature
- Use `/careful` and `/guard` when working on production data or destructive ops
- Cybersecurity work: align with ISO 27001, GDPR, NIST frameworks
- WEEE/data destruction: treat all data as sensitive until certified destroyed

---

## Paperclip Integration

Paperclip runs at `http://localhost:3100` (or via Tailscale for mobile).

When Paperclip assigns a ticket to you:
1. Read the goal ancestry from the ticket context
2. Use the appropriate gstack skills for the task type
3. Report back with ticket updates when work is complete
4. Flag blockers or budget concerns to management tier
