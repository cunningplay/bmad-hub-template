# {{PROJECT_NAME}} — {{SESSION_TITLE}} Session

**Session file:** `{{PATH_TO_HUB}}/docs/sessions/{{SESSION_KEY}}-session.md` — read this first.

## Quick context

- **Project:** {{PROJECT_NAME}}
- **Repo role:** {{REPO_ROLE}}
- **Persona:** `{{PERSONA}}`
- **Stack:** {{STACK}}

## Kickoff

Paste this to start a {{SESSION_TITLE}} session:

> You are the {{SESSION_KEY}} session for {{PROJECT_NAME}}. Use the `{{PERSONA}}` persona. Read `{{PATH_TO_HUB}}/docs/sessions/{{SESSION_KEY}}-session.md` first, then implement the top priority story using `/bmad-dev-story`.

## Story workflow

1. Read spec in `{{PATH_TO_HUB}}/docs/epics/e{N}-*.md`
2. Invoke `/bmad-dev-story` with the story file path
3. {{LINT_AND_TEST_COMMAND}}
4. Add QA test cases to `{{PATH_TO_HUB}}/docs/tests/e{N}-*.md`
5. Add a ready-to-test entry to `{{PATH_TO_HUB}}/docs/sessions/qa-session.md`
6. Push

## Key constraints

{{KEY_CONSTRAINTS}}
