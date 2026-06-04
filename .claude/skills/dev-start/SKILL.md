---
name: dev-start
description: Start the next story from this session's sprint queue. Reads the session file, identifies the top priority story, loads the spec from the hub epics, and begins implementation via /bmad-dev-story. No user input required. Use when the user says "start next story", "pick up next", or "what's next".
---

# Dev Start — Pick Up Next Story

## Overview

Reads this session's work queue, finds the top unstarted story, loads its full spec from the hub repo, and begins implementation. Fully autonomous — no prompts, no access questions.

## Conventions

- `{project-root}` = current code repo root (e.g. cunningplay-run-backend)
- `{hub-root}` = `{project-root}/../` + hub repo name (read from CLAUDE.md)
- Session file: `{hub-root}/docs/sessions/{session}-session.md`
- Epics: `{hub-root}/docs/epics/`

## Workflow

<workflow>

<step n="1" goal="Identify session and hub path">
Read `{project-root}/CLAUDE.md` to determine:
- The session name (backend / web / ios / android)
- The hub repo path (the session file reference in CLAUDE.md)

Derive `{hub-root}` from the session file path in CLAUDE.md.
</step>

<step n="2" goal="Read session queue">
Read `{hub-root}/docs/sessions/{session}-session.md`.

Find the first story in the 🔴 Sprint 1 (or Sprint 0) section that is NOT marked ✅ done, NOT marked blocked, and has no explicit "blocked on" dependency pending. That story is the target.

If all Sprint 1 stories are done or blocked, check Sprint 2 for any unblocked items.

If everything is blocked, report what is blocking each story and stop — do not start a blocked story.
</step>

<step n="3" goal="Load story spec">
From the story number (e.g. `6.17`), find the epic file: `{hub-root}/docs/epics/e{N}-*.md`.

Read the full story spec — the `### Story X.Y` section including all acceptance criteria.

Confirm the story spec is complete before proceeding. If the spec is missing ACs, report it and stop.
</step>

<step n="4" goal="Begin implementation">
Invoke `/bmad-dev-story` with the story file path and the story number.

From this point the dev-story skill drives implementation per the AC checklist.
</step>

</workflow>
