# Preset: Full Stack (API + Web + iOS + Android)

**Use when:** Your product has a backend API, a web companion, and native mobile apps across both platforms. This is the most complex preset — use a simpler one if you don't need all four code sessions.

This preset mirrors the Ashenmarch project structure.

## What setup.sh creates

```
my-project-hub/
├── CLAUDE.md
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md
│   │   ├── backend-session.md
│   │   ├── web-session.md
│   │   ├── ios-session.md
│   │   ├── android-session.md
│   │   ├── qa-session.md
│   │   └── archive/
│   ├── epics/
│   └── tests/
```

**Code repo CLAUDE.md files:** one dropped into each of the four code repos.

## Session map

| Session | Who | Repo |
|---------|-----|------|
| Planning | PM (`bmad-agent-pm`) | hub repo |
| Backend | Dev (`bmad-agent-dev`) | api repo |
| Web | Dev (`bmad-agent-dev`) | web repo |
| iOS | Dev (`bmad-agent-dev`) | ios repo |
| Android | Dev (`bmad-agent-dev`) | android repo |
| QA | QA (`bmad-qa`) | cross-repo |

## Dependency pattern

Backend API is the contract owner — web and mobile consume it. Typical sequencing:

1. Backend story ships and is QA-verified
2. Web story implements against live endpoint
3. iOS story implements against live endpoint
4. Android story follows iOS (reuses validated design + API contract)

Web and iOS can often run in parallel once the backend endpoint is live.

## Example projects

- Consumer apps with a web dashboard (fitness, productivity, games)
- B2C SaaS with native mobile clients
