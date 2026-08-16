-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require('config.remote_clipboard').setup()
vim.opt.relativenumber = false
vim.g.autoformat = false

-- Prefer Dadbod UI notify + don't auto-run huge queries on save
vim.g.db_ui_use_nvim_notify = true
vim.g.db_ui_execute_on_save = false
