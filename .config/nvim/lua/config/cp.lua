-- Competitive programming helpers: template, compile, run, and a three-pane
-- layout. No plugin, no dependency. Needs nvim 0.10+ for vim.system().
--
-- input.txt and output.txt sit in the SAME folder as the file being edited.
-- So yo.cpp at the repository root uses the root pair, and a problem in
-- Codeforces/2000/ gets its own pair. Nothing is shared by accident.

local M = {}

local template = vim.fn.expand('~/Github/cp-setup/template.cpp')

-- Paths derived from the current buffer, not from the working directory.
-- :p:h is the folder holding the file, so the pair follows the file around.
local function paths()
  local src = vim.fn.expand('%:p')
  if src == '' then return nil end
  local dir = vim.fn.expand('%:p:h')
  return {
    src = src,
    dir = dir,
    bin = dir .. '/' .. vim.fn.expand('%:t:r'),
    input = dir .. '/input.txt',
    output = dir .. '/output.txt',
  }
end

local function ensure(path)
  if vim.fn.filereadable(path) == 0 then vim.fn.writefile({}, path) end
end

-- A file changed on disk by an outside program is not reloaded by itself.
-- :checktime on every window showing it does that, so output.txt updates in
-- place instead of needing the buffer closed and opened.
local function reload(path)
  local bufnr = vim.fn.bufnr(path)
  if bufnr == -1 then return end
  vim.api.nvim_buf_call(bufnr, function() vim.cmd('silent! checktime') end)
end

function M.insert_template()
  if vim.fn.filereadable(template) == 0 then
    vim.notify('No template at ' .. template, vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.readfile(template))
end

-- Compile, then run with input.txt on stdin and stdout into output.txt.
-- Both steps are async: a 2-second g++ must not freeze the editor.
function M.run()
  local p = paths()
  if not p then
    vim.notify('Save the buffer first', vim.log.levels.ERROR)
    return
  end
  vim.cmd('silent! write')
  ensure(p.input)

  -- -DLOCAL turns the dbg() macro on. The judge never sees this flag, so the
  -- debug prints cost nothing there.
  local cc = { 'g++', '-std=c++23', '-O2', '-Wall', '-DLOCAL', p.src, '-o', p.bin }

  vim.system(cc, { text = true }, vim.schedule_wrap(function(cres)
    if cres.code ~= 0 then
      -- Compiler errors go to output.txt too, so one window always holds the
      -- answer to "what happened".
      local lines = vim.split('COMPILE ERROR\n' .. (cres.stderr or ''), '\n')
      vim.fn.writefile(lines, p.output)
      reload(p.output)
      vim.notify('Compile failed', vim.log.levels.ERROR)
      return
    end

    local stdin = table.concat(vim.fn.readfile(p.input), '\n') .. '\n'
    local started = vim.uv.hrtime()

    vim.system({ p.bin }, { text = true, stdin = stdin, timeout = 10000 },
      vim.schedule_wrap(function(rres)
        local ms = math.floor((vim.uv.hrtime() - started) / 1e6)
        local out = vim.split(rres.stdout or '', '\n')

        -- stderr is where dbg() writes. Keep it, but below a marker, so the
        -- real answer is never mixed with debug noise.
        if rres.stderr and rres.stderr ~= '' then
          table.insert(out, '--- stderr (dbg) ---')
          vim.list_extend(out, vim.split(rres.stderr, '\n'))
        end
        if rres.code ~= 0 then
          table.insert(out, 1, ('--- exit code %d ---'):format(rres.code))
        end

        vim.fn.writefile(out, p.output)
        reload(p.output)

        if rres.code == 0 then
          vim.notify(('ran in %d ms'):format(ms), vim.log.levels.INFO)
        else
          vim.notify(('exit %d after %d ms'):format(rres.code, ms), vim.log.levels.WARN)
        end
      end))
  end))
end

function M.open(which)
  local p = paths()
  if not p then return end
  ensure(p[which])
  vim.cmd('vsplit ' .. vim.fn.fnameescape(p[which]))
end

-- source | input
--        | output
function M.layout()
  local p = paths()
  if not p then
    vim.notify('Open a source file first', vim.log.levels.ERROR)
    return
  end
  ensure(p.input)
  ensure(p.output)
  vim.cmd('only')
  vim.cmd('vsplit ' .. vim.fn.fnameescape(p.input))
  vim.cmd('split ' .. vim.fn.fnameescape(p.output))
  -- Back to the source window, because that is where typing happens.
  vim.cmd('wincmd t')
end

vim.api.nvim_create_user_command('CpTemplate', M.insert_template, { desc = 'Insert the CP C++ template' })
vim.api.nvim_create_user_command('CpRun', M.run, { desc = 'Compile and run on input.txt' })
vim.api.nvim_create_user_command('CpLayout', M.layout, { desc = 'Source | input / output panes' })

local map = vim.keymap.set
map('n', '<leader>rt', M.insert_template, { desc = 'CP: insert template' })
map('n', '<leader>rr', M.run, { desc = 'CP: compile and run' })
map('n', '<leader>rl', M.layout, { desc = 'CP: three-pane layout' })
map('n', '<leader>ri', function() M.open('input') end, { desc = 'CP: open input.txt' })
map('n', '<leader>ro', function() M.open('output') end, { desc = 'CP: open output.txt' })

return M
