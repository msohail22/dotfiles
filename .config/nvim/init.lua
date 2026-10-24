-- ============================================================================
-- Neovim config. One file on purpose. Every line is explainable.
-- Plugin budget: 5 (see docs/superpowers/specs/2026-10-17-nvim-from-scratch-design.md)
-- Used: nui, noice, matteblack, fzf-lua, gitsigns = 5 of 5. Full.
-- ============================================================================

-- Leader must be set before any keymap that uses <leader>.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- === Options ================================================================

-- number         = show the real line number on the cursor line.
-- relativenumber = show every other line's distance from the cursor,
--                  so a line marked 7 is reached with 7k or 7j.
-- Both together give the "hybrid" gutter, the same as
-- copy-mode-line-numbers hybrid in tmux.conf.
vim.opt.number = true
vim.opt.relativenumber = true

-- Suggestions appear as you type, no key press needed. `:help 'autocomplete'`
vim.opt.autocomplete = true

-- === Plugins ================================================================
-- `vim.pack` is Neovim 0.12's built-in manager; it clones into
-- site/pack/core/opt and records revisions in nvim-pack-lock.json next to
-- this file. See `:help vim.pack`.
-- nui.nvim is not optional: noice's README lists it as a requirement.
vim.pack.add({
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/noice.nvim',
  'https://github.com/tahayvr/matteblack.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
})

-- === Colours ================================================================
-- matteblack: the scheme from the old LazyVim config, recovered from git.
vim.cmd.colorscheme('matteblack')

-- matteblack paints several groups with bg2 (#333333), which is almost
-- invisible on its near-black background. Repaint them. Carried over from the
-- old readable-contrast.lua; the Snacks/NeoTree/WhichKey groups are dropped
-- because those plugins are gone.
local dim = '#8A8A8D' -- comment grey - muted but readable
local muted = '#A3A3A3' -- path / secondary text
local soft = '#737373' -- quieter chrome (indent, separators)

local function set_contrast()
  local hl = function(name, opts) vim.api.nvim_set_hl(0, name, opts) end
  hl('NonText', { fg = dim })
  hl('EndOfBuffer', { fg = soft })
  hl('Whitespace', { fg = soft })
  hl('Conceal', { fg = dim })
  hl('LineNr', { fg = dim })
  hl('LineNrAbove', { fg = dim })
  hl('LineNrBelow', { fg = dim })
  hl('FoldColumn', { fg = dim })
  hl('SignColumn', { fg = dim })
  hl('WinSeparator', { fg = muted })
  hl('FloatBorder', { fg = muted })
  -- Inline blame, amber to match the matteblack accent.
  hl('GitSignsCurrentLineBlame', { fg = '#E68E0D', italic = true })
end

set_contrast()
-- A colorscheme command resets every highlight, so reapply after one runs.
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('readable_contrast', { clear = true }),
  callback = set_contrast,
})

-- === Command line ===========================================================
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

-- === Finding things =========================================================
-- fzf-lua needs no other plugin; it drives the fzf, fd and rg binaries that
-- are already installed. Mnemonic: f=find, g=grep, b=buffer, h=help.
-- --no-mouse: a stray click used to multi-select, and Enter on several files
-- dumps them into the quickfix list instead of opening one. Keyboard only.
require('fzf-lua').setup({
  fzf_opts = { ['--no-mouse'] = true },
})

local map = vim.keymap.set
map('n', '<leader>f', '<cmd>FzfLua files<cr>', { desc = 'Find file by name' })
map('n', '<leader>g', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep the project' })
map('n', '<leader>b', '<cmd>FzfLua buffers<cr>', { desc = 'Switch open file' })
map('n', '<leader>h', '<cmd>FzfLua helptags<cr>', { desc = 'Search the help' })

-- === Git ====================================================================
-- Change marks in the sign column, plus VS Code style inline blame.
require('gitsigns').setup({
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 300,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
})

map('n', '<leader>gb', function() require('gitsigns').blame_line({ full = true }) end,
  { desc = 'Blame this line, full' })
map('n', '<leader>gB', function() require('gitsigns').toggle_current_line_blame() end,
  { desc = 'Toggle inline blame' })
map('n', '<leader>gp', function() require('gitsigns').preview_hunk() end,
  { desc = 'Preview this change' })
map('n', '<leader>gr', function() require('gitsigns').reset_hunk() end,
  { desc = 'Undo this change' })
map('n', ']c', function() require('gitsigns').nav_hunk('next') end,
  { desc = 'Next change' })
map('n', '[c', function() require('gitsigns').nav_hunk('prev') end,
  { desc = 'Previous change' })

-- === Language servers =======================================================
-- Neovim ships no server configs, so each one is declared here in full.
-- `cmd` is the program, `filetypes` is when to start it, and `root_markers`
-- is the file that tells the server where the project begins.
-- Defaults Neovim already gives us (`:help lsp-defaults`): K for hover,
-- grn rename, gra code action, grr references, gri implementation,
-- CTRL-] go to definition, and diagnostics shown automatically.

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.config('vtsls', {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'javascript', 'javascriptreact',
    'typescript', 'typescriptreact',
  },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
})

vim.lsp.enable({ 'clangd', 'vtsls' })

-- Completion sourced from the running server, triggered as you type.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_completion', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Diagnostics: jump through the errors in this file.
map('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show this error' })
map('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { desc = 'Next error' })
map('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { desc = 'Previous error' })
