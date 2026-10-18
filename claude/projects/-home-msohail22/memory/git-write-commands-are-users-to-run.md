---
name: git-write-commands-are-users-to-run
description: Never run git add/commit/push during a task; hand Mohammed the exact commands instead.
metadata:
  type: feedback
---

Never run `git add`, `git commit`, `git push`, or any other history- or remote-writing
git command while doing a task. Make only the file changes, then print the exact
commands in one copy-ready block for him to run.

**Why:** he wants to stay the sole author and the only one who writes history. He also
wants to see and approve exactly what lands in a commit before it lands.

**How to apply:** this holds even when the request itself says "and push it" — treat
that as "do the work, then give me the commands". Same for `gh pr create`,
`gh pr merge`, `gh release create`. Read-only inspection (`git --no-pager status`,
`git add -n`) is fine. See also [[modern-git-commands-switch-restore]] and
[[no-claude-attribution-in-commits]].
