# BMad Hub Template

A starting point for BMad method project hubs. Generates the right session files for your architecture via a setup script or a Claude skill.

## What is a hub repo?

The hub is a single planning repo that owns all docs, epics, stories, and session work queues. Code repos (backend, web, iOS, etc.) are separate — they each get a `CLAUDE.md` that points back to the hub's session file.

## Quickstart

### Option A — BMad skill (recommended)

Open Claude Code (or any Claude interface with BMad installed) and run:

```
/bmad-setup-hub
```

Claude asks for your project name, architecture preset, and repo names. The skill detects your environment automatically:

- **Claude Code** — writes files directly to disk and inits git
- **Other interfaces** (claude.ai, API, etc.) — outputs all file contents as formatted code blocks to copy, plus the shell commands to run

The skill is in `.claude/skills/bmad-setup-hub/`. Install it by copying that directory into your Claude Code skills folder, or via the BMad installer.

### Option B — Script (no Claude required)

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

Both scripts ask the same questions and produce identical output to the skill.

## Skill compatibility

`bmad-setup-hub` is environment-aware — it detects whether file system tools are available and adapts:

| Environment | Skill behaviour |
|-------------|----------------|
| Claude Code | Writes files to disk, inits git |
| claude.ai / API / other | Outputs file contents as copy-paste blocks + shell commands |

The shell scripts (`setup.sh` / `setup.ps1`) are an alternative if you prefer not to use the skill at all.

## Architecture presets

| # | Preset | Sessions | Use when |
|---|--------|----------|----------|
| 1 | `web-only` | planning, web, qa | Frontend + serverless / third-party backend |
| 2 | `api-web` | planning, backend, web, qa | Separate API + web frontend (most SaaS) |
| 3 | `api-mobile` | planning, backend, ios, android, qa | API + native mobile (both platforms) |
| 4 | `api-ios` | planning, backend, ios, qa | API + iOS only |
| 5 | `full-stack` | planning, backend, web, ios, android, qa | API + web companion + native mobile |
| 6 | `ios-only` | planning, ios, qa | iOS app with third-party backend (Firebase, Supabase, etc.) |
| 7 | `android-only` | planning, android, qa | Android app with third-party backend |
| 8 | `mobile-only` | planning, ios, android, qa | iOS + Android with third-party backend |
| 9 | `custom` | you choose | Any other combination |

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

### 1. Install BMad

BMad is the AI-native development framework that powers the personas, skills, and workflows referenced in every session file. The hub setup creates the session structure — BMad provides the intelligence layer on top.

**Install:** follow the instructions at [bmad-code.github.io](https://bmad-code.github.io) (or your team's internal BMad distribution). Run the installer inside the hub directory — it populates `_bmad/` with scripts, skills, and config.

> Install BMad **before** opening your first planning session. The PM persona (`bmad-agent-pm`) and all `/bmad-*` skills come from BMad, not from this template.

### 2. Copy code repo CLAUDE.md files

Drop each file from `_code-repo-claudes/` into the root of its code repo as `CLAUDE.md`. Claude Code reads this automatically on startup — no kickoff copy-paste needed.

### 3. Update production URLs

Fill in real service URLs in `docs/sessions/qa-session.md`. The generated file has `https://api.example.com` placeholders.

### 4. Push to GitHub

Push the hub repo. If you want this hub to be reusable as a GitHub template for future projects, enable **"Template repository"** in the repo's Settings page.

### 5. Start planning

Open Claude Code in the hub directory and invoke `bmad-agent-pm` to begin your first planning session.

**Not sure what to do next?** Type `/bmad-help` at any point — it reads the current project state and recommends the right next skill or action. Use it when you're starting fresh, returning after a break, or unsure which BMad skill applies to your current task.
