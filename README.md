# {{PROJECT_NAME}} — BMad Hub

Planning hub for {{PROJECT_NAME}}. All docs, epics, stories, and session work queues live here. Code repos are separate.

## Setup

1. **Replace placeholders** — search for `{{` and fill in project-specific values throughout this repo.
2. **Install BMad** — run the BMad installer to populate `_bmad/` and `_bmad-output/`.
3. **Configure sessions** — remove session files for platforms you're not building (e.g. delete `android-session.md` for iOS-only projects).
4. **Add CLAUDE.md to each code repo** — use the kickoff block in each session file as the starting point.

## Placeholder reference

| Placeholder | Example |
|-------------|---------|
| `{{PROJECT_NAME}}` | Ashenmarch |
| `{{PROJECT_DESCRIPTION}}` | GPS territory game for iOS |
| `{{HUB_REPO}}` | CunningPlay_Run |
| `{{BACKEND_REPO}}` | cunningplay-run-backend |
| `{{WEB_REPO}}` | cunningplay-run-web |
| `{{IOS_REPO}}` | cunningplay-run-ios |
| `{{ANDROID_REPO}}` | cunningplay-run-android |
| `{{PORTAL_URL}}` | https://ashenmarch.com/portal |
| `{{LIVE_API_URL}}` | https://api.ashenmarch.com |
| `{{LIVE_WEB_URL}}` | https://ashenmarch.com |

## Structure

```
docs/
  sessions/       ← work queues, one per Claude Code session
    archive/      ← completed sprint logs and audits
  epics/          ← full story specs
  tests/          ← QA test cases per epic
CLAUDE.md         ← auto-loaded by Claude Code on startup
```

## How sessions work

Each session file answers: **"What should I do right now?"**

- **PM session** (`planning-session.md`) — owns all other session files; only PM updates them
- **Code sessions** — read their session file, implement top priority using `/bmad-dev-story`, push
- **QA session** — tests completed features against production URLs; files bugs to backlog

Sessions signal changes via the backlog — PM reflects them in the session files.
