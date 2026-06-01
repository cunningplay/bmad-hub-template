# Session Work Queues

One file per active Claude Code session. Each file answers: **"What should I be doing right now?"**

## Files

| File | Session | Repo |
|------|---------|------|
| `planning-session.md` | PM / Planning | `{{HUB_REPO}}` |
| `backend-session.md` | Backend | `{{BACKEND_REPO}}` |
| `web-session.md` | Web | `{{WEB_REPO}}` |
| `ios-session.md` | iOS | `{{IOS_REPO}}` |
| `android-session.md` | Android | `{{ANDROID_REPO}}` |
| `qa-session.md` | QA | cross-repo |

> Delete rows for sessions that don't apply to your project.

## How to use

**At the start of every session:** Read your session file first. It tells you your top priority, what's ready, what's blocked, and any open PM questions.

**The PM session** maintains these files. Sessions do not update their own queue — they flag new information to PM via the backlog.

## How it fits with the rest

```
docs/sessions/*.md    ← START HERE every session (what to do)
docs/epics/*.md       ← Full spec for any story you're working on
docs/tests/*.md       ← QA test cases per epic
```

## Keeping queues current

PM updates session files when:
- A story is completed (remove or archive it)
- A blocker is resolved (move story from blocked to ready)
- Priority changes (reorder)
- New backlog items arrive for a session
- PM decisions answer open questions

## Archive

Completed sprint logs, audit snapshots, and resolved bug tables go in `archive/` — keeps active files lean without losing history.
