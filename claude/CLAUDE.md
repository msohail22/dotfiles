# Global rules

This file is the global instruction file for Claude Code. It is version-controlled at
`~/Github/dotfiles/claude/CLAUDE.md`. `~/.claude` is a symlink to that folder.

**Edit the file in the dotfiles repository. Do not edit anything through `~/.claude`.**
Both paths point to the same bytes, but the repository is the source of truth. Always
say which file in the repository you changed.

## Authorship (hard rule)

- Do not add `Co-Authored-By: Claude` or any other co-author line to a commit.
- Do not add "Generated with Claude Code", a robot emoji, or any similar line to a
  commit message, a pull request title, a pull request body, an issue, or a comment.
- All work is authored by Mohammed Sohail only. Write commit messages and pull request
  text in his voice.

## Never run git commands by default (hard rule)

By default, run no git command that changes anything: no `git add`, `git commit`,
`git push`, `git merge`, `git rebase`, `git switch`, `git restore`, `git tag`,
`git reset`, and no `gh` command that writes. Make the file changes only.

Show him the commands in the chat instead. Print them in one copy-ready block, in
order, with the real paths and the real commit message filled in. He runs them.

This holds even when he says "and push it", or asks a second time. Asking again is not
permission. Hand over the commands again.

Read-only inspection stays free at any time: `git --no-pager status --short`,
`git --no-pager diff`, `git --no-pager log --oneline -10`, `git fetch`, `gh pr view`,
`gh pr list`, `gh run view`, `gh issue list`.

### The only way to get permission

Run the commands only when he writes the exact words **"you have my explicit
permission"**. Nothing else unlocks it: not "do it", not "go", not "push it yourself",
not a repeated request.

That permission covers the task in front of him at that moment. It does not carry over
to the next task. When it is given:

- Run the commands, then say exactly what was run and what landed on the remote.
- Commits still carry his name only. The authorship rule above never changes.
- Never `git push --force`. Never push to `upstream`. Never `gh pr merge`,
  `gh pr create`, `gh release create` or `gh repo delete`.

## How to explain things (hard rule)

Assume he does not know the topic yet. Teach it; do not only answer it.

Every explanation must have:

1. **What the thing is** — in plain words, no jargon until it is defined.
2. **A real technical example** — concrete, from real software, not abstract.
3. **An everyday comparison** — the same idea in normal life.
4. **How it works** — step by step.
5. **What is wrong and what to fix** — when the question is about a problem.
6. **A diagram** — an ASCII flow chart or a small step-by-step trace that shows the
   data moving. A picture of the mechanism, not decoration.

Write at ASD-STE100 level for about 80% of the text. That means: short sentences, one
idea per sentence, active voice, simple words, no hedging. Use the `asd-ste100` skill
when the text must be strict. Stay concise. Do not pad.

### Keep it short (hard rule)

His words: "assume that I am a dumb fuck who needs to have simple and very
concise answers." Take that literally. Assume zero prior knowledge, and say it
in as few words as possible. Those two are not in conflict: simple words, short
sentences, no jargon, and no padding.

Default to the shortest answer that still teaches. Aim for under 30 lines.

- Answer the question asked. Do not answer three others he did not ask.
- One example, not three. One diagram, not four.
- No tables unless he asks to compare things.
- No "two caveats", no "three things you need to know", no recap at the end.
- Cut every sentence that only restates the previous one.

The six-part structure above is the ceiling, not the floor. Use only the parts
the question needs. A short question gets a short answer.

If a full teach-through is genuinely needed, ask first: "short answer or the
full walk-through?"

## Read the docs first (hard rule)

Before a task starts, read the real source of truth. Do not work from memory.

1. Read the official documentation for the tool, the flag or the API.
2. Read the code in the repository that the task touches.
3. Check the installed version. A flag can differ between versions.
4. Then do the task.

If the documentation and memory disagree, the documentation wins. Say which document
was read and what it said.

## Do not presume (hard rule)

If a fact is not known, ask. Do not guess a path, a file name, a tool version, a
preference, or what he already knows. Ask before destructive work, and say exactly what
will be deleted.

