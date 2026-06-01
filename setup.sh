#!/usr/bin/env bash
# BMad Hub Setup
# Creates a project hub repo with the right session files for your architecture.
# Run from the directory where you want the hub repo created.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
DATE="$(date +%Y-%m-%d)"

# ── Helpers ──────────────────────────────────────────────────────────────────

bold()  { printf '\033[1m%s\033[0m' "$1"; }
green() { printf '\033[32m%s\033[0m' "$1"; }
dim()   { printf '\033[2m%s\033[0m' "$1"; }

prompt() {
  local label="$1" default="$2" var
  printf '%s' "$(bold "$label")"
  [ -n "$default" ] && printf ' %s' "$(dim "[$default]")"
  printf ': '
  read -r var
  echo "${var:-$default}"
}

confirm() {
  printf '%s [y/N]: ' "$(bold "$1")"
  read -r ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ── Collect project info ──────────────────────────────────────────────────────

echo
echo "$(bold '=== BMad Hub Setup ===')"
echo "Creates a planning hub repo with session files for your architecture."
echo

PROJECT_NAME=$(prompt "Project name" "")
PROJECT_DESCRIPTION=$(prompt "One-line description" "")
HUB_REPO=$(prompt "Hub repo name" "${PROJECT_NAME// /-}-hub")
OUTPUT_DIR=$(prompt "Output directory" "./$HUB_REPO")

# ── Choose architecture ───────────────────────────────────────────────────────

echo
echo "$(bold 'Architecture preset:')"
echo "  1) Web only          — planning, web, qa"
echo "  2) API + Web         — planning, backend, web, qa"
echo "  3) API + Mobile      — planning, backend, ios, android, qa"
echo "  4) API + iOS only    — planning, backend, ios, qa"
echo "  5) Full stack        — planning, backend, web, ios, android, qa"
echo "  6) iOS only          — planning, ios, qa"
echo "  7) Android only      — planning, android, qa"
echo "  8) Mobile only       — planning, ios, android, qa"
echo "  9) Custom            — choose individual sessions"
echo
printf '%s' "$(bold 'Choice') [1-9]: "
read -r PRESET

SESSIONS=("planning" "qa")  # always included

case "$PRESET" in
  1) SESSIONS+=("web") ;;
  2) SESSIONS+=("backend" "web") ;;
  3) SESSIONS+=("backend" "ios" "android") ;;
  4) SESSIONS+=("backend" "ios") ;;
  5) SESSIONS+=("backend" "web" "ios" "android") ;;
  6) SESSIONS+=("ios") ;;
  7) SESSIONS+=("android") ;;
  8) SESSIONS+=("ios" "android") ;;
  9)
    echo
    echo "$(bold 'Select sessions') (y/n for each):"
    for s in backend web ios android cli; do
      confirm "  Include $s session?" && SESSIONS+=("$s")
    done
    ;;
  *) echo "Invalid choice. Defaulting to API + Web."; SESSIONS+=("backend" "web") ;;
esac

# ── Collect repo names for each session ──────────────────────────────────────

echo
echo "$(bold 'Repo names for each session:')"
declare -A REPOS
declare -A REPO_ROLES
declare -A LINT_CMDS

for session in "${SESSIONS[@]}"; do
  case "$session" in
    planning|qa) continue ;;
    backend)
      REPOS[backend]=$(prompt "  Backend repo name" "${PROJECT_NAME,,}-backend")
      LINT_CMDS[backend]=$(prompt "  Backend lint+test command" "go test ./... && golangci-lint run")
      REPO_ROLES[backend]="API server"
      ;;
    web)
      REPOS[web]=$(prompt "  Web repo name" "${PROJECT_NAME,,}-web")
      LINT_CMDS[web]=$(prompt "  Web lint+test command" "npm run check")
      REPO_ROLES[web]="Web frontend"
      ;;
    ios)
      REPOS[ios]=$(prompt "  iOS repo name" "${PROJECT_NAME,,}-ios")
      REPO_ROLES[ios]="iOS native app"
      ;;
    android)
      REPOS[android]=$(prompt "  Android repo name" "${PROJECT_NAME,,}-android")
      REPO_ROLES[android]="Android native app"
      ;;
    cli)
      REPOS[cli]=$(prompt "  CLI repo name" "${PROJECT_NAME,,}-cli")
      LINT_CMDS[cli]=$(prompt "  CLI lint+test command" "go test ./... && golangci-lint run")
      REPO_ROLES[cli]="CLI tool"
      ;;
  esac
