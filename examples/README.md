# Architecture Presets

Choose the preset that matches your project structure. Each example shows what `setup.sh` produces for that architecture — you can also browse the files manually to understand what sessions get created.

## Presets

| Preset | Sessions created | Use when |
|--------|-----------------|----------|
| [web-only](web-only/) | planning, web, qa | Frontend app with no separate API (e.g. SvelteKit + serverless, Next.js with API routes) |
| [api-web](api-web/) | planning, backend, web, qa | Separate API server + web frontend (most SaaS products) |
| [api-mobile](api-mobile/) | planning, backend, ios, android, qa | API + native mobile app(s) — drop android if iOS-only |
| [full-stack](full-stack/) | planning, backend, web, ios, android, qa | API + web companion + native mobile (e.g. Ashenmarch) |

## Custom

If none of the presets fit, run `setup.sh` and choose **Custom** — you'll be prompted to select individual sessions. Available sessions: `backend`, `web`, `ios`, `android`, `cli`.

## Monorepo note

If your project lives in a single repo (no separate code repos), use **web-only** or **api-web** and collapse the hub repo and code repo into one. The session files still work — just adjust the path references in CLAUDE.md.
