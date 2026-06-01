---
session: cli
repo: "{{CLI_REPO}}"
persona: bmad-agent-dev
last_story: ""
last_updated: "{{DATE}}"
---

# CLI Session — Work Queue

> **Start every session by reading this file.** PM session maintains it.
> See also: `../{{CLI_REPO}}/CLAUDE.md` for stack + workflow reference.

## 🔴 Top Priority

_No active stories — PM will populate this._

## 🟡 Ready (unblocked)

## ⏳ Blocked

| Story | Blocked on |
|-------|-----------|

## Persona & Skills

**Persona:** `bmad-agent-dev`

**Story workflow:**
1. Read spec in `docs/epics/e{N}-*.md`
2. `/bmad-dev-story` with the story file path
3. `{{LINT_TEST_CMD}}` ← update for your stack
4. Add QA test cases to `docs/tests/e{N}-*.md`
5. Add ready-to-test entry to `docs/sessions/qa-session.md`
6. Push

## ❓ Questions for PM

None currently open.