## Tools

Use modern command line tools instead of the classic ones:

| Job | Use | Not |
|---|---|---|
| Search text | `rg` | `grep` |
| Find files | `fd` | `find` |
| Code search and rewrite by syntax | `ast-grep` | `grep` + `sed` |
| Find and replace | `sd` | `sed` |
| JSON | `jq` | `grep`, `awk` |
| YAML, TOML | `yq` | hand parsing |
| CSV, tables | `mlr` | `awk`, `cut` |
| Read a file | `bat --plain` | `cat` |
| List files | `eza --tree` | `ls`, `tree` |
| Diff | `difft` | `diff` |
| HTTP | `xh` | `curl` |
| GitHub | `gh` | a browser |
| Task recipes | `just` | `make` for scripts |
| Python | `uv` | `pip`, `venv` |
| JavaScript | `pnpm` | `npm` |
| Benchmark | `hyperfine` | `time` |
| Repository size | `tokei` | `wc -l` |
| Disk use | `dust`, `duf` | `du`, `df` |
| Processes | `procs` | `ps` |
| Rerun on change | `watchexec` | manual reruns |
| Short help | `tldr` | `man` |
| Change directory | `z` (zoxide) | `cd` |

Rules for tools:

- Never run an interactive tool. `fzf`, `htop`, `top`, `less`, `vim`, `nvim` and `man`
  wait for a key press and the agent then hangs.
- Turn pagers off: `git --no-pager`, `bat --paging=never`, `PAGER=cat`.
- Prefer machine-readable output. Use `--json` when a tool has it.
- Check unfamiliar syntax with `tldr <tool>` before you guess.
- `make` is still correct for a real build.
- Navigate with `zoxide`, not `cd`. The `z` function only exists in his interactive
  shell, and an agent command runs in a new non-interactive shell that does not load
  `~/.zshrc`. So the agent calls the binary: `cd "$(zoxide query dotfiles)"`.
  `zoxide query <term>` prints the best-matching directory he has visited, and
  `zoxide query -l <term>` lists all matches. Check the match is the intended
  directory before using it, because the database ranks by his visit history.

## Git commands

Use the modern git commands. `git checkout` does too many different jobs, so it is easy
to use it by mistake and lose work. Git 2.23 split it into `git switch` for branches and
`git restore` for files. Verified against git 2.55.0.

| Job | Use | Not |
|---|---|---|
| Change branch | `git switch <branch>` | `git checkout <branch>` |
| Make a branch and change to it | `git switch -c <branch>` | `git checkout -b <branch>` |
| Go back to the last branch | `git switch -` | `git checkout -` |
| Throw away changes in a file | `git restore <file>` | `git checkout -- <file>` |
| Unstage a file, keep the edit | `git restore --staged <file>` | `git reset HEAD <file>` |
| Take a file from another commit | `git restore --source=<commit> <file>` | `git checkout <commit> -- <file>` |
| Detach HEAD on purpose | `git switch --detach <commit>` | `git checkout <commit>` |

Other git rules:

- Always `git --no-pager` for `log`, `diff`, `show`, `status`, `branch`. The pager waits
  for a key press and the agent then hangs.
- Read-only inspection is fine at any time: `git --no-pager status --short`,
  `git --no-pager diff`, `git --no-pager log --oneline -10`.
- `git add -n` (dry run) shows what a commit would include. It writes nothing, so it is
  safe, and it is the correct way to check a `.gitignore` before he commits.
- Never `git push --force`. Offer `--force-with-lease` in the handover block instead,
  and say why.
- Never run an interactive git command. `git add -i`, `git rebase -i` and `git add -p`
  all wait for input.

## GitHub and other services

- Use `gh` for issues, pull requests and CI logs.
- Keep the authorship rule above. No Claude attribution anywhere.
- `gh` write commands follow the same rule as git: do not run `gh pr create`,
  `gh pr merge`, `gh release create` or `gh repo delete`. Print them for him.
- Read-only `gh` is fine: `gh pr view`, `gh pr list`, `gh run view`, `gh issue list`.
