---
name: nvim-config-single-file-plan
description: Nvim config is Omarchy's LazyVim since 2026-10-31; the pain gate on new plugins still holds.
metadata:
  type: project
---

Nvim config is **Omarchy's LazyVim**, taken from the `omarchy-nvim` Arch package
(`/usr/share/omarchy-nvim/config`, not the `basecamp/omarchy` repo — that repo no
longer carries `config/nvim`). It lives in `~/Github/dotfiles/.config/nvim/` and
is symlinked into `~/.config/nvim` per top-level entry, with `lua/` linked as a
whole directory. Replaced the 591-line hand-written `vim.pack` config on
2026-10-31; that old single-file plan is void.

`lua/plugins/competitest.lua` carries the competitive programming setup:
Codeforces-matching `g++ -std=c++23 -O2 -Wall`, the `yo.cpp` template,
`$(JUDGE)/$(CONTEST)` receive paths, and `<leader>cs` to archive a solution
under `~/Github/cp-setup/solved/<judge>/`.

**Why:** the hand-written config was more upkeep than it was worth. But the
**pain gate from his design doc still stands**: a plugin or option is added only
after he has hit the problem himself.

**How to apply:** propose, explain, then wait for his word. Never add plugins or
options on your own initiative, LazyVim extras included. Edit the dotfiles copy,
never `~/.config/nvim`. See [[dotfiles-is-source-of-truth]].
