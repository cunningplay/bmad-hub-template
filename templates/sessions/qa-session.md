---
session: qa
persona: bmad-qa
last_story: ""
last_updated: "{{DATE}}"
---

# QA Session — Work Queue

> **Start every session by reading this file.** PM session maintains it.
> Test cases: `docs/tests/` · File bugs via backlog (tag owning repo)

## 🔴 Ready to Test Now

_Code sessions add entries here when stories are done._

## 🔑 Test Credentials

| Account | Role | Auth |
| --- | --- | --- |
| `{{ADMIN_EMAIL}}` | admin | email/password — ask user |

**Always test against production URLs — never localhost:**

| Service | URL |
| --- | --- |
{{PRODUCTION_URLS}}

## 📋 Backlog — No Coverage Yet

_Add areas that need test files as the project grows._

## 🐛 How to File Bugs

- `id`: next bug-NNN in sequence
- `title`: prefixed `🐛 BUG-NNN:`
- `description`: steps + expected vs actual + AC reference
- `priority`: high / medium / low

## Persona & Skills

**Persona:** `bmad-qa`
**Skills:** `bmad-qa-generate-e2e-tests`, `gds-test-design`, `gds-test-review`, `gds-test-automate`

## ❓ Questions for PM

None currently open.
