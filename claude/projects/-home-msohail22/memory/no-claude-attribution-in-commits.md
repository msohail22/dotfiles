---
name: no-claude-attribution-in-commits
description: No Co-Authored-By Claude or "Generated with Claude Code" anywhere; attribution:false is set.
metadata:
  type: feedback
---

Never add `Co-Authored-By: Claude`, "Generated with Claude Code", a robot emoji, or any
similar line to a commit message, PR title, PR body, issue, or comment. All work is
authored by Mohammed Sohail only; write in his voice.

Enforced in config too: `~/Github/dotfiles/claude/settings.json` sets
`"attribution": false`. The older key `includeCoAuthoredBy` is deprecated since Claude
Code v2.0.62 — do not use it.

**Why:** the code must read as entirely his own work.

**How to apply:** pair with [[git-write-commands-are-users-to-run]] — he runs the
commits, and the messages handed to him must already be attribution-free.
