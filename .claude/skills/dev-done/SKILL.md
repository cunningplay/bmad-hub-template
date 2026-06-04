---
name: dev-done
description: Mark the current story complete. Updates epic frontmatter, session file, adds QA ready-to-test entry, commits hub changes, and pushes. No user input required. Use when a story is fully implemented and passing lint/tests.
---

# Dev Done — Mark Story Complete

## Overview

After a story ships, this skill handles all the bookkeeping: marks the story done in the epic, updates the session queue, notifies QA, and commits everything to the hub repo. Fully autonomous.

## Conventions

- `{project-root}` = current code repo root
- `{hub-root}` = hub repo path (from CLAUDE.md)
- Session file: `{hub-root}/docs/sessions/{session}-session.md`
- Epic: `{hub-root}/docs/epics/e{N}-*.md`
- QA session: `{hub-root}/docs/sessions/qa-session.md`

## Workflow

<workflow>

<step n="1" goal="Confirm story is ready">
Ask (one question only, if not already clear): "Which story number is complete?" — e.g. `6.17`.

If the user already stated the story number, skip this step.

Verify the code is committed and pushed in the current repo before proceeding. Run:
```bash
git status
git log --oneline -1
```
If there are uncommitted changes, stop and ask the user to commit first.
</step>

<step n="2" goal="Update epic frontmatter">
Read the epic file: `{hub-root}/docs/epics/e{N}-*.md`.

In the frontmatter, find the story entry and update:
```yaml
  - num: "X.Y"
    status: done
    commit: "https://github.com/{org}/{repo}/commit/{SHA}"
```

Get the commit SHA from `git log --oneline -1` in the current code repo.
Increment `progress` by 1.

Write the updated epic file.
</step>

<step n="3" goal="Update session file">
Read `{hub-root}/docs/sessions/{session}-session.md`.

Remove or strike through the story from the active sprint list. If there is a "✅ Completed" section, add the story there with a one-line note.

Update `last_story` in the frontmatter to this story number.
Update `last_updated` to today's date.
</step>

<step n="4" goal="Add QA ready-to-test entry">
Read `{hub-root}/docs/sessions/qa-session.md`.

Add a row to the "Ready to Test" table:
```markdown
| Story X.Y — {title} | `docs/tests/e{N}-*.md` | {one-line summary of what to verify} |
```

If no test file exists yet, note "test file TBD".
</step>

<step n="5" goal="Commit and push hub changes">
In `{hub-root}`:
```bash
git add docs/epics/e{N}-*.md docs/sessions/{session}-session.md docs/sessions/qa-session.md
git commit -m "done(X.Y): {story title} — {session} session"
git push
```

Report the commit hash and confirm QA has been notified.
</step>

</workflow>
