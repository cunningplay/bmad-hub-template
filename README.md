# BMad Hub Template

A starting point for BMad method project hubs. Generates the right session files for your architecture via a setup script or a Claude skill.

## What is a hub repo?

The hub is a single planning repo that owns all docs, epics, stories, and session work queues. Code repos (backend, web, iOS, etc.) are separate — they each get a `CLAUDE.md` that points back to the hub's session file.

## Quickstart

### Option A — Claude Code skill (recommended)

Open Claude Code in any directory and run:

```
/cc-setup-hub
```

Claude asks for your project name, architecture preset, and repo names, then generates all files directly — no terminal, no platform issues, works identically on Mac, Linux, and Windows.

The skill is in `.claude/skills/cc-setup-hub/`. Install it by copying that directory into your Claude Code skills folder, or via the BMad installer.

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

> **Note:** The skills in this template (`.claude/skills/`) are currently **Claude Code only**. They use Claude Code's Write and Bash tools to generate files directly — they will not work in other Claude interfaces (claude.ai, API, etc.) or other AI coding tools.
>
> BMad itself is platform-agnostic. If you're running BMad in a different environment, use the shell scripts (`setup.sh` / `setup.ps1`) instead.

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
