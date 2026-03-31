# ITD5 Agentic Stack — Sprint Workflow

## Weekly Sprint Cycle

### Monday — Sprint Planning
1. **CEO Agent** reviews Q2 2026 goals (`companies/itd5/goals/q2-2026.md`)
2. CEO Agent creates Paperclip tickets for the week
3. Tickets assigned to CTO, CSO, or QA agents
4. gstack sprint initialized with weekly goals

### Tuesday–Thursday — Execution
- **CTO Agent** runs gstack coding sessions
  - Target: ship production-ready code
  - Commit frequently with descriptive messages
  - All code goes through PR before merge
- **CSO Agent** reviews any new features for security
  - OWASP checklist on client-facing endpoints
  - GDPR check on any data handling
- **QA Agent** tests completed tickets in Paperclip
  - Resolve 20+ tickets per week
  - Log bugs back to CTO Agent via Paperclip

### Friday — Retro & Review
1. All agents submit weekly KPI report
2. **CEO Agent** runs `retro` in gstack
3. Budget reviewed (monthly, first Friday)
4. Goals doc updated with progress
5. Next sprint priorities set

---

## Paperclip Ticket Flow

```
Backlog → In Progress → In Review → Done
   ↑                          │
   └────── Bug Found ──────┘
```

- **Backlog**: CEO Agent creates tickets from goals
- **In Progress**: CTO/CSO/QA Agent picks up
- **In Review**: QA Agent reviews
- **Done**: QA Agent closes after passing tests

---

## gstack Sprint Commands

```bash
# Start a new sprint
gstack sprint start --name "week-XX" --goal "[goal description]"

# Run coding session
gstack run --agent cto --prompt "[task]"

# Run retro
gstack retro

# Check sprint status
gstack status
```

---

## Monthly Budget Review (First Friday)

| Category | Monthly Budget |
|----------|---------------|
| Claude API (agents) | €300 |
| Infrastructure (AWS) | €100 |
| Tools & subscriptions | €50 |
| Buffer | €50 |
| **Total** | **€500** |

CEO Agent tracks spend and alerts if >80% budget used by week 3.

---

## Onboarding a New Company

1. Copy `companies/itd5/` as template
2. Update `company.json` with new company details
3. Update agent configs in `agents/`
4. Create quarterly goals in `goals/`
5. Run `scripts/bootstrap.sh` for new company
6. Create Paperclip project for new company
7. Initialize gstack sprint

---

## Using Paperclip for Free (Self-Hosted)

1. Clone: `git clone https://github.com/paperclipai/paperclip`
2. Configure `.env` (see `.env.example`)
3. Run: `docker-compose up -d`
4. Access at `http://localhost:3000`
5. Create projects for each agent: `itd5-ceo`, `itd5-cto`, `itd5-cso`, `itd5-qa`
6. Agents interact via Paperclip API using `PAPERCLIP_API_KEY`

This keeps all project data on your own infrastructure — no SaaS fees.
