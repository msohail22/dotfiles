---
name: nvim-config-single-file-plan
description: Nvim config stays one init.lua; noice.nvim agreed but deferred.
metadata:
  type: project
---

Nvim config (`~/Github/dotfiles/.config/nvim/init.lua`, symlinked as the file
only into `~/.config/nvim`) is to stay a **single file**. No `lua/` module split
unless he asks. Decided 2026-10-24.

`noice.nvim` is agreed as the next plugin — to move the `:` cmdline off the
bottom of the screen (`views.cmdline_popup.position.row`). **Do not add it until
he says so.** Deferred 2026-10-24.

He declined the usual starter options (ignorecase, expandtab, undofile,
scrolloff, etc.). Only `number` + `relativenumber` are set.

**Why:** his design doc at `~/.config/nvim/docs/superpowers/specs/` sets a
plugin budget of 5 and a "pain gate" — a plugin is added only after he has hit
the problem himself. Pre-emptive config is unwelcome.

**How to apply:** propose, explain, then wait. Never add nvim options or plugins
on your own initiative. See [[dotfiles-is-source-of-truth]].
