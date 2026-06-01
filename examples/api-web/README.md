# Preset: API + Web

**Use when:** You have a separate backend API server and a web frontend in different repos — the most common SaaS architecture.

## What setup.sh creates

```
my-project-hub/
├── CLAUDE.md
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md
│   │   ├── backend-session.md
│   │   ├── web-session.md
│   │   ├── qa-session.md
│   │   └── archive/
│   ├── epics/
│   └── tests/
```

**Code repo CLAUDE.md files:** dropped into `my-project-api/CLAUDE.md` and `my-project-web/CLAUDE.md`.

## Session map

| Session | Who | Repo |
|---------|-----|------|
| Planning | PM (`bmad-agent-pm`) | hub repo |
| Backend | Dev (`bmad-agent-dev`) | api repo |
| Web | Dev (`bmad-agent-dev`) | web repo |
| QA | QA (`bmad-qa`) | cross-repo |

## Example projects

- SaaS app (Go/Rails/Django API + React/SvelteKit frontend)
- Internal tooling with a REST or GraphQL API
- B2B dashboard product
