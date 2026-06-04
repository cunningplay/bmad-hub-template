---
name: qa-bug
description: File a bug found during testing. Creates a properly formatted bug entry in the backlog with the correct bug-NNN ID, steps to reproduce, expected vs actual, and AC reference. No user input required beyond the bug description. Use when the user says "file a bug", "log this bug", or a test case fails.
---

# QA Bug — File a Bug

## Overview

Creates a properly formatted bug entry for the portal backlog. Determines the next bug-NNN number automatically, formats the report, and records it. Fully autonomous once the bug details are provided.

## Conventions

- `{project-root}` = hub repo root
- QA session: `{project-root}/docs/sessions/qa-session.md`

## Workflow

<workflow>

<step n="1" goal="Gather bug details">
If not already clear from context, determine:
- **Story/feature** — which story or feature has the bug
- **Steps to reproduce** — exact steps that trigger the issue
- **Expected result** — what should happen per the AC
- **Actual result** — what actually happened (include exact response, copy, or error)
- **AC reference** — the specific `Given/When/Then` that fails (e.g. "Story 6.17 AC3")
- **Severity** — high / medium / low
- **Owning repo** — which repo owns the fix (backend / web / ios / android)

All of this can usually be derived from the test execution context without asking the user.
</step>

<step n="2" goal="Determine next bug number">
Read `{project-root}/docs/sessions/qa-session.md` and scan all existing bug references (🐛 BUG-NNN) to find the highest number used. Increment by 1 for the new bug ID.
</step>

<step n="3" goal="Format the bug report">
Format as:

```
🐛 BUG-{NNN}: {short title}
Repo: {owning repo}
Priority: {high|medium|low}
Story: X.Y — {story title}
AC: {AC reference that fails}

Steps to reproduce:
1. {step}
2. {step}

Expected: {what should happen}
Actual: {what happened}

Notes: {any additional context, URL, screenshot reference}
```
</step>

<step n="4" goal="Record in qa-session and commit">
Add the bug to the qa-session.md Open Bugs section (or create one if it doesn't exist). Use the format established in the existing qa-session.md.

```bash
git add docs/sessions/qa-session.md
git commit -m "bug: file BUG-{NNN} — {short title}"
git push
```

Report: "BUG-{NNN} filed. Add to portal `/work-items/backlog` when convenient (repo: {owning repo}, priority: {priority})."
</step>

</workflow>
