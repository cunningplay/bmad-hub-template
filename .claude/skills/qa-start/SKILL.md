---
name: qa-start
description: Pick up the next story from the QA ready-to-test queue. Reads qa-session.md, loads the test file and story ACs, and begins verification against production URLs. No user input required. Use when the user says "start QA", "test next story", or "what's ready to test".
---

# QA Start — Pick Up Next Story to Test

## Overview

Reads the QA session's ready-to-test queue, loads the test file and story ACs, and begins systematic verification against production URLs. Fully autonomous.

## Conventions

- `{project-root}` = hub repo root (QA runs from the hub)
- QA session: `{project-root}/docs/sessions/qa-session.md`
- Tests: `{project-root}/docs/tests/`
- Epics: `{project-root}/docs/epics/`

**Always test against production URLs — never localhost.**

## Workflow

<workflow>

<step n="1" goal="Read the ready-to-test queue">
Read `{project-root}/docs/sessions/qa-session.md`.

Find the first item in the 🔴 "Ready to Test Now" table that is NOT marked ✅ verified and NOT marked ⚠️ blocked.

If everything is blocked or verified, report the state and stop.
</step>

<step n="2" goal="Load test spec and ACs">
From the story number, load in parallel:
1. The test file: `{project-root}/docs/tests/e{N}-*.md` — specific test cases if it exists
2. The story ACs: `{project-root}/docs/epics/e{N}-*.md` — the `### Story X.Y` section

If no test file exists yet, work directly from the story ACs — each `Given/When/Then` block becomes a test case.

List all test cases before beginning. Do not start testing until the full list is visible.
</step>

<step n="3" goal="Execute tests against production">
For each test case:
- Execute against the production URL (read from qa-session.md credentials section)
- Record: ✅ Pass / ❌ Fail / ⚠️ Blocked (with reason)
- Note the exact response, copy, or behaviour observed

Use the test credentials from qa-session.md. Do not use localhost. Do not use staging unless explicitly noted.
</step>

<step n="4" goal="Report results">
Produce a results table:

| Case | Description | Result | Notes |
|------|-------------|--------|-------|
| T1 | ... | ✅ Pass | |
| T2 | ... | ❌ Fail | Expected X, got Y |

Then invoke `/qa-pass` if all cases pass, or `/qa-bug` + `/qa-fail` for each failure.
</step>

</workflow>
