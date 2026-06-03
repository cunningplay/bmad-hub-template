---
name: pm-sync
description: Sync session files after a story ships or priorities change. Updates the relevant session's sprint queue, marks completed work, adjusts ordering, and commits. Use when the user says "story X is done", "update the sessions", "mark X complete", or after a sprint wraps.
---

# PM Session Sync

## Overview

Keeps session files current after work completes or priorities shift. The PM owns all session files — this skill handles the mechanical update so each session starts with accurate information.

## Conventions

- `{project-root}` = current working directory (hub repo root)
- Session files: `{project-root}/docs/sessions/{session}-session.md`

## Workflow

<workflow>

<step n="1" goal="Understand what changed">
Ask (or extract from context):
1. **What shipped?** — story number(s), commit hash if known
2. **Which session(s)?** — which code sessions are affected
3. **What's next?** — does a blocked story now unlock, or is there a new blocker?
4. **Any new PM questions raised?** — from sessions needing a recorded answer
5. **QA notification needed?** — should the story be added to the QA session as ready-to-test?
</step>

<step n="2" goal="Read affected session files">
Read only the sessions that need updating. Avoid reading all sessions unless a cross-cutting change affects multiple queues.
</step>

<step n="3" goal="Update session files">
For each affected session:

- **Mark completed stories** — add to ✅ Completed section or mark with ✅ in place
- **Update `last_story`** frontmatter to the most recently shipped story number
- **Update `last_updated`** frontmatter to today's date
- **Promote next story** — if a blocked story is now unblocked, move it to the top of the sprint
- **Record PM answers** — if the session raised a question, add it to the ✅ PM Answers table
- **Add to QA queue** — if the story needs QA, add a ready-to-test entry to the QA session

Keep session files action-first — the current top story should be line 1 of the sprint section.
</step>

<step n="4" goal="Commit and push">
Stage all modified session files. Commit:

```
sessions: sync after {story X} ships — {session name}

{What completed} → {what's next}
```

Push and report the commit hash. If multiple sessions were updated, list each in the commit body.
</step>

</workflow>

## Rules

- **Never remove history** — move completed items to ✅ Completed, never delete
- **Sprint order is the contract** — the top item in a sprint is what the session works on next
- **Blockers must name the dependency** — not just "blocked" — say blocked on what
- **Only PM updates session files** — code sessions flag changes via the backlog; PM reflects them here
