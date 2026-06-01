---
session: backend
repo: "{{BACKEND_REPO}}"
persona: bmad-agent-dev
last_story: ""
last_updated: ""
---

# Backend Session — Work Queue

> **Start every session by reading this file.** PM session maintains it.
> See also: `../{{BACKEND_REPO}}/CLAUDE.md` for stack + workflow reference.

## 🔴 Top Priority

<!-- PM fills this in. Format:
| Story | What |
|-------|------|
| **X.Y** | Description |
-->

_No active stories — check with PM._

## 🟡 Ready (unblocked)

<!-- Stories ready to pick up, in order. -->

## ⏳ Blocked

| Story | Blocked on |
|-------|-----------|
| | |

## Persona & Skills

**Persona:** `bmad-agent-dev` — backend developer

**Story workflow:**
1. Read spec in `docs/epics/e{N}-*.md`
2. `/bmad-dev-story` with the story file path
3. Run lint + tests (project-specific — update this line)
4. Add QA test cases to `docs/tests/e{N}-*.md`
5. Add ready-to-test entry to `docs/sessions/qa-session.md`
6. Push

## ❓ Questions for PM

None currently open.