done

ADMIN_EMAIL=$(prompt "Admin/test email" "admin@example.com")

# ── Generate hub CLAUDE.md session map ───────────────────────────────────────

SESSION_MAP="| Session | File | Repo |\n|---------|------|------|\n"
SESSION_MAP+="| Planning | \`docs/sessions/planning-session.md\` | \`$HUB_REPO\` |\n"
for session in "${SESSIONS[@]}"; do
  case "$session" in
    planning|qa) continue ;;
    *) SESSION_MAP+="| ${session^} | \`docs/sessions/$session-session.md\` | \`${REPOS[$session]}\` |\n" ;;
  esac
done
SESSION_MAP+="| QA | \`docs/sessions/qa-session.md\` | cross-repo |"

# ── Generate QA production URLs block ────────────────────────────────────────

PROD_URLS=""
for session in "${SESSIONS[@]}"; do
  case "$session" in
    backend) PROD_URLS+="| API | \`https://api.example.com\` |\n" ;;
    web)     PROD_URLS+="| Web | \`https://app.example.com\` |\n" ;;
  esac
done
[ -z "$PROD_URLS" ] && PROD_URLS="| App | \`https://example.com\` |"

# ── Scaffold output directory ─────────────────────────────────────────────────

echo
echo "Creating hub at $(bold "$OUTPUT_DIR")..."

mkdir -p "$OUTPUT_DIR/docs/sessions/archive" \
         "$OUTPUT_DIR/docs/epics" \
         "$OUTPUT_DIR/docs/tests"

# Substitution helper
sub() {
  local file="$1"
  sed -i \
    -e "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" \
    -e "s|{{PROJECT_DESCRIPTION}}|$PROJECT_DESCRIPTION|g" \
    -e "s|{{HUB_REPO}}|$HUB_REPO|g" \
    -e "s|{{DATE}}|$DATE|g" \
    -e "s|{{ADMIN_EMAIL}}|$ADMIN_EMAIL|g" \
    -e "s|{{SESSION_MAP}}|$(echo -e "$SESSION_MAP")|g" \
    -e "s|{{PRODUCTION_URLS}}|$(echo -e "$PROD_URLS")|g" \
    "$file"
}

# Hub CLAUDE.md
cp "$TEMPLATES_DIR/CLAUDE.md" "$OUTPUT_DIR/CLAUDE.md"
sub "$OUTPUT_DIR/CLAUDE.md"

# Session files
for session in "${SESSIONS[@]}"; do
  src="$TEMPLATES_DIR/sessions/$session-session.md"
  dst="$OUTPUT_DIR/docs/sessions/$session-session.md"
  cp "$src" "$dst"
  # Substitute repo-specific vars
  for key in backend web ios android cli; do
    [ -n "${REPOS[$key]}" ] && sed -i "s|{{${key^^}_REPO}}|${REPOS[$key]}|g" "$dst"
    [ -n "${LINT_CMDS[$key]}" ] && sed -i "s|{{LINT_TEST_CMD}}|${LINT_CMDS[$key]}|g" "$dst"
  done
  sub "$dst"
done

# sessions/README.md
cat > "$OUTPUT_DIR/docs/sessions/README.md" << EOF
# Session Work Queues

One file per active Claude Code session. Each file answers: **"What should I be doing right now?"**

| File | Session | Repo |
|------|---------|------|
$(for session in "${SESSIONS[@]}"; do
  repo="${REPOS[$session]:-cross-repo}"
  [ "$session" = "planning" ] && repo="$HUB_REPO"
  [ "$session" = "qa" ] && repo="cross-repo"
  echo "| \`$session-session.md\` | ${session^} | \`$repo\` |"
done)

**PM session** maintains all files. Sessions read their file at the start of every session and signal changes via the backlog.
EOF

# archive .gitkeep
touch "$OUTPUT_DIR/docs/sessions/archive/.gitkeep"

# epics + tests READMEs
cp "$TEMPLATES_DIR/../examples/README.md" /dev/null || true  # ignore missing
cat > "$OUTPUT_DIR/docs/epics/README.md" << 'EOF'
# Epics

