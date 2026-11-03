-- matteblack, the only colorscheme. Omarchy ships all-themes.lua (120 lines of
-- schemes) plus a hot-reload shim that swaps the scheme when the desktop theme
-- changes; both are deleted, so nothing competes with this file.
return {
	{
		"tahayvr/matteblack.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"LazyVim/LazyVim",
		opts = { colorscheme = "matteblack" },
	},
	-- LazyVim's own spec pulls these two in. Nothing sets them now, so they are
	-- dead weight; switch them off and lazy prunes them on the next sync.
	{ "folke/tokyonight.nvim", enabled = false },
	{ "catppuccin/nvim", enabled = false },
	{
		-- matteblack paints several groups with bg2 (#333333), which is almost
		-- invisible on its near-black background. Repaint them. Carried over
		-- from the old config's readable-contrast block.
		"LazyVim/LazyVim",
		config = function(_, opts)
			require("lazyvim").setup(opts)

			local dim = "#8A8A8D" -- comment grey - muted but readable
			local muted = "#A3A3A3" -- path / secondary text
			local soft = "#737373" -- quieter chrome (indent, separators)

			local function set_contrast()
				local hl = function(name, o) vim.api.nvim_set_hl(0, name, o) end
				hl("NonText", { fg = dim })
				hl("EndOfBuffer", { fg = soft })
				hl("Whitespace", { fg = soft })
				hl("Conceal", { fg = dim })
				hl("LineNr", { fg = dim })
				hl("LineNrAbove", { fg = dim })
				hl("LineNrBelow", { fg = dim })
				hl("FoldColumn", { fg = dim })
				hl("SignColumn", { fg = dim })
				hl("WinSeparator", { fg = muted })
				hl("FloatBorder", { fg = muted })
				-- Inline blame, amber to match the matteblack accent.
				hl("GitSignsCurrentLineBlame", { fg = "#E68E0D", italic = true })
			end

			set_contrast()
			-- A colorscheme command resets every highlight, so reapply after one runs.
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("readable_contrast", { clear = true }),
				callback = set_contrast,
			})
		end,
	},
}
