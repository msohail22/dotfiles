-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Pin CP files to Harpoon: 1=code, 2=input, 3=output
local function pin_cp_harpoon(src)
  local ok, harpoon = pcall(require, "harpoon")
  if not ok then
    return
  end

  local list = harpoon:list()
  list:clear()

  local root = vim.fn.getcwd()
  for _, file in ipairs({ src, root .. "/input.txt", root .. "/output.txt" }) do
    list:add({
      value = vim.fn.fnamemodify(file, ":."),
      context = { row = 1, col = 0 },
    })
  end
end

-- Competitive programming: 3-pane layout (code | input / output)
vim.keymap.set("n", "<leader>rl", function()
  local root = vim.fn.getcwd()
  local src = vim.fn.expand("%:p")
  if src == "" or not src:match("%.cpp$") then
    src = root .. "/yo.cpp"
  end

  vim.cmd("only")
  vim.cmd("edit " .. vim.fn.fnameescape(src))
  vim.cmd("vsplit " .. vim.fn.fnameescape(root .. "/input.txt"))
  vim.cmd("split " .. vim.fn.fnameescape(root .. "/output.txt"))
  vim.cmd("wincmd h") -- focus code pane

  pin_cp_harpoon(src)
end, { desc = "CP: 3-pane layout" })

local function reload_output_pane()
  local out = vim.fn.fnamemodify(vim.fn.getcwd() .. "/output.txt", ":p")
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    if name ~= "" and vim.fn.fnamemodify(name, ":p") == out then
      vim.api.nvim_buf_call(buf, function()
        vim.cmd("silent checktime")
        -- Force disk reload so the pane updates even if autoread is off
        vim.cmd("silent edit!")
      end)
    end
  end
end

-- Competitive programming: save, compile & run current (or visible) .cpp
-- Uses vim.system so :! does not open a shell_out split and wreck the 3-pane layout
vim.keymap.set("n", "<leader>rr", function()
  local target = "yo"
  local current = vim.fn.expand("%:t")

  if current:match("%.cpp$") then
    target = vim.fn.expand("%:t:r")
  else
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match("%.cpp$") then
        target = vim.fn.fnamemodify(name, ":t:r")
        break
      end
    end
  end

  vim.cmd("wall")

  local root = vim.fn.getcwd()
  vim.notify("CP: building " .. target .. "...", vim.log.levels.INFO)

  vim.system({ "./run.sh", target }, { cwd = root, text = true }, function(obj)
    vim.schedule(function()
      reload_output_pane()
      if obj.code == 0 then
        vim.notify("CP: ran " .. target, vim.log.levels.INFO)
      else
        local err = (obj.stderr ~= "" and obj.stderr) or (obj.stdout ~= "" and obj.stdout) or ("exit " .. tostring(obj.code))
        vim.notify("CP: run failed\n" .. err, vim.log.levels.ERROR)
      end
    end)
  end)
end, { desc = "CP: compile & run" })
