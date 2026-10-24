-- Line numbers.
-- number       = show the real line number on the cursor line.
-- relativenumber = show every other line's distance from the cursor,
--                  so a line marked 7 is reached with 7k or 7j.
-- Both together give the "hybrid" gutter, the same as
-- copy-mode-line-numbers hybrid in tmux.conf.
vim.opt.number = true
vim.opt.relativenumber = true
