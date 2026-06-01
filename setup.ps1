# BMad Hub Setup (PowerShell)
# Creates a project hub repo with the right session files for your architecture.
# Run from the directory where you want the hub repo created.
#
# Usage:
#   .\setup.ps1
#
# Requirements: Git, PowerShell 5.1+ (built into Windows 10/11)

$ErrorActionPreference = "Stop"

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$TemplatesDir = Join-Path $ScriptDir "templates"
$Date        = Get-Date -Format "yyyy-MM-dd"

# ── Helpers ───────────────────────────────────────────────────────────────────

function Prompt-Input {
    param([string]$Label, [string]$Default = "")
    $hint = if ($Default) { " [$Default]" } else { "" }
    $val = Read-Host "$Label$hint"
    if ($val -eq "") { $Default } else { $val }
}

function Confirm-Input {
    param([string]$Label)
    $val = Read-Host "$Label [y/N]"
    $val -match "^[Yy]$"
}

function Sub-Placeholders {
    param([string]$File, [hashtable]$Vars)
    $content = Get-Content $File -Raw -Encoding UTF8
    foreach ($key in $Vars.Keys) {
        $content = $content -replace [regex]::Escape("{{$key}}"), $Vars[$key]
    }
    Set-Content $File -Value $content -Encoding UTF8 -NoNewline
}

# ── Collect project info ──────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== BMad Hub Setup ===" -ForegroundColor Cyan
Write-Host "Creates a planning hub repo with session files for your architecture."
Write-Host ""

$ProjectName      = Prompt-Input "Project name"
$ProjectDesc      = Prompt-Input "One-line description"
$HubRepo          = Prompt-Input "Hub repo name" ($ProjectName -replace ' ', '-' + "-hub")
$OutputDir        = Prompt-Input "Output directory" ".\$HubRepo"

# ── Choose architecture ───────────────────────────────────────────────────────

Write-Host ""
Write-Host "Architecture preset:" -ForegroundColor Cyan
Write-Host "  1) Web only          - planning, web, qa"
Write-Host "  2) API + Web         - planning, backend, web, qa"
Write-Host "  3) API + Mobile      - planning, backend, ios, android, qa"
Write-Host "  4) API + iOS only    - planning, backend, ios, qa"
Write-Host "  5) Full stack        - planning, backend, web, ios, android, qa"
Write-Host "  6) iOS only          - planning, ios, qa"
Write-Host "  7) Android only      - planning, android, qa"
Write-Host "  8) Mobile only       - planning, ios, android, qa"
Write-Host "  9) Custom            - choose individual sessions"
Write-Host ""
$Preset = Read-Host "Choice [1-9]"

$Sessions = [System.Collections.Generic.List[string]]@("planning", "qa")

switch ($Preset) {
    "1" { $Sessions.AddRange(@("web")) }
    "2" { $Sessions.AddRange(@("backend", "web")) }
    "3" { $Sessions.AddRange(@("backend", "ios", "android")) }
    "4" { $Sessions.AddRange(@("backend", "ios")) }
    "5" { $Sessions.AddRange(@("backend", "web", "ios", "android")) }
    "6" { $Sessions.AddRange(@("ios")) }
    "7" { $Sessions.AddRange(@("android")) }
    "8" { $Sessions.AddRange(@("ios", "android")) }
    "9" {
        Write-Host ""
        Write-Host "Select sessions (y/n for each):" -ForegroundColor Cyan
        foreach ($s in @("backend", "web", "ios", "android", "cli")) {
            if (Confirm-Input "  Include $s session?") { $Sessions.Add($s) }
        }
    }
    default { Write-Host "Invalid — defaulting to API + Web."; $Sessions.AddRange(@("backend", "web")) }
}

# ── Collect repo names ────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Repo names for each session:" -ForegroundColor Cyan

$Repos     = @{}
$RepoRoles = @{}
$LintCmds  = @{}

$ProjectSlug = $ProjectName.ToLower() -replace '[^a-z0-9]', '-'

