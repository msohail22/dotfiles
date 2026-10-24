-- ============================================================================
-- Neovim config. One file on purpose. Every line is explainable.
-- Scope: C++ only. No TypeScript, no web, no Python tooling.
-- Plugins: nui, noice, matteblack, fzf-lua, gitsigns, nvim-treesitter,
-- vim-dadbod, vim-dadbod-ui, competitest, nvim-dap = 10.
-- The design doc still says "budget 5"; that budget is broken and the doc is
-- stale (docs/superpowers/specs/2026-10-17-nvim-from-scratch-design.md).
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
  -- The rewritten nvim-treesitter lives on the `main` branch and needs 0.12+.
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/xeluxee/competitest.nvim',
  'https://github.com/mfussenegger/nvim-dap',
})

-- === Syntax (treesitter) ====================================================
-- Neovim bundles only c, lua, markdown, query, vim and vimdoc grammars.
-- `install` is async and does nothing if a parser is already there.
-- Highlighting itself comes from Neovim, not the plugin, hence the autocmd.
-- The list is taken from the two C++ repositories actually read on this
-- machine: counts are `git ls-files` extension counts, so nothing here is
-- guessed.
--   llvm-project: .ll 48430  .cpp 39765  .h 17960  .c 14477  .s 13308
--                 .mlir 3352  .py 3128  .td 1847  .cu 351
--   ClickHouse:   .sql 13179  .cpp 5792  .h 5039  .sh 4767  .xml 3132
--                 .py 2728  .cmake 139  .yml/.yaml 270  .proto 62
local parsers = {
  -- The language itself. Headers (.h, .hpp) use the cpp parser too.
  'cpp', 'c', 'cuda',

  -- Compiler output you read while working on LLVM or tuning C++.
  'llvm',                                  -- .ll, LLVM IR
  'asm', 'nasm',                           -- .s hand-written and generated
  'mlir',                                  -- .mlir
  'tablegen',                              -- .td, LLVM's own DSL
  'disassembly', 'objdump',                -- objdump / gdb disassembly output

  -- Build systems. Both repositories are CMake.
  'cmake', 'make', 'ninja',

  -- The scripts around a C++ repository. Not optional: ClickHouse has 4767
  -- shell scripts and 2728 Python ones, LLVM has 3128 Python.
  'bash', 'python',

  -- Data and config these two repositories are full of.
  'sql',                                   -- ClickHouse tests and queries
  'xml',                                   -- ClickHouse server config
  'yaml', 'json', 'toml',
  'proto',
  'dockerfile',

  -- Reading and writing about the code.
  'markdown', 'markdown_inline',
  'doxygen',                               -- /** */ blocks inside C++
  'comment',                               -- TODO / FIXME

  -- Git, which you are in all day.
  'gitcommit', 'gitignore', 'git_config', 'git_rebase', 'diff',

  -- Neovim itself, so this config and its help are highlighted.
  'lua', 'vim', 'vimdoc', 'query',
  'regex',                                 -- noice recommends it
  'ssh_config', 'printf',
}
require('nvim-treesitter').install(parsers)

-- Filetype names and parser names are not the same word (a .sh file has
-- filetype "sh", parser "bash"), so try every filetype and let it fail
-- quietly when no parser exists.
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter_start', { clear = true }),
  pattern = '*',
  callback = function() pcall(vim.treesitter.start) end,
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
-- clangd is the only server. It covers .c, .cpp, .h, .hpp and .cu.

