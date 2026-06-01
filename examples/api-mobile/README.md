# Preset: API + Mobile

**Use when:** You have a backend API and one or more native mobile apps. Drop `android-session.md` if you're building iOS-only.

## What setup.sh creates

```
my-project-hub/
├── CLAUDE.md
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md
│   │   ├── backend-session.md
│   │   ├── ios-session.md
│   │   ├── android-session.md   ← omit if iOS-only
│   │   ├── qa-session.md
│   │   └── archive/
│   ├── epics/
│   └── tests/
```

**Code repo CLAUDE.md files:** one per code repo.

## Session map

| Session | Who | Repo |
|---------|-----|------|
| Planning | PM (`bmad-agent-pm`) | hub repo |
| Backend | Dev (`bmad-agent-dev`) | api repo |
| iOS | Dev (`bmad-agent-dev`) | ios repo |
| Android | Dev (`bmad-agent-dev`) | android repo |
| QA | QA (`bmad-qa`) | cross-repo |

## Sequencing note

Android typically follows iOS — implement and validate on iOS first, then port to Android. Mark Android stories blocked on iOS until the iOS story is QA-verified.

## Example projects

- Fitness / health tracking app
- GPS or location-based app
- Consumer mobile app with a custom backend
