# Preset: Web Only

**Use when:** Your project is a single frontend application with no separate backend repo — e.g. SvelteKit with serverless functions, Next.js with API routes, or a static site with a third-party backend (Supabase, Firebase, etc.).

## What setup.sh creates

```
my-project-hub/
├── CLAUDE.md
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md
│   │   ├── web-session.md
│   │   ├── qa-session.md
│   │   └── archive/
│   ├── epics/
│   └── tests/
```

**Code repo CLAUDE.md:** one file dropped into `my-project-web/CLAUDE.md`.

## Session map

| Session | Who | Repo |
|---------|-----|------|
| Planning | PM (`bmad-agent-pm`) | hub repo |
| Web | Dev (`bmad-agent-dev`) | web repo |
| QA | QA (`bmad-qa`) | cross-repo |

## Example projects

- Marketing site + CMS
- SaaS dashboard (Next.js + Supabase)
- Documentation site with search
