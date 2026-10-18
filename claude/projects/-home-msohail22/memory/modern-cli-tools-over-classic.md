---
name: modern-cli-tools-over-classic
description: Prefer rg/fd/sd/jq/bat/eza/difft/xh etc. over grep/find/sed/cat/ls/diff/curl.
metadata:
  type: feedback
---

Use the modern CLI tools, not the classic ones: `rg`, `fd`, `ast-grep`, `sd`, `jq`,
`yq`, `mlr`, `bat --plain`, `eza --tree`, `difft`, `xh`, `gh`, `just`, `uv`, `pnpm`,
`hyperfine`, `tokei`, `dust`, `duf`, `procs`, `watchexec`, `tldr`.

Navigate with `zoxide`, never `cd`. The `z` function exists only in his interactive
shell, so from a non-interactive agent shell call the binary:
`cd "$(zoxide query <term>)"`. `zoxide query -l <term>` lists all matches.

Never run an interactive tool — `fzf`, `htop`, `top`, `less`, `vim`, `nvim`, `man` wait
for a key press and hang the agent. Disable pagers (`git --no-pager`, `PAGER=cat`).

**Why:** cleaner and more structured output means fewer misreads, and interactive tools
cannot be driven by an agent at all.

**How to apply:** the full table is in `~/Github/dotfiles/claude/CLAUDE.md` under
"Tools", and `settings.json` denies the interactive ones. See
[[modern-git-commands-switch-restore]] and [[dotfiles-is-source-of-truth]].
