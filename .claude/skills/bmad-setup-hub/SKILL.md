---
name: bmad-setup-hub
description: Scaffold a new BMad project hub interactively. Asks for project name, architecture preset, and repo names — then generates all session files, hub CLAUDE.md, and per-repo CLAUDE.md files. Adapts to the environment: direct file generation in Claude Code, guided text output elsewhere. Use when the user says "setup hub", "new project", or "create hub".
---

# BMad Hub Setup Skill

## Overview

This workflow creates a complete BMad project hub from scratch. It asks questions conversationally, presents architecture presets, and then generates all session files, the hub `CLAUDE.md`, and ready-to-copy `CLAUDE.md` files for each code repo.

**Environment-aware:** the skill detects what tools are available at startup and switches modes automatically:

| Mode | When | Behaviour |
|------|------|-----------|
| **Direct** | Claude Code (Write + Bash tools available) | Writes files to disk, inits git, reports paths |
| **Guided** | Any other environment (claude.ai, API, etc.) | Outputs all file contents as formatted code blocks to copy-paste, plus shell commands to run |

The questions, presets, and output content are identical in both modes.

## Conventions

- Bare paths resolve from the skill root.
- `{skill-root}` = this skill's installed directory.
- `{project-root}` = the working directory of the current Claude Code session.
- Template files live at `{skill-root}/../../templates/` (two levels up from the skill, at the repo root's `templates/` directory).

## On Activation

### Step 1: Resolve the Workflow Block

Run: `python3 {project-root}/_bmad/scripts/resolve_customization.py --skill {skill-root} --key workflow`

**If the script fails**, read `{skill-root}/customize.toml` and apply defaults directly. No team or user overrides are expected for this skill.

### Step 2: Load Config (if BMad is installed)

If `{project-root}/_bmad/bmm/config.yaml` exists, load it and use:
- `{user_name}` for addressing the user
- `{communication_language}` for all responses

If the config doesn't exist (BMad not yet installed), use "there" as the fallback name and English as the language — this skill often runs *before* BMad is installed.

### Step 3: Greet and Begin

Greet the user and proceed immediately to the workflow. Do not show a menu.

---

## Workflow

<workflow>

<step n="0" goal="Detect environment and set mode">

Attempt to run the following Bash command silently:

```bash
pwd
```

**If it succeeds:** you are in Claude Code (or an equivalent tool-enabled environment). Set `MODE = direct`. File generation will write to disk.

**If it fails or the tool is unavailable:** you are in a non-Claude-Code environment (claude.ai, API, IDE plugin without Bash, etc.). Set `MODE = guided`. File generation will output formatted content for the user to copy.

Do not report the mode to the user — just carry it forward. Proceed to step 1.

</step>

<step n="1" goal="Collect project information">

Ask the following questions in a single conversational message — do not ask one at a time:

1. **Project name** — what is the product called? (e.g. "Ashenmarch")
2. **One-line description** — what does it do?
3. **Hub repo name** — what will the planning hub repo be called? (suggest: `{project-name}-hub` or `{ProjectName}_Hub`)

Wait for the user's answers before proceeding.

</step>

<step n="2" goal="Choose architecture preset">

Present the following options clearly:

| # | Preset | Sessions created | Use when |
|---|--------|-----------------|----------|
| 1 | **Web only** | planning, web, qa | Frontend with serverless / third-party backend |
| 2 | **API + Web** | planning, backend, web, qa | Separate API server + web frontend |
| 3 | **API + Mobile** | planning, backend, ios, android, qa | API + native mobile (both platforms) |
| 4 | **API + iOS only** | planning, backend, ios, qa | API + iOS only |
| 5 | **Full stack** | planning, backend, web, ios, android, qa | API + web companion + native mobile |
| 6 | **iOS only** | planning, ios, qa | iOS app with third-party backend (Firebase, Supabase, etc.) |
| 7 | **Android only** | planning, android, qa | Android app with third-party backend |
| 8 | **Mobile only** | planning, ios, android, qa | iOS + Android with third-party backend |
| 9 | **Custom** | you choose | Any other combination |

For **Custom**, ask the user to select from: `backend`, `web`, `ios`, `android`, `cli`. Allow multiple selections.

Always include `planning` and `qa` — they are not optional.

Wait for the user's choice before proceeding.

</step>

<step n="3" goal="Collect repo names and stack details">

For each code session selected (not planning or qa), ask:

- **Repo name** — what is the code repo called? (suggest a slug based on project name)
- **Lint + test command** — what command validates the code? (for backend/web/cli only; skip for ios/android since those have fixed commands)

Also ask:
- **Admin/test email** — used in the QA session credentials table (e.g. `admin@example.com`)

Group all questions for this step into one message to avoid excessive back-and-forth. Example:

> For your backend repo:
> - Repo name? [my-project-backend]
> - Lint + test command? [go test ./... && golangci-lint run]
>
> For your web repo:
> - Repo name? [my-project-web]
> - Lint + test command? [npm run check]
>
> Admin test email? [admin@example.com]

Wait for answers.

</step>

<step n="4" goal="Confirm and preview">

Show a summary of what will be generated:

```
Hub repo:     {hub-repo-name}/          (created in current directory)
Sessions:     planning, {selected-sessions}, qa
Code repos:   {list of repo names}      (sibling directories, each with CLAUDE.md + git init)
```

Ask: **"Shall I generate this now?"**

If the user wants changes, loop back to the relevant step. If confirmed, proceed.

</step>

<step n="5" goal="Generate hub directory and session files">

**If MODE = direct:** create the following directory structure using the Write tool:

```
{hub-repo-name}/
├── CLAUDE.md
├── .gitignore
├── docs/
│   ├── sessions/
│   │   ├── planning-session.md      ← always
│   │   ├── {session}-session.md     ← one per selected session
│   │   ├── qa-session.md            ← always
│   │   ├── README.md
│   │   └── archive/
│   │       └── .gitkeep
│   ├── epics/
│   │   └── README.md
│   └── tests/
│       └── README.md
```

**For each file**, read the corresponding template from `{skill-root}/../../templates/` and substitute:

| Placeholder | Value |
|-------------|-------|
| `{{PROJECT_NAME}}` | Project name from step 1 |
| `{{PROJECT_DESCRIPTION}}` | Description from step 1 |
| `{{HUB_REPO}}` | Hub repo name from step 1 |
| `{{DATE}}` | Today's date (YYYY-MM-DD) |
| `{{ADMIN_EMAIL}}` | Admin email from step 3 |
| `{{SESSION_MAP}}` | Generated markdown table (see below) |
| `{{PRODUCTION_URLS}}` | Generated markdown rows (see below) |
| `{{BACKEND_REPO}}`, `{{WEB_REPO}}`, `{{IOS_REPO}}`, `{{ANDROID_REPO}}`, `{{CLI_REPO}}` | Repo names from step 3 |
| `{{LINT_TEST_CMD}}` | Lint+test command from step 3 (per session) |

**Session map table** — always starts with planning row, ends with qa row, code sessions in between:
```
| Session | File | Repo |
|---------|------|------|
| Planning | `docs/sessions/planning-session.md` | `{hub-repo}` |
| Backend  | `docs/sessions/backend-session.md`  | `{backend-repo}` |
...
| QA | `docs/sessions/qa-session.md` | cross-repo |
```

**Production URLs block** — one row per service with a live URL:
```
| API | `https://api.example.com` |
| Web | `https://app.example.com` |
```
(Use placeholder URLs — user fills in real ones after setup.)

**sessions/README.md** — generate directly (no template needed):
```markdown
# Session Work Queues
One file per active Claude Code session. Each answers: "What should I be doing right now?"

| File | Session | Repo |
|------|---------|------|
{rows for each session}

PM session maintains all files. Sessions read their file at session start and signal changes via the backlog.
```

**docs/epics/README.md** and **docs/tests/README.md** — write verbatim:

```markdown
# Epics
One file per epic: `e{N}-{slug}.md`
Frontmatter: epic, title, milestone, status, stories_total, stories_done.
```

```markdown
# Test Cases
One file per epic, mirroring docs/epics/ naming. QA session writes test cases here.
Always test against production URLs — never localhost.
```

**.gitignore**:
```
.DS_Store
Thumbs.db
desktop.ini
```

**If MODE = guided:** output every file as a clearly labelled code block instead of writing to disk. Use this structure:

````
### `{hub-repo-name}/CLAUDE.md`
```markdown
{file contents}
```

### `{hub-repo-name}/docs/sessions/planning-session.md`
```markdown
{file contents}
```
...and so on for every file.
````

After all file blocks, output the shell commands the user needs to run:

```bash
# Create the directory structure
mkdir -p {hub-repo-name}/docs/sessions/archive
mkdir -p {hub-repo-name}/docs/epics
mkdir -p {hub-repo-name}/docs/tests
touch {hub-repo-name}/docs/sessions/archive/.gitkeep

# After saving the files above:
cd {hub-repo-name}
git init
git add -A
git commit -m "init: {project-name} hub (BMad session scaffold)"
```

</step>

<step n="6" goal="Generate code repo directories with CLAUDE.md">

For each selected code session, generate a `CLAUDE.md` using `{skill-root}/../../templates/code-repo-CLAUDE.md` as the base, substituting all placeholders.

**If MODE = direct:** create each code repo as a sibling directory alongside the hub, with `CLAUDE.md` inside and an initial git commit:

```
(parent of hub)/
├── {hub-repo-name}/        ← hub (already created in step 5)
├── {backend-repo}/
│   └── CLAUDE.md
├── {web-repo}/
│   └── CLAUDE.md
└── {ios-repo}/
    └── CLAUDE.md
```

For each code repo:
1. Create the directory at the same level as the hub
2. Write `CLAUDE.md` into it
3. Run `git init && git add CLAUDE.md && git commit -m "init: {project} {session} repo"`

**If MODE = guided:** output each as a labelled code block with the target path shown:
````
### `../{repo-name}/CLAUDE.md`
```markdown
{file contents}
```
````
Then list the shell commands to create and init each repo:
```bash
mkdir {repo-name} && cd {repo-name}
git init && git add CLAUDE.md && git commit -m "init: {project} {session} repo"
```

Platform-specific workflow lines by session type:

**ios:**
```
1. Read spec in `../{hub-repo}/docs/epics/e{N}-*.md`
2. Invoke `/bmad-dev-story` with the story file path
3. GPS / App Group stories require a **physical device** — simulator insufficient
4. Add QA test cases to `../{hub-repo}/docs/tests/e{N}-*.md`
5. Add ready-to-test entry to `../{hub-repo}/docs/sessions/qa-session.md`
6. Push
```

**android:**
```
1. Read spec in `../{hub-repo}/docs/epics/e{N}-*.md`
2. Invoke `/bmad-dev-story` with the story file path
3. `./gradlew detekt && ./gradlew assembleDebug`
4. GPS / foreground service stories require a **physical device**
5. Add QA test cases to `../{hub-repo}/docs/tests/e{N}-*.md`
6. Add ready-to-test entry to `../{hub-repo}/docs/sessions/qa-session.md`
7. Push
```

**backend / web / cli:**
```
1. Read spec in `../{hub-repo}/docs/epics/e{N}-*.md`
2. Invoke `/bmad-dev-story` with the story file path
3. `{lint-test-command}`
4. Add QA test cases to `../{hub-repo}/docs/tests/e{N}-*.md`
5. Add ready-to-test entry to `../{hub-repo}/docs/sessions/qa-session.md`
6. Push
```

</step>

<step n="7" goal="Initialize git and report">

**If MODE = direct:** run:
```bash
git -C {hub-repo-name} init
git -C {hub-repo-name} add -A
git -C {hub-repo-name} commit -m "init: {project-name} hub (BMad session scaffold)"
```

**If MODE = guided:** the git commands were already included in step 5's shell block. Skip the Bash call.

Then report to the user:

---

**Created:**
- Hub: `./{hub-repo-name}/`
- Code repos (sibling directories, each with `CLAUDE.md` + `git init`):
  - `./{repo-name}/` _(one line per code session)_

Sessions in hub:
- `planning-session.md`
- _(one line per selected session)_
- `qa-session.md`

**Next steps:**
1. Fill in real production URLs in `docs/sessions/qa-session.md`
2. Install BMad in the hub: run the BMad installer in `./{hub-repo-name}/`
3. Push each repo to GitHub
4. Open Claude Code in `./{hub-repo-name}/` and invoke `bmad-agent-pm` to start planning

</step>

</workflow>
