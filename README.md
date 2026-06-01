# BMad Hub Template

A scaffold for setting up a **BMad method project hub** — the central planning repo that coordinates AI-assisted development across multiple code repos and Claude Code sessions.

## The problem this solves

When you use Claude Code to build software, each terminal session starts with no memory of what you were doing. If you have multiple repos — a backend, a web frontend, an iOS app — you end up with no consistent way to hand off context between sessions, no shared definition of what's in progress, and no clear answer to "what should I work on next?"

The BMad method solves this with a **hub repo**: a single planning repository that every session reads first. It contains work queues (session files) that tell each Claude session exactly what to do, what's blocked, and what's done. The PM session owns and maintains these files; code sessions consume them.

## How it works

```
hub repo (this)              code repos
─────────────────            ────────────────────────────────────
docs/sessions/               cunningplay-backend/
  planning-session.md   ←──    CLAUDE.md  (points back to hub)
  backend-session.md    ←──  cunningplay-web/
  web-session.md        ←──    CLAUDE.md
  ios-session.md        ←──  cunningplay-ios/
  qa-session.md         ←──    CLAUDE.md
docs/epics/              
docs/tests/              
CLAUDE.md               
```

**Each session file answers one question: "What should I do right now?"**

When you open Claude Code in a code repo, it auto-reads `CLAUDE.md`, which points to the session file in the hub. The session file lists the top priority story, what's blocked, and any open PM questions — no copy-pasting, no context rebuild.

The **PM session** (running in the hub repo) is the only session that updates session files. It triages new work, resolves blockers, and keeps all queues current. Code sessions and the QA session read their file, do the work, and push.

## Sessions

| Session | Persona | Repo | Role |
|---------|---------|------|------|
| Planning | `bmad-agent-pm` | hub | Maintains all session files, epics, and test coverage |
| Backend | `bmad-agent-dev` | backend repo | Implements API stories |
| Web | `bmad-agent-dev` | web repo | Implements frontend stories |
| iOS | `bmad-agent-dev` | iOS repo | Implements iOS stories |
| Android | `bmad-agent-dev` | Android repo | Implements Android stories |
| QA | `bmad-qa` | cross-repo | Tests completed features against production |

You only create the sessions your project needs — see [Architecture presets](#architecture-presets).

## Quickstart

### Option A — BMad skill (recommended)

Open Claude Code in any directory and run:

```
/bmad-setup-hub
```

Claude asks for your project name, architecture preset, and repo names. The skill detects your environment automatically:

- **Claude Code** — writes files directly to disk and inits git
- **Other interfaces** (claude.ai, API, etc.) — outputs all file contents as formatted code blocks to copy, plus the shell commands to run

The skill is in `.claude/skills/bmad-setup-hub/`. Install it by copying that directory into your Claude Code skills folder, or via the BMad installer.

### Option B — Script (no Claude required)

Clone this repo, then run the script for your platform:

**macOS / Linux**
```bash
git clone https://github.com/cunningplay/bmad-hub-template
cd bmad-hub-template
./setup.sh
```

**Windows (PowerShell)**
```powershell
git clone https://github.com/cunningplay/bmad-hub-template
cd bmad-hub-template
.\setup.ps1
```

> If PowerShell blocks the script, run `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` once, then retry.

Both scripts ask the same questions and produce identical output to the skill.

## Architecture presets

Choose the preset that matches your project. Sessions not in the preset simply aren't created — you can always add more later with `/bmad-add-session`.

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
(your working directory)/
├── my-project-hub/                  ← hub repo, git initialised
│   ├── CLAUDE.md                    ← auto-loaded by Claude Code; PM session context
│   └── docs/
│       ├── sessions/
│       │   ├── planning-session.md  ← always created
│       │   ├── qa-session.md        ← always created
│       │   ├── backend-session.md   ← if backend selected
│       │   ├── web-session.md       ← if web selected
│       │   ├── ios-session.md       ← if ios selected
│       │   ├── android-session.md   ← if android selected
│       │   └── archive/
│       ├── epics/
│       └── tests/
├── my-project-backend/              ← code repo, git initialised, ready to push
│   └── CLAUDE.md
├── my-project-web/
│   └── CLAUDE.md
└── my-project-ios/
    └── CLAUDE.md
```

Each code repo is created as a sibling of the hub — no copying required. Open each in Claude Code and it immediately has full session context.

## Adding sessions later

If your project grows a new code repo after initial setup, run `/bmad-add-session` from inside the hub:

```
/bmad-add-session
```

It adds the session file, updates the hub `CLAUDE.md` session map, and generates a `CLAUDE.md` for the new code repo.

## Skill compatibility

`bmad-setup-hub` and `bmad-add-session` are environment-aware — they detect whether file system tools are available and adapt:

| Environment | Skill behaviour |
|-------------|----------------|
| Claude Code | Writes files to disk, inits git |
| claude.ai / API / other | Outputs file contents as copy-paste blocks + shell commands |

The shell scripts (`setup.sh` / `setup.ps1`) are an alternative if you prefer not to use the skills at all.

## After setup

### 1. Install BMad

BMad is the AI-native development framework that powers the personas, skills, and workflows referenced in every session file. The hub setup creates the session structure — BMad provides the intelligence layer on top.

**Install:** follow the instructions at [bmad-code.github.io](https://bmad-code.github.io) (or your team's internal BMad distribution). Run the installer inside the hub directory — it populates `_bmad/` with scripts, skills, and config.

> Install BMad **before** opening your first planning session. The PM persona (`bmad-agent-pm`) and all `/bmad-*` skills come from BMad, not from this template.

### 2. Push code repos to GitHub

Each code repo was created as a sibling directory of the hub, already `git init`'d with an initial commit. Add a remote and push each one:

```bash
cd ../my-project-backend
git remote add origin git@github.com:your-org/my-project-backend.git
git push -u origin main
```

Claude Code reads `CLAUDE.md` automatically on startup — no copy-paste needed.

### 3. Update production URLs

Fill in real service URLs in `docs/sessions/qa-session.md`. The generated file has `https://api.example.com` placeholders.

### 4. Push to GitHub

Push the hub repo. If you want this hub to be reusable as a GitHub template for future projects, enable **"Template repository"** in the repo's Settings page.

### 5. Start planning

Open Claude Code in the hub directory and invoke `bmad-agent-pm` to begin your first planning session.

**Not sure what to do next?** Type `/bmad-help` at any point — it reads the current project state and recommends the right next skill or action. Use it when you're starting fresh, returning after a break, or unsure which BMad skill applies to your current task.

## Templates

Raw session template files live in [templates/](templates/). Each uses `{{PLACEHOLDER}}` tokens — substituted automatically by the skills and scripts, or edit manually if you prefer.

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