vim.lsp.config('clangd', {
  cmd = { 'clangd', '--background-index', '--clang-tidy' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.enable('clangd')

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

-- Format on save, using whichever language server is attached.
-- No plugin: `:help vim.lsp.buf.format`.
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('format_on_save', { clear = true }),
  callback = function(ev)
    vim.lsp.buf.format({ bufnr = ev.buf, timeout_ms = 2000 })
  end,
})

-- === Databases ==============================================================
-- dadbod does not speak SSH. Open the tunnel in a terminal first:
--   ssh -L 5433:db.internal:5432 -N user@bastion
-- then point the URL at 127.0.0.1:5433 and it behaves like a local database.
--
-- Connections come from two places, neither of which is this file:
--   1. environment variables  DATABASE_URL, DB_DEV_URL, DB_PROD_URL, DB_<NAME>_URL
--   2. ~/.config/nvim/db-secrets.lua  - a real file in a real directory, NOT
--      symlinked into the dotfiles repo, so a password cannot be committed:
--        return {
--          { name = 'tunnel', url = 'postgres://user:pass@127.0.0.1:5433/mydb' },
--        }
local function collect_dbs()
  local dbs, seen = {}, {}
  local function add(name, url)
    if not url or url == '' or seen[name] then return end
    seen[name] = true
    dbs[#dbs + 1] = { name = name, url = url }
  end

  add(vim.env.DBUI_NAME or 'default', vim.env.DATABASE_URL or vim.env.DBUI_URL)
  for key, value in pairs(vim.fn.environ()) do
    local name = key:match('^DB_([%w_]+)_URL$')
    if name then add(name:lower(), value) end
  end

  local ok, secrets = pcall(dofile, vim.fn.expand('~/.config/nvim/db-secrets.lua'))
  if ok and type(secrets) == 'table' then
    for _, conn in ipairs(secrets) do
      if conn.name and conn.url then add(conn.name, conn.url) end
    end
  end

  return dbs
end

local dbs = collect_dbs()
if #dbs > 0 then vim.g.dbs = dbs end

map('n', '<leader>D', '<cmd>DBUIToggle<cr>', { desc = 'Database browser' })

-- === Competitive programming ================================================
-- competitest reuses nui.nvim, already installed for noice.
-- Testcases live beside the source: task-A.cpp -> task-A_input0.txt and
-- task-A_output0.txt, counting from 0. No input.txt/output.txt by hand.
-- `receive` needs the "competitive-companion" browser extension.
-- The default compile command is `g++ -Wall $(FNAME) -o $(FNOEXT)`: no
-- standard and no optimisation, so modern C++ fails to build and a correct
-- solution can still time out. These flags match Codeforces GNU G++23.
require('competitest').setup({
  compile_command = {
    cpp = { exec = 'g++', args = { '-std=c++23', '-O2', '-Wall', '$(FNAME)', '-o', '$(FNOEXT)' } },
  },
  -- Every received problem starts from this file instead of an empty buffer.
  template_file = { cpp = '~/Github/cp-setup/yo.cpp' },
})

map('n', '<leader>cr', '<cmd>CompetiTest run<cr>', { desc = 'Run all testcases' })
map('n', '<leader>ca', '<cmd>CompetiTest add_testcase<cr>', { desc = 'Add a testcase' })
map('n', '<leader>ce', '<cmd>CompetiTest edit_testcase<cr>', { desc = 'Edit a testcase' })
map('n', '<leader>cp', '<cmd>CompetiTest receive problem<cr>', { desc = 'Pull problem from browser' })
map('n', '<leader>cc', '<cmd>CompetiTest receive contest<cr>', { desc = 'Pull whole contest' })

-- === Debugger ===============================================================
-- gdb 17.2 speaks the Debug Adapter Protocol natively with `-i dap`, so there
-- is nothing extra to install for C++.
local dap = require('dap')

dap.adapters.gdb = {
  type = 'executable',
  command = 'gdb',
  args = { '--interpreter', 'dap' },
}

dap.configurations.cpp = {
  {
    name = 'Run this file',
    type = 'gdb',
    request = 'launch',
    -- Debug the compiled binary sitting next to the source, minus the suffix.
    program = function() return vim.fn.expand('%:p:r') end,
    cwd = '${workspaceFolder}',
    stopAtBeginningOfMainSubprogram = true,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.cuda = dap.configurations.cpp

-- Function keys, so nothing collides with the <leader> scheme.
map('n', '<F5>', function() dap.continue() end, { desc = 'Debug: start / continue' })
map('n', '<F9>', function() dap.toggle_breakpoint() end, { desc = 'Debug: breakpoint' })
map('n', '<F10>', function() dap.step_over() end, { desc = 'Debug: step over' })
map('n', '<F11>', function() dap.step_into() end, { desc = 'Debug: step into' })
map('n', '<F12>', function() dap.terminate() end, { desc = 'Debug: stop' })
