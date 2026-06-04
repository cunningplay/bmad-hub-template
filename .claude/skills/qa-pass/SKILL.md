---
name: qa-pass
description: Mark a story's test cases as verified and passed. Updates qa-session.md, commits, and pushes. No user input required. Use after all test cases for a story have passed.
---

# QA Pass — Mark Story Verified

## Overview

Updates the QA session to mark a story as fully verified, moves it out of the ready-to-test table, and commits. Fully autonomous.

## Conventions

- `{project-root}` = hub repo root
- QA session: `{project-root}/docs/sessions/qa-session.md`
- Tests: `{project-root}/docs/tests/`

## Workflow

<workflow>

<step n="1" goal="Confirm all cases passed">
Confirm the story number and that all test cases have a ✅ Pass result. If any case is ❌ or ⚠️, stop and invoke `/qa-bug` then `/qa-fail` instead.
</step>

<step n="2" goal="Update qa-session.md">
Read `{project-root}/docs/sessions/qa-session.md`.

In the ready-to-test table, update the story row:
- Change status to `✅ VERIFIED {date}` with a brief summary of what was tested
- Keep the row in the table for reference — do not delete it

Update `last_story` in the frontmatter and `last_updated` to today.
</step>

<step n="3" goal="Update test file if needed">
If a test file exists at `{project-root}/docs/tests/e{N}-*.md`, add pass/fail results against each test case ID where not already recorded.
</step>

<step n="4" goal="Commit and push">
```bash
git add docs/sessions/qa-session.md docs/tests/
git commit -m "qa: story X.Y verified ✅ — {title}"
git push
```

Report the commit hash and confirm: "Story X.Y marked verified. Dev session notified via session file."
</step>

</workflow>
