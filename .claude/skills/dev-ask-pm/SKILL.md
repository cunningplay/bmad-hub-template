---
name: dev-ask-pm
description: Surface a question or decision request to the PM session. Appends to this session's ❓ Questions for PM section, commits, and pushes. No user input required beyond the question itself. Use when the user says "ask PM", "flag this for PM", or "PM needs to decide".
---

# Dev Ask PM — Surface Question to PM

## Overview

Appends a question or decision request to the session file's ❓ Questions for PM section and pushes it to the hub repo. The PM session picks it up on their next `/pm-triage` run. Fully autonomous.

## Conventions

- `{hub-root}` = hub repo path (from CLAUDE.md)
- Session file: `{hub-root}/docs/sessions/{session}-session.md`

## Workflow

<workflow>

<step n="1" goal="Get the question">
If the user provided the question in their message, use it directly. Do not ask for clarification.

If unclear, ask one question: "What is the question or decision for PM?"

Format the question clearly:
- **Context:** one sentence on why this is being raised (which story, which AC, what the blocker is)
- **Question:** the specific decision or information needed
- **Options (if applicable):** the choices the PM can pick from
- **Blocking:** what cannot proceed until this is answered
</step>

<step n="2" goal="Append to session file">
Read `{hub-root}/docs/sessions/{session}-session.md`.

Find the `## ❓ Questions for PM` section. If it says "None currently open.", replace it with the question. Otherwise append.

Format:
```markdown
## ❓ Questions for PM

**[Story X.Y / Context]:** [Question text]
- Context: [why this is being raised]
- Blocking: [what can't proceed]
- Options: [A / B / C] (if applicable)
```
</step>

<step n="3" goal="Commit and push">
```bash
git add docs/sessions/{session}-session.md
git commit -m "question(PM): {one-line question summary} — {session} session"
git push
```

Report the commit hash and confirm: "Question queued for PM. Run /pm-triage in the planning session to answer."
</step>

</workflow>
