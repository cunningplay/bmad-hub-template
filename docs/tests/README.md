# Test Cases

One file per epic. QA session writes test cases here after stories complete.

## Naming

`e{N}-{slug}.md` — mirrors the epic file name.

## Format

Each test file documents:
- AC reference (which acceptance criterion is being tested)
- Steps to reproduce
- Expected result
- Actual result (on test run)
- Pass / Fail / Blocked status

## QA rule

All testing is against **production URLs** — never localhost. See `docs/sessions/qa-session.md` for credentials and URLs.