One file per epic: `e{N}-{slug}.md`

Frontmatter:
```yaml
---
epic: N
title: "Epic Title"
milestone: "launch | post-launch"
status: "draft | in_progress | done"
stories_total: 0
stories_done: 0
---
```
EOF

cat > "$OUTPUT_DIR/docs/tests/README.md" << 'EOF'
# Test Cases

One file per epic, mirroring `docs/epics/` naming. QA session writes test cases here.
All testing is against production URLs — never localhost.
EOF

# .gitignore
echo ".DS_Store" > "$OUTPUT_DIR/.gitignore"

# ── Generate code repo CLAUDE.md files ───────────────────────────────────────

CODE_CLAUDE_DIR="$OUTPUT_DIR/_code-repo-claudes"
mkdir -p "$CODE_CLAUDE_DIR"

for session in "${SESSIONS[@]}"; do
  case "$session" in planning|qa) continue ;; esac

  repo="${REPOS[$session]}"
  role="${REPO_ROLES[$session]}"
  lint="${LINT_CMDS[$session]:-run your stack's lint + test command}"

  case "$session" in
    ios)     persona="bmad-agent-dev — Swift / SwiftUI" ;;
    android) persona="bmad-agent-dev — Kotlin / Jetpack Compose" ;;
    *)       persona="bmad-agent-dev" ;;
  esac

  case "$session" in
    ios|android)
      extra_step="3. GPS / device stories require a **physical device** — simulator insufficient\n"
      step_num=4
      ;;
    *)
      extra_step=""
      step_num=3
      ;;
  esac

  cat > "$CODE_CLAUDE_DIR/$repo-CLAUDE.md" << EOF
# $PROJECT_NAME — ${session^} Session

**Session file:** \`../$HUB_REPO/docs/sessions/$session-session.md\` — read this first.

## Quick context

- **Project:** $PROJECT_NAME — $PROJECT_DESCRIPTION
- **Repo role:** $role
- **Persona:** \`$persona\`

## Kickoff

> You are the $session session for $PROJECT_NAME. Use the \`bmad-agent-dev\` persona. Read \`../$HUB_REPO/docs/sessions/$session-session.md\` first, then implement the top priority story using \`/bmad-dev-story\`.

## Story workflow

1. Read spec in \`../$HUB_REPO/docs/epics/e{N}-*.md\`
2. Invoke \`/bmad-dev-story\` with the story file path
$([ -n "$extra_step" ] && printf '%s' "$extra_step")$step_num. \`$lint\`
$((step_num+1)). Add QA test cases to \`../$HUB_REPO/docs/tests/e{N}-*.md\`
$((step_num+2)). Add ready-to-test entry to \`../$HUB_REPO/docs/sessions/qa-session.md\`
$((step_num+3)). Push
EOF
done

# ── Init git ──────────────────────────────────────────────────────────────────

cd "$OUTPUT_DIR"
git init -q
git add -A
git commit -q -m "init: $PROJECT_NAME hub (BMad session scaffold)"

# ── Summary ───────────────────────────────────────────────────────────────────

echo
echo "$(green '✓ Done!')"
echo
echo "$(bold 'Hub created at:') $OUTPUT_DIR"
echo
echo "$(bold 'Sessions generated:')"
for s in "${SESSIONS[@]}"; do echo "  • $s-session.md"; done
echo
if [ -d "$CODE_CLAUDE_DIR" ] && [ "$(ls -A "$CODE_CLAUDE_DIR")" ]; then
  echo "$(bold 'CLAUDE.md files for code repos:') $(dim '_code-repo-claudes/')"
  for f in "$CODE_CLAUDE_DIR"/*.md; do
    echo "  → copy $(basename "$f") to $(basename "$f" -CLAUDE.md)/CLAUDE.md"
  done
  echo
fi
echo "$(bold 'Next steps:')"
echo "  1. Replace placeholder URLs in docs/sessions/qa-session.md"
echo "  2. Install BMad: run the BMad installer in $OUTPUT_DIR"
echo "  3. Copy each file in _code-repo-claudes/ to its code repo as CLAUDE.md"
echo "  4. Push to GitHub and enable 'Template repository' in repo settings"
echo "  5. Start your first planning session: open Claude Code in $OUTPUT_DIR"
