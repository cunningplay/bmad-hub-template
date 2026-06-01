---
session: android
repo: "{{ANDROID_REPO}}"
persona: bmad-agent-dev
last_story: ""
last_updated: "{{DATE}}"
---

# Android Session — Work Queue

> **Start every session by reading this file.** PM session maintains it.
> See also: `../{{ANDROID_REPO}}/CLAUDE.md` for stack + workflow reference.

## 🔴 Top Priority

_No active stories — PM will populate this._

## 🟡 Ready (unblocked)

## ⏳ Blocked

| Story | Blocked on |
|-------|-----------|

## Persona & Skills

**Persona:** `bmad-agent-dev` — Kotlin / Jetpack Compose

**Story workflow:**
1. Read spec in `docs/epics/e{N}-*.md`
2. `/bmad-dev-story` with the story file path
3. `./gradlew detekt && ./gradlew assembleDebug`
4. GPS / foreground service stories require a **physical device**
5. Add QA test cases to `docs/tests/e{N}-*.md`
6. Add ready-to-test entry to `docs/sessions/qa-session.md`
7. Push

## ❓ Questions for PM

None currently open.
