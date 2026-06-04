---
name: dev-pm-check
description: Check for new PM decisions, answers, and sprint changes relevant to this session. Reads the planning session and own session file. No user input required. Use at the start of each dev session or when the user says "check PM updates", "any PM changes", "what did PM decide".
---

# Dev PM Check — Check for PM Updates

## Overview

Reads the planning session and the current session file for any new PM decisions, answers to open questions, sprint reorders, or new blockers. Reports only what's relevant to this session. Fully autonomous.

## Conventions

- `{hub-root}` = hub repo path (from CLAUDE.md)
- Planning session: `{hub-root}/docs/sessions/planning-session.md`
- Own session: `{hub-root}/docs/sessions/{session}-session.md`

## Workflow

<workflow>

<step n="1" goal="Read PM sources">
Read in parallel:
1. `{hub-root}/docs/sessions/planning-session.md` — look for: 🏁 PM Decisions sections, ✅ PM Answers tables, sprint reorders, new blocker resolutions
2. `{hub-root}/docs/sessions/{session}-session.md` — look for: ✅ PM Answers tables (questions that were open last session), sprint changes, new stories added

Focus on entries dated after `last_updated` in the session frontmatter.
</step>

<step n="2" goal="Filter and report">
Report only items relevant to this session in this format:

**🟢 New PM decisions affecting this session:**
- [Decision name] — [one-line summary] — [what to do now]

**✅ PM answered your questions:**
- [Q summary] — [Answer summary] — [action if any]

**🔄 Sprint changes:**
- [What changed in your sprint queue]

**⚠️ New blockers or dependencies:**
- [Blocker] — [what it blocks] — [who owns resolution]

If nothing has changed since last session, say: "No new PM updates since last session."

Do NOT report items from other sessions unless they directly affect this session's stories.
</step>

</workflow>
