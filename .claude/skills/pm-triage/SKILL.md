---
name: pm-triage
description: Answer open questions from session files and record the PM's response. Use when the user says "answer the question from X session", "triage the questions", or when a session's ❓ Questions for PM section has open items.
---

# PM Triage

## Overview

Sessions surface questions by adding them to their `❓ Questions for PM` section. This skill reads those questions, records the PM's answers back in the session file, and commits. Prevents questions from going unanswered across sessions.

## Conventions

- `{project-root}` = current working directory (hub repo root)
- Session files: `{project-root}/docs/sessions/{session}-session.md`

## Workflow

<workflow>

<step n="1" goal="Find open questions">
If the user specifies a session, read that session file. Otherwise, scan all session files and extract every item from `❓ Questions for PM` sections.

Present open questions as a numbered list:
```
1. [{Session}] {question text}
2. [{Session}] {question text}
```

If there are none, report "No open questions across any session."
</step>

<step n="2" goal="Answer each question">
For each question, either:
- **Answer directly** if the answer follows from existing decisions, epics, or research in the repo
- **Ask the user** if the answer requires product input not yet recorded anywhere

For each answer note:
- The decision or rationale
- Any follow-up stories or backlog items this creates
- Any constraints the session must respect going forward
</step>

<step n="3" goal="Record answers in session files">
For each answered question:

1. Add a `✅ PM Answers ({date})` table to the relevant session file (or append to an existing one):

```markdown
## ✅ PM Answers ({date})

| Q | Answer |
|---|--------|
| {question summary} | {answer} |
```

2. If the answer creates a new story, blocker resolution, or sprint reorder — apply that change to the session file in the same commit.

3. Clear the `❓ Questions for PM` section to "None currently open." once all questions are answered.
</step>

<step n="4" goal="Commit and push">
Stage all modified session files. Commit:

```
pm: answer {N} question(s) from {session(s)}

{Summary of answers and any resulting actions}
```

Push and report the commit hash.
</step>

</workflow>

## What makes a good PM answer

- **Specific** — names the exact choice, not "use the second option"
- **Citable** — references the epic, story, decision log, or research that backs it up
- **Actionable** — tells the session exactly what to do next
- **Complete** — if the answer creates new work, that work is filed before the answer is recorded
