---
name: bmad-add-session
description: Add a new code session to an existing BMad project hub. Generates the session file, updates the hub CLAUDE.md session map, and creates a sibling repo directory with CLAUDE.md ready for git. Use when the user says "add session", "add repo", "add backend", "add iOS", or similar.
---

# BMad Add Session Skill

## Overview

Adds a new code session to an already-scaffolded BMad hub. Run this from inside the hub repo when your project grows a new code repo — a new platform, a backend that wasn't in the original preset, a CLI tool, etc.

**What it does:**
1. Confirms you're in a valid hub repo
2. Asks which session type to add and what the repo is called
3. Generates the session file in `docs/sessions/`
4. Updates the session map in `CLAUDE.md` and `docs/sessions/README.md`
5. Creates a sibling repo directory with `CLAUDE.md` inside, ready to push to GitHub

**Environment-aware:** detects Claude Code vs other interfaces and switches between direct file writing and guided copy-paste output.

## Conventions

- `{skill-root}` = this skill's installed directory
- `{project-root}` = current working directory (should be the hub repo root)
- Templates at `{skill-root}/../../templates/`

## On Activation

### Step 1: Resolve Workflow Block

Run: `python3 {project-root}/_bmad/scripts/resolve_customization.py --skill {skill-root} --key workflow`

If the script fails, read `{skill-root}/customize.toml` directly for defaults.

### Step 2: Load Config

If `{project-root}/_bmad/bmm/config.yaml` exists, load `user_name` and `communication_language`. Otherwise default to "there" and English.

### Step 3: Greet and Begin

Greet the user briefly and proceed immediately to the workflow.

---

## Workflow

<workflow>

<step n="0" goal="Detect environment and validate hub">

**Detect environment:** attempt `pwd` via Bash.
- Success → `MODE = direct`
- Failure → `MODE = guided`

**Validate hub:** check that `docs/sessions/planning-session.md` exists in the current directory.

- If it exists → proceed
- If it does not → stop and tell the user: "This doesn't look like a BMad hub repo. Run `/bmad-add-session` from the hub repo root (the directory that contains `docs/sessions/`)."

**If MODE = direct:** also read the current `CLAUDE.md` and `docs/sessions/README.md` so you can update them later.

</step>

<step n="1" goal="Ask which session to add">

Ask:

1. **Session type** — which type are you adding?

   | Type | Use when |
   |------|----------|
   | `backend` | Adding a server-side API (Go, Node, Python, Rails, etc.) |
   | `web` | Adding a web frontend (SvelteKit, Next.js, React, etc.) |
   | `ios` | Adding an iOS native app (Swift / SwiftUI) |
   | `android` | Adding an Android native app (Kotlin / Compose) |
   | `cli` | Adding a command-line tool |

2. **Repo name** — what is the new code repo called? (e.g. `my-project-backend`)

3. **Lint + test command** — for `backend`, `web`, `cli` only. What command validates the code? (e.g. `go test ./... && golangci-lint run`, `npm run check`)
   - Skip this question for `ios` and `android` — they have fixed commands.

4. **Confirm no duplicate** — check whether a session file for this type already exists (`docs/sessions/{type}-session.md`). If it does, warn the user and ask whether to overwrite or cancel.

</step>

<step n="2" goal="Generate session file">

Read `{skill-root}/../../templates/sessions/{type}-session.md`.

Substitute placeholders using values from step 1 plus existing hub context (read `CLAUDE.md` to extract `{{PROJECT_NAME}}`, `{{PROJECT_DESCRIPTION}}`, `{{HUB_REPO}}`).

**If MODE = direct:** write to `docs/sessions/{type}-session.md`.

**If MODE = guided:** output as a labelled code block:
````
### `docs/sessions/{type}-session.md`
```markdown
{file contents}
```
````

</step>

<step n="3" goal="Generate code repo CLAUDE.md">

Read `{skill-root}/../../templates/code-repo-CLAUDE.md` and substitute all placeholders.

Platform-specific workflow lines:

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

**If MODE = direct:** create the repo directory as a sibling of the hub (one level up from the hub root) and write `CLAUDE.md` into it:
```
(parent)/
├── {hub-repo}/        ← you are here
└── {repo-name}/       ← created now
    └── CLAUDE.md
```
Then:
1. Copy dev skills from `{skill-root}/../../.claude/skills/` → `{repo-name}/.claude/skills/`: `dev-start`, `dev-done`, `dev-pm-check`, `dev-ask-pm`, `dev-qa-done`
2. Run `git init && git add . && git commit -m "init: {project} {session} repo"` inside it.

**If MODE = guided:** output as a labelled code block showing the target path:
````
### `../{repo-name}/CLAUDE.md`
```markdown
{file contents}
```
````
Then show the shell commands:
```bash
mkdir ../{repo-name} && cd ../{repo-name}
# Copy dev skills from hub template
cp -r path/to/bmad-hub-template/.claude/skills/dev-* .claude/skills/
git init && git add . && git commit -m "init: {project} {session} repo"
```

</step>

<step n="4" goal="Update hub CLAUDE.md session map">

The hub `CLAUDE.md` contains a session map table in the format:

```markdown
| Session | File | Repo |
|---------|------|------|
| Planning | `docs/sessions/planning-session.md` | `hub-repo` |
...
| QA | `docs/sessions/qa-session.md` | cross-repo |
```

Insert a new row for the added session **before the QA row**:

```markdown
| {Title} | `docs/sessions/{type}-session.md` | `{repo-name}` |
```

**If MODE = direct:** edit `CLAUDE.md` in place.

**If MODE = guided:** output the full updated session map table as a code block showing where the new row goes.

</step>

<step n="5" goal="Update docs/sessions/README.md">

The sessions README contains a table of all session files. Add a row for the new session, again before the QA row:

```markdown
| `{type}-session.md` | {Title} | `{repo-name}` |
```

**If MODE = direct:** edit `docs/sessions/README.md` in place.

**If MODE = guided:** output the updated table.

</step>

<step n="6" goal="Report">

**If MODE = direct:**

---

**Session added: `{type}`**

Files created / updated:
- `docs/sessions/{type}-session.md` ✓
- `../{repo-name}/CLAUDE.md` ✓ (sibling directory, git initialised)
- `CLAUDE.md` — session map updated ✓
- `docs/sessions/README.md` — session table updated ✓

**Next steps:**
1. Create the repo on GitHub, then push the new code repo:
   ```bash
   cd ../{repo-name}
   git remote add origin git@github.com:{your-org}/{repo-name}.git
   git push -u origin main
   ```
2. Commit and push the hub changes:
   ```bash
   cd ../{hub-repo}
   git add -A && git commit -m "add {type} session"
   git push
   ```
3. The PM session will populate `docs/sessions/{type}-session.md` with the first sprint tasks

---

**If MODE = guided:**

Summarise all outputs and the manual edits needed for `CLAUDE.md` and `docs/sessions/README.md`.

</step>

</workflow>