foreach ($session in $Sessions) {
    switch ($session) {
        "backend" {
            $Repos["backend"]     = Prompt-Input "  Backend repo name" "$ProjectSlug-backend"
            $LintCmds["backend"]  = Prompt-Input "  Backend lint+test command" "go test ./... && golangci-lint run"
            $RepoRoles["backend"] = "API server"
        }
        "web" {
            $Repos["web"]         = Prompt-Input "  Web repo name" "$ProjectSlug-web"
            $LintCmds["web"]      = Prompt-Input "  Web lint+test command" "npm run check"
            $RepoRoles["web"]     = "Web frontend"
        }
        "ios" {
            $Repos["ios"]         = Prompt-Input "  iOS repo name" "$ProjectSlug-ios"
            $RepoRoles["ios"]     = "iOS native app"
        }
        "android" {
            $Repos["android"]     = Prompt-Input "  Android repo name" "$ProjectSlug-android"
            $RepoRoles["android"] = "Android native app"
        }
        "cli" {
            $Repos["cli"]         = Prompt-Input "  CLI repo name" "$ProjectSlug-cli"
            $LintCmds["cli"]      = Prompt-Input "  CLI lint+test command" "go test ./... && golangci-lint run"
            $RepoRoles["cli"]     = "CLI tool"
        }
    }
}

$AdminEmail = Prompt-Input "Admin/test email" "admin@example.com"

# ── Build session map for hub CLAUDE.md ──────────────────────────────────────

$SessionMapLines = @(
    "| Session | File | Repo |",
    "|---------|------|------|",
    "| Planning | ``docs/sessions/planning-session.md`` | ``$HubRepo`` |"
)
foreach ($s in $Sessions) {
    if ($s -in @("planning", "qa")) { continue }
    $title = (Get-Culture).TextInfo.ToTitleCase($s)
    $repo  = $Repos[$s]
    $SessionMapLines += "| $title | ``docs/sessions/$s-session.md`` | ``$repo`` |"
}
$SessionMapLines += "| QA | ``docs/sessions/qa-session.md`` | cross-repo |"
$SessionMap = $SessionMapLines -join "`n"

# ── Build QA production URL table ────────────────────────────────────────────

$ProdUrlLines = @()
foreach ($s in $Sessions) {
    switch ($s) {
        "backend" { $ProdUrlLines += "| API | ``https://api.example.com`` |" }
        "web"     { $ProdUrlLines += "| Web | ``https://app.example.com`` |" }
    }
}
if ($ProdUrlLines.Count -eq 0) { $ProdUrlLines = @("| App | ``https://example.com`` |") }
$ProdUrls = $ProdUrlLines -join "`n"

# ── Scaffold output directory ─────────────────────────────────────────────────

Write-Host ""
Write-Host "Creating hub at $OutputDir..." -ForegroundColor Cyan

$Dirs = @(
    "$OutputDir\docs\sessions\archive",
    "$OutputDir\docs\epics",
    "$OutputDir\docs\tests"
)
foreach ($d in $Dirs) { New-Item -ItemType Directory -Force -Path $d | Out-Null }

# Common substitution vars
$CommonVars = @{
    PROJECT_NAME        = $ProjectName
    PROJECT_DESCRIPTION = $ProjectDesc
    HUB_REPO            = $HubRepo
    DATE                = $Date
    ADMIN_EMAIL         = $AdminEmail
    SESSION_MAP         = $SessionMap
    PRODUCTION_URLS     = $ProdUrls
}

# Hub CLAUDE.md
Copy-Item "$TemplatesDir\CLAUDE.md" "$OutputDir\CLAUDE.md"
Sub-Placeholders "$OutputDir\CLAUDE.md" $CommonVars

# Session files
foreach ($session in $Sessions) {
    $src = "$TemplatesDir\sessions\$session-session.md"
    $dst = "$OutputDir\docs\sessions\$session-session.md"
    Copy-Item $src $dst

    $vars = $CommonVars.Clone()
    foreach ($key in $Repos.Keys) {
        $vars["${key.ToUpper()}_REPO"] = $Repos[$key]
    }
    foreach ($key in $LintCmds.Keys) {
        $vars["LINT_TEST_CMD"] = $LintCmds[$key]
    }
    Sub-Placeholders $dst $vars
}

# sessions/README.md
$SessionReadmeRows = foreach ($s in $Sessions) {
    $repo = if ($s -eq "planning") { $HubRepo } elseif ($s -eq "qa") { "cross-repo" } else { $Repos[$s] }
    $title = (Get-Culture).TextInfo.ToTitleCase($s)
    "| ``$s-session.md`` | $title | ``$repo`` |"
}
@"
# Session Work Queues

One file per active Claude Code session. Each file answers: **"What should I be doing right now?"**

| File | Session | Repo |
|------|---------|------|
$($SessionReadmeRows -join "`n")

