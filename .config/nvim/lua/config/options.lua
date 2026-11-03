-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

-- Omarchy ships relativenumber = false. Back on: with number on the cursor line
-- and every other line showing its distance, a line marked 7 is reached with 7k
-- or 7j. This is the "hybrid" gutter, the same as copy-mode-line-numbers hybrid
-- in tmux.conf.
vim.opt.number = true
vim.opt.relativenumber = true
vim.g.autoformat = false

-- Four-space indent. LazyVim ships shiftwidth=2, which is fine for Lua but
-- not how competitive programming C++ is written.
--   expandtab   = the Tab key inserts spaces, never a tab character.
--   tabstop     = how wide a tab character already in a file is drawn.
--   shiftwidth  = one indent level; what cindent, >> and << move by.
--   softtabstop = Backspace deletes a whole 4-space indent, not one space.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
