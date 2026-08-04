return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<C-p>",           function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>fg",      function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader>fb",      function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>fh",      function() require("fzf-lua").help_tags() end, desc = "Help tags" },
      { "<leader>f:",      function() require("fzf-lua").command_history() end, desc = "Command history" },
      { "<leader>fr",      function() require("fzf-lua").resume() end, desc = "Resume" },
      { "<leader>fn",      function() require("fzf-lua").nvim() end, desc = "Neovim config files" },
      { "gr",              function() require("fzf-lua").lsp_references() end, desc = "LSP references" },
      { "gd",              function() require("fzf-lua").lsp_definitions() end, desc = "LSP definitions" },
      { "gi",              function() require("fzf-lua").lsp_implementations() end, desc = "LSP implementations" },
      { "gy",              function() require("fzf-lua").lsp_typedefs() end, desc = "LSP type definitions" },
      { "<leader>ld",      function() require("fzf-lua").diagnostics_doc() end, desc = "Document diagnostics" },
      { "<leader>lw",      function() require("fzf-lua").diagnostics_workspace() end, desc = "Workspace diagnostics" },
    },
    opts = {
      winopts = {
        preview = {
          default = "bat",
        },
      },
    },
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
