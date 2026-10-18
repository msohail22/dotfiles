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

Install each one from inside Claude Code. The command is typed by the user; an agent
cannot run it.

| Plugin | Install command |
|---|---|
| research-superpowers | `/plugin` then pick `research-superpowers` from the marketplace list |

Note: `/plugin install superpowers@claude-plugins-official` fails with
"Marketplace claude-plugins-official not found". Use the interactive `/plugin` browser
instead. Installed on 2026-10-19; it adds the research skills and 7 research subagents.

## Account-synced skills (NOT tracked)

`claude/skills/synced/` is managed by the Claude account and downloads itself. It holds
`docs`, `docx`, `google-workspace`, `import-memory`, `morning`, `pdf`, `pptx`,
`skill-creator`, `xlsx`. Nothing to do on a new machine except sign in.

## Command line tools

See the table in `CLAUDE.md`. `install.sh` installs them with `pacman` on Arch and
Omarchy.
