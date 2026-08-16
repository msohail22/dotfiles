-- GNU Assembly (GAS) via asm-lsp
-- Hover/completion/diagnostics for .s / .S / .asm
-- Global gas defaults: ~/.config/asm-lsp/.asm-lsp.toml
-- Per-project override: put .asm-lsp.toml in the project root (needs .git or that file)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "asm" })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "asm-lsp" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        asm_lsp = {
          filetypes = { "asm", "vmasm" },
          root_markers = { ".asm-lsp.toml", ".git", "Makefile", "CMakeLists.txt" },
        },
      },
    },
  },
}
