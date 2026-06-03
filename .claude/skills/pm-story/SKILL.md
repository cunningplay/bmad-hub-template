---
name: pm-story
description: File a new story in an existing epic. Updates the epic frontmatter (total count, story entry), appends the story spec with Given/When/Then ACs, and commits to the planning repo. Use when the user says "file a story", "add a story", "create story X.Y", or describes a feature that needs a story.
---

# PM Story Filing

## Overview

Creates a properly formatted story in the correct epic. Handles the full workflow: frontmatter update → AC spec → session queue update → commit → push.

## Conventions

- `{project-root}` = current working directory (hub repo root)
- Epics: `{project-root}/docs/epics/`
- Sessions: `{project-root}/docs/sessions/`
- Story format: frontmatter entry + `### Story X.Y: Title` + user story + Given/When/Then ACs

## Workflow

<workflow>

<step n="1" goal="Gather story details">
Ask (all at once):
1. **Epic** — which epic does this belong to?
2. **Story number** — read the epic frontmatter to find the current `total` and propose the next number
3. **Title** — concise story title
4. **User story** — "As a [who], I want [what], So that [why]" — or describe and I'll write it
5. **Acceptance criteria** — describe the behaviour; I'll format as Given/When/Then
6. **Backend required?** — does this need a new API endpoint or schema change?
7. **Session owner** — which session implements this?
</step>

<step n="2" goal="Read the target epic">
Read the epic file to:
- Confirm the current `total` count
- Find the last story number used
- Understand the established AC style and conventions
</step>

<step n="3" goal="Draft and confirm">
Show the complete story spec draft and ask for approval before writing.
</step>

<step n="4" goal="Write to epic and commit">
Once confirmed:
1. Update frontmatter: increment `total`, add story entry before `---`
2. Append story spec at end of epic file
3. If story is in a code session's scope, add to that session file's sprint queue
4. Commit: `feat(EX): add story X.Y — {title}`
5. Push and report the commit hash
</step>

</workflow>

## Story format

**Frontmatter entry:**
```yaml
  - num: "X.Y"
    title: "Story Title"
    status: pending
    note: "Optional context note"
```

**Story spec:**
```markdown
### Story X.Y: Story Title

As a [role],
I want [action],
So that [outcome].

**Acceptance Criteria:**

**Given** [precondition]
**When** [action]
**Then** [expected result]
**And** [additional assertion]

---
```
