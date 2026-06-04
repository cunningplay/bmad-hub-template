---
name: dev-qa-done
description: Add a completed story to QA's ready-to-test queue. Updates qa-session.md with what to verify, commits, and pushes. No user input required. Use after a story is merged and deployed, or when the user says "notify QA", "ready for QA", "tell QA story X is done".
---

# Dev QA Done — Notify QA Story is Ready

## Overview

Adds a ready-to-test entry to the QA session file so QA knows what to verify and where the test cases are. Commits and pushes automatically. Fully autonomous.

## Conventions

- `{hub-root}` = hub repo path (from CLAUDE.md)
- QA session: `{hub-root}/docs/sessions/qa-session.md`
- Tests: `{hub-root}/docs/tests/`

## Workflow

<workflow>

<step n="1" goal="Gather story details">
If not already clear from context, determine:
- Story number (e.g. `6.17`)
- Story title
- Test file path (check if `{hub-root}/docs/tests/e{N}-*.md` exists)
- Key things QA should verify (1–3 bullet points from the story ACs)
- Any production URL or endpoint to test against
- Any known limitations or simulator-only caveats

All of this can be read from the story spec in the epic file — no user input needed.
</step>

<step n="2" goal="Update QA session">
Read `{hub-root}/docs/sessions/qa-session.md`.

Find the 🔴 Sprint section (or "Ready to Test Now" table) and add a row:

```markdown
| Story X.Y — {title} | `docs/tests/e{N}-*.md` | {key ACs to verify; note any simulator-only or prod-only caveats} |
```

If no test file exists yet, note: `(test file TBD — write test cases before testing)`.

Also add to the "Ready to test as stories land" table if the story is in a Wave B/C context.
</step>

<step n="3" goal="Commit and push">
In `{hub-root}`:
```bash
git add docs/sessions/qa-session.md
git commit -m "qa: story X.Y ready to test — {title}"
git push
```

Report the commit hash and confirm: "QA notified. Story X.Y is in their ready-to-test queue."
</step>

</workflow>
