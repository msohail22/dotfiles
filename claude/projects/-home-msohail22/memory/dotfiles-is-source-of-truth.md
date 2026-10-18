---
name: dotfiles-is-source-of-truth
description: ~/.claude and tmux config are symlinks into ~/Github/dotfiles; always edit the repo.
metadata:
  type: project
---

Set up on 2026-10-19. `~/Github/dotfiles` holds two things, both symlinked into place:

- `claude/` -> `~/.claude` (whole folder; secrets and caches gitignored)
- `.config/tmux/tmux.conf` -> `~/.config/tmux/tmux.conf`

Always edit the file **in the repo** and name the repo path when reporting. Never edit
through `~/.claude`. `install.sh` rebuilds symlinks and installs the CLI tools on a new
machine; `claude/MANIFEST.md` lists skills and plugins that git does not carry.

**Why:** he wants to reproduce the whole setup on another computer by cloning and
symlinking, so anything edited outside the repo is lost work.

**How to apply:** see [[read-docs-before-acting]] and
[[git-write-commands-are-users-to-run]] — he commits the repo himself.
