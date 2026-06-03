---
name: pm-decision
description: Lock a design or product decision. Records in the planning session decisions log, saves to persistent memory if available, and commits. Use when the user says "lock this", "that's decided", "record this decision", or makes a definitive product/design choice.
---

# PM Decision Logging

## Overview

Records a locked decision so it survives across sessions and cannot be re-litigated without an explicit revisit. Writes to the planning session (visible to all sessions) and to persistent memory if the BMad memory system is installed.

## Conventions

- `{project-root}` = current working directory (hub repo root)
- Planning session: `{project-root}/docs/sessions/planning-session.md`
- BMad memory (if installed): `{project-root}/_bmad/` indicates BMad is present; look for memory files in the standard memory location

## Workflow

<workflow>

<step n="1" goal="Confirm the decision">
A good decision record has three parts:
- **What** — the specific choice made
- **Why** — the rationale (including what was rejected and why)
- **How to apply** — what future sessions must respect

If any of these are unclear, ask one focused question before proceeding.
</step>

<step n="2" goal="Record in planning session">
Read `{project-root}/docs/sessions/planning-session.md`.

Add a row to the most recent `## 🏁 PM Decisions` section (create one with today's date if none exists for today):

```markdown
| **{Decision name}** | ✅ {What was decided} — {one-line rationale} |
```
</step>

<step n="3" goal="Save to persistent memory (if available)">
If `{project-root}/_bmad/` exists (BMad is installed), append the decision to the appropriate memory file following BMad memory conventions.

Format:
> **{Decision name}:** {what}. Rationale: {why}. Decided: {YYYY-MM-DD}.

If BMad memory is not installed, note that the decision is recorded only in the planning session — a future `/bmad-setup-hub` or manual memory file can capture it.
</step>

<step n="4" goal="Commit and push">
Stage both modified files. Commit:

```
decision: {decision-name-in-kebab-case}

What: {one sentence}
Why: {one sentence}
```

Push and report the commit hash.
</step>

</workflow>
