-- Competitive programming helper: load the C++ template into the buffer.
-- No plugin, no dependency.
--
-- Compiling and running is done in the shell, not here:
--   g++ -std=c++23 -O2 -Wall -DLOCAL yo.cpp -o yo && ./yo < input.txt

local M = {}

local template = vim.fn.expand('~/Github/cp-setup/template.cpp')

function M.insert_template()
  if vim.fn.filereadable(template) == 0 then
    vim.notify('No template at ' .. template, vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.readfile(template))
end

vim.api.nvim_create_user_command('CpTemplate', M.insert_template, { desc = 'Insert the CP C++ template' })

vim.keymap.set('n', '<leader>rt', M.insert_template, { desc = 'CP: insert template' })

return M
