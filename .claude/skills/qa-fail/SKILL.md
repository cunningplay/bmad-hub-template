---
name: qa-fail
description: Mark a story as failed QA. Updates qa-session.md to show the failure, references the bug filed, and flags the owning dev session to investigate. No user input required. Use after /qa-bug when a story cannot be verified due to a bug.
---

# QA Fail — Mark Story Failed

## Overview

Marks a story as failed in the QA queue, links the bug(s) filed, and returns the story to the relevant dev session's attention. Commits and pushes. Fully autonomous.

## Conventions

- `{project-root}` = hub repo root
- QA session: `{project-root}/docs/sessions/qa-session.md`
- Dev session: `{project-root}/docs/sessions/{owning-session}-session.md`

## Workflow

<workflow>

<step n="1" goal="Confirm bug has been filed">
Verify `/qa-bug` was run and a BUG-NNN exists for this failure. If not, invoke `/qa-bug` first.
</step>

<step n="2" goal="Update qa-session.md">
Read `{project-root}/docs/sessions/qa-session.md`.

Update the story row in the ready-to-test table:
```
| Story X.Y — {title} | test file | ❌ FAILED {date} — BUG-{NNN}: {bug title}. Blocked pending fix. |
```

The story stays in the ready-to-test table — it will be re-tested once the bug is fixed.
</step>

<step n="3" goal="Flag to dev session">
Read `{project-root}/docs/sessions/{owning-session}-session.md`.

Add an entry to the Open Bugs section (or create one):
```markdown
- **BUG-{NNN}** ({priority}) — {short title}. Blocks QA re-test of story X.Y. See qa-session.md for full report.
```
</step>

<step n="4" goal="Commit and push">
Stage all modified session files:
```bash
git add docs/sessions/qa-session.md docs/sessions/{session}-session.md
git commit -m "qa: story X.Y FAILED — BUG-{NNN} filed, returned to {session} queue"
git push
```

Report: "Story X.Y marked failed. BUG-{NNN} logged in {owning-session} session. QA will re-test once the fix ships."
</step>

</workflow>
