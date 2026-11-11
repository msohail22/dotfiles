-- Harpoon 2: absolute jumps between the files of the CP three-pane layout.
--
-- Why `select` is overridden. The stock default ends with
--   vim.api.nvim_set_current_buf(bufnr)
-- at lua/harpoon/config.lua:131, verified with:
--   rg -n -A14 'select = function' ~/.local/share/nvim/lazy/harpoon/lua/harpoon/config.lua
-- That swaps the buffer in whatever window the cursor is in. It never moves to
-- a window already showing the file, so a jump taken from the input.txt pane
-- replaces input.txt with the source and the three-pane layout is gone.
--
-- So: if a window on this tab already shows the target, move the cursor there.
-- Open it only when no window has it.
--
-- Signature, from the harpoon2 README:
--   select? (fun(list_item?: HarpoonListItem, list: HarpoonList, options: any?): nil)

return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup({
      settings = {
        -- Write the list to disk when the menu closes, so the marks survive
        -- a restart. Both default to false.
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      default = {
        select = function(list_item, _, options)
          if list_item == nil then return end
          options = options or {}

          -- Harpoon stores paths relative to get_root_dir (cwd by default).
          -- :p makes it absolute so the comparison below is reliable.
          local target = vim.fs.normalize(vim.fn.fnamemodify(list_item.value, ':p'))

          -- The harpoon menu passes {split=}, {vsplit=} or {tabedit=} through
          -- ui.lua:191 -> list:select(idx, options). Only the stock select read
          -- them (config.lua:123-128), so an override that ignores options
          -- makes those keys do nothing at all, with no error. Asking for a
          -- split means "give me a new window", so reuse is skipped.
          local wants_new = options.split or options.vsplit or options.tabedit

          if not wants_new then
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
              if name ~= '' and vim.fs.normalize(name) == target then
                vim.api.nvim_set_current_win(win)
                return
              end
            end
          end

          if options.vsplit then
            vim.cmd('vsplit')
          elseif options.split then
            vim.cmd('split')
          elseif options.tabedit then
            vim.cmd('tabedit')
          end

          -- Not on screen, or a new window was just made. Open it and restore
          -- the cursor position harpoon recorded; the reuse path above keeps
          -- the live cursor instead, which is what you want there.
          vim.cmd.edit(vim.fn.fnameescape(target))
          local ctx = list_item.context
          if ctx and ctx.row then
            pcall(vim.api.nvim_win_set_cursor, 0, { ctx.row, ctx.col or 0 })
          end
        end,
      },
    })

    local map = vim.keymap.set
    map('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon: add file' })
    map('n', '<leader>hh', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: menu' })

    for i = 1, 4 do
      map('n', '<leader>' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon: file ' .. i })
    end
  end,
}
