# BMad Hub Template

A starting point for BMad method project hubs. Generates the right session files for your architecture via a setup script or a Claude skill.

## What is a hub repo?

The hub is a single planning repo that owns all docs, epics, stories, and session work queues. Code repos (backend, web, iOS, etc.) are separate — they each get a `CLAUDE.md` that points back to the hub's session file.

## Quickstart

### Option A — Script (no Claude required)

Clone the repo, then run the script for your platform:

**macOS / Linux**
```bash
git clone <this-repo>
cd bmad-hub-template
./setup.sh
```

**Windows (PowerShell)**
```powershell
git clone <this-repo>
cd bmad-hub-template
.\setup.ps1
```

> If PowerShell blocks the script, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once, then retry.

Both scripts ask the same questions: project name, architecture preset, and repo names — then generate a ready-to-use hub directory and `CLAUDE.md` files for each code repo.

### Option B — Claude skill (recommended)

If you have the BMad skill suite installed, invoke it from within Claude Code:

```
/bmad-setup-hub
```

The skill runs the same setup flow interactively inside Claude — no terminal needed.

## Architecture presets

| Preset | Sessions | Use when |
|--------|----------|----------|
| `web-only` | planning, web, qa | Frontend + serverless / third-party backend |
| `api-web` | planning, backend, web, qa | Separate API + web frontend (most SaaS) |
| `api-mobile` | planning, backend, ios, [android], qa | API + native mobile app(s) |
| `full-stack` | planning, backend, web, ios, android, qa | API + web companion + native mobile |
| `custom` | you choose | Any other combination |

See [examples/](examples/) for sample session files for each preset.

## What gets generated

```
my-project-hub/
├── CLAUDE.md                        ← auto-loaded by Claude Code; PM session context
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md      ← always created
│   │   ├── qa-session.md            ← always created
│   │   ├── backend-session.md       ← if backend selected
│   │   ├── web-session.md           ← if web selected
│   │   ├── ios-session.md           ← if ios selected
│   │   ├── android-session.md       ← if android selected
│   │   └── archive/                 ← completed sprint logs go here
│   ├── epics/                       ← full story specs
│   └── tests/                       ← QA test cases
└── _code-repo-claudes/              ← CLAUDE.md file for each code repo
    └── my-project-api-CLAUDE.md     ← copy to my-project-api/CLAUDE.md
```

## Templates

Raw template files live in [templates/](templates/). Each uses `{{PLACEHOLDER}}` tokens. Substituted automatically by `setup.sh` — or edit manually if you prefer.

| Placeholder | Description |
|-------------|-------------|
| `{{PROJECT_NAME}}` | e.g. "Ashenmarch" |
| `{{PROJECT_DESCRIPTION}}` | One-line description |
| `{{HUB_REPO}}` | Hub repo name |
| `{{BACKEND_REPO}}` | Backend repo name |
| `{{WEB_REPO}}` | Web repo name |
| `{{IOS_REPO}}` | iOS repo name |
| `{{ANDROID_REPO}}` | Android repo name |
| `{{ADMIN_EMAIL}}` | QA test admin account |
| `{{DATE}}` | Populated with today's date |

## After setup

1. **Install BMad** — run the BMad installer in the hub directory to populate `_bmad/`
2. **Copy `_code-repo-claudes/` files** — drop each generated `CLAUDE.md` into its code repo root
3. **Update production URLs** — fill in real URLs in `docs/sessions/qa-session.md`
4. **Push to GitHub** — enable "Template repository" in settings if you want a reusable template
5. **Start planning** — open Claude Code in the hub repo, invoke `bmad-agent-pm`
