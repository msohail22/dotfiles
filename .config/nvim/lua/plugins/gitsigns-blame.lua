-- Inline git blame (VS Code / GitLens style) via LazyVim's gitsigns
--
-- Blame text uses GitSignsCurrentLineBlame, which otherwise links to NonText
-- (#333333 on matteblack) and is nearly invisible. Pick one fg below:
--   #A3A3A3  soft gray (default) — readable, not loud
--   #8A8A8D  comment gray — subtler
--   #BEBEBE  light gray — brighter
--   #E68E0D  amber accent — matches matteblack / omarchy accent
--   #1EA7A0  teal — distinct from code
--   #3B82F6  blue
local blame_fg = "#E68E0D"

local function set_blame_hl()
  vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
    fg = blame_fg,
    italic = true,
  })
end

set_blame_hl()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("gitsigns_blame_hl", { clear = true }),
  callback = set_blame_hl,
})

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- end of line
      delay = 300,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
  },
  keys = {
    {
      "<leader>gB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Toggle Inline Blame",
    },
  },
}
