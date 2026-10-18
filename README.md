# dotfiles

Configuration for Arch / Omarchy. Two things live here:

| Path in repository | Symlinked to | What it is |
|---|---|---|
| `.config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | tmux configuration |
| `claude/` | `~/.claude` | Claude Code configuration (whole folder) |
| `.zshrc` | `~/.zshrc` | zsh configuration |

## Rule

Edit the files **in this repository**. Never edit through `~/.claude` or
`~/.config/tmux`. Those paths are symlinks into this repository, so a change through
them edits the same bytes, but the repository is the source of truth and the place that
gets committed.

## New machine

    git clone git@github.com:msohail22/dotfiles.git ~/Github/dotfiles
    cd ~/Github/dotfiles
    ./install.sh

`install.sh` creates the symlinks and installs the command line tools. Then read
`claude/MANIFEST.md` for the plugins, which must be installed by hand from inside
Claude Code.

## What is NOT in here

Secrets and machine state are gitignored: `claude/.credentials.json`,
`claude/history.jsonl`, `claude/projects/`, `claude/plugins/`, `claude/skills/synced/`
and the caches. See `claude/.gitignore`.

API keys are never in `.zshrc`. They live in `~/.config/claude-code/providers.env`,
which is outside this repository and has mode 600. `.zshrc` only sources it if it
exists, so a machine without the file still starts a working shell.
