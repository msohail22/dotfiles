-- Make clangd usable on competitive-programming files.
--
-- The problem this solves:
--   yo.cpp is 26 lines, but #include <bits/stdc++.h> expands it to 137,278
--   lines. One parse of that costs 973 ms (measured with hyperfine). clangd
--   must redo it to refresh semantic highlighting, so typing queued up a
--   parse, cancelled it on the next keystroke, and started again. The log
--   showed 78 of these in one session:
--
--     semantic_tokens: "Request cancelled because the document was modified"
--
--   The editor was never crashing. It was always waiting.
--
-- Compile flags live in ~/.config/clangd/config.yaml, not here, so that
-- plain `clangd` from a terminal gets them too.

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local clangd = opts.servers.clangd

      -- Wait until typing stops before asking clangd to re-parse.
      -- LazyVim leaves this at the 150 ms default, which is shorter than a
      -- normal gap between keystrokes, so every keystroke cancelled the
      -- previous 973 ms parse. 500 ms is longer than a keystroke gap and
      -- shorter than a pause for thought, so one burst of typing costs one
      -- parse instead of ten abandoned ones.
      clangd.flags = vim.tbl_extend("force", clangd.flags or {}, {
        debounce_text_changes = 500,
      })

      -- Rebuild the command list. The LazyVim extra sets these; two are
      -- removed and two are added. Assigned whole rather than merged,
      -- because lazy.nvim merges list-like tables by index and that would
      -- interleave the old flags with the new ones.
      clangd.cmd = {
        "clangd",
        "--background-index",
        -- Dropped: "--clang-tidy". It re-walks the AST after every parse.
        -- Contest-relevant checks stay on via Diagnostics.ClangTidy in
        -- ~/.config/clangd/config.yaml; only the slow style packs are off.
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
        -- Keep the 137k-line preamble as a precompiled header on disk
        -- instead of rebuilding it. This is the single biggest win.
        "--pch-storage=disk",
        -- 12 cores are available; the default is 4.
        "-j=8",
      }

      -- LazyVim sets clangdFileStatus = true. That makes clangd emit a
      -- textDocument/clangd.fileStatus notification continuously, and each
      -- one was being written to disk. See the log fix in config/options.lua.
      clangd.init_options = vim.tbl_extend("force", clangd.init_options or {}, {
        clangdFileStatus = false,
      })

      return opts
    end,
  },
}
