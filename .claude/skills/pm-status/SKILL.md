---
name: pm-status
description: Cross-session PM status check. Reads all session files and produces a single status table showing current sprint, active stories, blockers, and open PM actions. Use at the start of every PM session or when asked "what's the status", "check sessions", or "what's going on".
---

# PM Status Check

## Overview

Reads all session files in the project and produces a concise cross-session status summary. Replaces the manual process of opening each session file individually.

## Conventions

- `{project-root}` = current working directory (hub repo root)
- Session files: `{project-root}/docs/sessions/*.md` (all except README.md)

## On Activation

1. Discover all session files: find every `*.md` in `{project-root}/docs/sessions/` except `README.md`
2. Read all session files in parallel
3. Read the planning session for open PM actions
4. Run `git -C {project-root} log --oneline -5` for recent commits

## Output Format

Produce the status in this exact structure — keep it scannable, no prose:

---

### 🔴 Open PM Actions
List any open items from the planning session's next tasks or pending sections.

### 📊 Session Status

| Session | Sprint | Top priority | Key blocker |
|---------|--------|-------------|-------------|
| {name} | Sprint N | Story X.Y — what | Blocker or — |

(One row per session file found, excluding planning and README.)

### 🔴 Cross-session blockers
List any stories blocking multiple sessions with the dependency chain.

### 🟢 Recently shipped (last 5 commits)
One line per commit from `git log`.

---

Keep the whole output under 40 lines. Flag anything needing PM attention with ⚠️.
