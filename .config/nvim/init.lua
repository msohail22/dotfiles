-- Line numbers.
-- number       = show the real line number on the cursor line.
-- relativenumber = show every other line's distance from the cursor,
--                  so a line marked 7 is reached with 7k or 7j.
-- Both together give the "hybrid" gutter, the same as
-- copy-mode-line-numbers hybrid in tmux.conf.
vim.opt.number = true
vim.opt.relativenumber = true

-- Plugins. `vim.pack` is Neovim 0.12's built-in manager; it clones into
-- site/pack/core/opt and records revisions in nvim-pack-lock.json next to
-- this file. See `:help vim.pack`.
-- nui.nvim is not optional: noice's README lists it as a requirement.
vim.pack.add({
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',
})

-- noice moves the `:` command line out of the bottom row into a floating box.
-- Its default position is row = "50%" (dead centre); "15%" puts it near the
-- top, close to where the eye already is.
require('noice').setup({
  views = {
    cmdline_popup = {
      position = { row = '15%', col = '50%' },
    },
  },
})
