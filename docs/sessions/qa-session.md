---
session: qa
persona: bmad-qa
last_story: ""
last_updated: ""
---

# QA Session — Work Queue

> **Start every session by reading this file.** PM session maintains it.
> Test cases for all stories: `docs/tests/`
> File bugs via backlog (repo: owning session)

## 🔴 Ready to Test Now

<!-- PM or code sessions add entries here when stories are done.
| Feature | Test file | Notes |
| --- | --- | --- |
| Feature name | docs/tests/eN-*.md | Notes |
-->

_Nothing ready to test yet._

## 🔑 Test Credentials

| Account | Role | Auth method |
| --- | --- | --- |
| `{{ADMIN_EMAIL}}` | admin | email/password — ask user |

**Always test against production URLs — never localhost:**

| Service | URL |
| --- | --- |
| Backend API | `{{LIVE_API_URL}}` |
| Web | `{{LIVE_WEB_URL}}` |

## 📋 QA Backlog — No Coverage Yet

<!-- Add areas that need test files. -->

## 🐛 How to File Bugs

Add to backlog:
- `repo`: owning session repo
- `id`: next bug-NNN in sequence
- `title`: prefixed `🐛 BUG-NNN:`
- `description`: steps + expected vs actual + AC reference
- `priority`: high / medium / low

## Persona & Skills

**Persona:** `bmad-qa`
**Skills:** `bmad-qa-generate-e2e-tests`, `gds-test-design`, `gds-test-review`, `gds-test-automate`

## ❓ Questions for PM

None currently open.
