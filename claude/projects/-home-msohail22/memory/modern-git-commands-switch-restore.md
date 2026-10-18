---
name: modern-git-commands-switch-restore
description: Use git switch and git restore, never git checkout.
metadata:
  type: feedback
---

Use `git switch` to change branches and `git restore` to change files. Never use
`git checkout`.

- `git switch <branch>` / `git switch -c <new>` / `git switch -` / `git switch --detach <commit>`
- `git restore <file>` / `git restore --staged <file>` / `git restore --source=<commit> <file>`

**Why:** `git checkout` does several unrelated jobs with one name, so a small mistake
can silently destroy uncommitted work. Git 2.23 split it on purpose. Verified against
git 2.55.0 on this machine.

**How to apply:** the full table lives in `~/Github/dotfiles/claude/CLAUDE.md` under
"Git commands". Prefer the modern tool generally — see [[modern-cli-tools-over-classic]].
Pair with [[git-write-commands-are-users-to-run]].
