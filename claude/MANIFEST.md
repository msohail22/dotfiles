# Claude Code setup inventory

This file lists everything that is not stored in this repository, so the setup can be
rebuilt on a new machine. `install.sh` in the repository root does the automatic parts.

## Hand-installed skills (tracked here, in `claude/skills/`)

| Skill | Source | What it does |
|---|---|---|
| `asd-ste100` | https://github.com/danyuchn/asd-ste100-skill | Rewrites English into Simplified Technical English so it cannot be misread. |
| `llm-council` | https://github.com/aiwithremy/claude-skills-llm-council | Runs a decision past 5 advisor sub-agents, then peer review, then a verdict. |

Update one with:

    cd ~/Github/dotfiles/claude/skills
    rm -rf asd-ste100 && git clone --depth 1 https://github.com/danyuchn/asd-ste100-skill asd-ste100 && rm -rf asd-ste100/.git

## Plugins (NOT tracked: `plugins/` is gitignored)

`enabledPlugins` and `extraKnownMarketplaces` in `settings.json` ARE tracked, so a new
machine already knows which plugins to turn on. The plugin code itself is not, because
`plugins/` is gitignored, so each one still has to be fetched once.

| Plugin | Marketplace | Install |
|---|---|---|
| research-superpowers | `anthropic-plugin-directory` | `/plugin`, then pick it from the marketplace list |
| vibe-wise | `vibe-wise` (github `nykooi1/vibe-wise`) | `claude plugin marketplace add nykooi1/vibe-wise` then `claude plugin enable vibe-wise@vibe-wise` |

There is no `claude plugin install` subcommand. `marketplace add` plus `enable` is the
non-interactive equivalent, and it writes the same two keys into `settings.json` that
`/plugin install` does, so an agent CAN do it from the shell. Only the interactive
`/plugin` browser needs a human.

Note: `/plugin install superpowers@claude-plugins-official` fails with
"Marketplace claude-plugins-official not found". Use the interactive `/plugin` browser
instead. Installed on 2026-10-19; it adds the research skills and 7 research subagents.

vibe-wise installed on 2026-10-21, version 0.1.44. It adds the `learn` and `reset`
skills and a `SessionStart` hook that restores a project's `.vibe-wise/` notes. Run
`/vibe-wise:learn` in a project to start. Auto-update is off by default for third-party
marketplaces; refresh with `claude plugin marketplace update vibe-wise`.

## Account-synced skills (NOT tracked)

`claude/skills/synced/` is managed by the Claude account and downloads itself. It holds
`docs`, `docx`, `google-workspace`, `import-memory`, `morning`, `pdf`, `pptx`,
`skill-creator`, `xlsx`. Nothing to do on a new machine except sign in.

## Command line tools

See the table in `CLAUDE.md`. `install.sh` installs them with `pacman` on Arch and
Omarchy.
