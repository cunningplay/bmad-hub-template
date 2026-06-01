# Epics

One file per epic. Each file is the authoritative spec for all stories within that epic.

## Naming

`e{N}-{slug}.md` — e.g. `e4-foundation.md`, `e5-player-identity.md`

## Frontmatter

Each epic file should include:

```yaml
---
epic: N
title: "Epic Title"
milestone: "launch | post-launch | research"
status: "draft | in_progress | done"
stories_total: 0
stories_done: 0
---
```

## How stories are picked

Sessions read their session file first. The session file references which epic and story to implement. Sessions read the full epic spec before invoking `/bmad-dev-story`.
