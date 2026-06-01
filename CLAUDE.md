# {{PROJECT_NAME}} — Planning Session

**Session file:** `docs/sessions/planning-session.md` — read this first.

## Quick context

- **Project:** {{PROJECT_NAME}} — {{PROJECT_DESCRIPTION}}
- **Repo role:** Planning hub — all docs, epics, stories, architecture, and session files live here
- **Persona:** `bmad-agent-pm`
- **Portal:** {{PORTAL_URL}} (if applicable)

## Kickoff

Paste this to start a planning session:

> You are the planning (PM) session for {{PROJECT_NAME}}. Use `bmad-agent-pm`. Read `docs/sessions/planning-session.md` first.

## Session map

| Session | File | Repo |
|---------|------|------|
| Planning (this) | `docs/sessions/planning-session.md` | `{{HUB_REPO}}` |
| Backend | `docs/sessions/backend-session.md` | `{{BACKEND_REPO}}` |
| Web | `docs/sessions/web-session.md` | `{{WEB_REPO}}` |
| iOS | `docs/sessions/ios-session.md` | `{{IOS_REPO}}` |
| Android | `docs/sessions/android-session.md` | `{{ANDROID_REPO}}` |
| QA | `docs/sessions/qa-session.md` | cross-repo |

> Remove rows for sessions that don't apply to this project.

## PM responsibilities

- Maintain all `docs/sessions/*.md` work queues — only PM updates these
- Triage backlog for cross-session questions
- Ensure every completed story has QA test cases in `docs/tests/`
- Update `plan/index.html` (if applicable) as epics and milestones progress

## Key artifacts

| Artifact | Path |
|----------|------|
| Architecture | `docs/architecture/` |
| Epics | `docs/epics/` |
| Tests | `docs/tests/` |
| UX spec | `_bmad-output/planning-artifacts/ux-design-specification.md` |