**PM session** maintains all files. Sessions read their file at the start of every session and signal changes via the backlog.
"@ | Set-Content "$OutputDir\docs\sessions\README.md" -Encoding UTF8

# archive .gitkeep
New-Item -ItemType File -Force "$OutputDir\docs\sessions\archive\.gitkeep" | Out-Null

# epics README
@'
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
'@ | Set-Content "$OutputDir\docs\epics\README.md" -Encoding UTF8

# tests README
@'
# Test Cases

One file per epic, mirroring `docs/epics/` naming. QA session writes test cases here.
All testing is against production URLs — never localhost.
'@ | Set-Content "$OutputDir\docs\tests\README.md" -Encoding UTF8

# .gitignore
".DS_Store`nThumbs.db`ndesktop.ini" | Set-Content "$OutputDir\.gitignore" -Encoding UTF8

# ── Generate code repo CLAUDE.md files ───────────────────────────────────────

$CodeClaudeDir = "$OutputDir\_code-repo-claudes"
New-Item -ItemType Directory -Force $CodeClaudeDir | Out-Null

foreach ($session in $Sessions) {
    if ($session -in @("planning", "qa")) { continue }

    $repo  = $Repos[$session]
    $role  = $RepoRoles[$session]
    $lint  = if ($LintCmds[$session]) { $LintCmds[$session] } else { "run your stack's lint + test command" }
    $title = (Get-Culture).TextInfo.ToTitleCase($session)

    $persona = switch ($session) {
        "ios"     { "bmad-agent-dev - Swift / SwiftUI" }
        "android" { "bmad-agent-dev - Kotlin / Jetpack Compose" }
        default   { "bmad-agent-dev" }
    }

    $deviceNote = if ($session -in @("ios", "android")) {
        "`n3. GPS / device stories require a **physical device** — simulator insufficient"
    } else { "" }

    $stepBase = if ($session -in @("ios", "android")) { 4 } else { 3 }

    @"
# $ProjectName — $title Session

**Session file:** ``../$HubRepo/docs/sessions/$session-session.md`` — read this first.

## Quick context

- **Project:** $ProjectName — $ProjectDesc
- **Repo role:** $role
- **Persona:** ``$persona``

## Kickoff

> You are the $session session for $ProjectName. Use the ``bmad-agent-dev`` persona. Read ``../$HubRepo/docs/sessions/$session-session.md`` first, then implement the top priority story using ``/bmad-dev-story``.

## Story workflow

1. Read spec in ``../$HubRepo/docs/epics/e{N}-*.md``
2. Invoke ``/bmad-dev-story`` with the story file path$deviceNote
$stepBase. ``$lint``
$($stepBase + 1). Add QA test cases to ``../$HubRepo/docs/tests/e{N}-*.md``
$($stepBase + 2). Add ready-to-test entry to ``../$HubRepo/docs/sessions/qa-session.md``
$($stepBase + 3). Push
"@ | Set-Content "$CodeClaudeDir\$repo-CLAUDE.md" -Encoding UTF8
}

# ── Init git ──────────────────────────────────────────────────────────────────

Push-Location $OutputDir
git init -q
git add -A
git commit -q -m "init: $ProjectName hub (BMad session scaffold)"
Pop-Location

# ── Summary ───────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""
Write-Host "Hub created at: $OutputDir" -ForegroundColor Cyan
Write-Host ""
Write-Host "Sessions generated:" -ForegroundColor Cyan
foreach ($s in $Sessions) { Write-Host "  - $s-session.md" }
Write-Host ""

$claudeFiles = Get-ChildItem "$CodeClaudeDir\*.md" -ErrorAction SilentlyContinue
if ($claudeFiles) {
    Write-Host "CLAUDE.md files for code repos: _code-repo-claudes\" -ForegroundColor Cyan
    foreach ($f in $claudeFiles) {
        $repoName = $f.Name -replace '-CLAUDE\.md$', ''
        Write-Host "  -> copy $($f.Name) to $repoName\CLAUDE.md"
    }
    Write-Host ""
}

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Replace placeholder URLs in docs\sessions\qa-session.md"
Write-Host "  2. Install BMad: run the BMad installer in $OutputDir"
Write-Host "  3. Copy each file in _code-repo-claudes\ to its code repo as CLAUDE.md"
Write-Host "  4. Push to GitHub and enable 'Template repository' in repo settings"
Write-Host "  5. Start your first planning session: open Claude Code in $OutputDir"
