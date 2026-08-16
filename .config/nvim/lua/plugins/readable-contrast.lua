-- Bump near-invisible greys (#333333 / NonText) so they read on pure black.
-- Matteblack uses bg2 (#333333) for NonText/LineNr; Snacks picker paths link to that.
local dim = "#8A8A8D" -- comment grey — muted but readable
local muted = "#A3A3A3" -- path / secondary text
local soft = "#737373" -- quieter chrome (indent, separators)

local function hl(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

local function apply()
  -- Core groups themes paint with bg2 (#333333)
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
  hl("VertSplit", { fg = muted })
  hl("FloatBorder", { fg = muted })

  -- Snacks file picker: dirname path was SnacksPickerDir → NonText
  hl("SnacksPickerDir", { fg = muted })
  hl("SnacksPickerPathIgnored", { fg = dim })
  hl("SnacksPickerPathHidden", { fg = dim })
  hl("SnacksPickerTotals", { fg = dim })
  hl("SnacksPickerUnselected", { fg = dim })
  hl("SnacksPickerBufFlags", { fg = dim })
  hl("SnacksPickerKeymapRhs", { fg = dim })
  hl("SnacksPickerDimmed", { fg = dim })
  hl("SnacksPickerTree", { fg = dim })
  hl("SnacksPickerCol", { fg = dim })
  hl("SnacksPickerDesc", { fg = muted })
  hl("SnacksPickerComment", { fg = muted })
  hl("SnacksPickerLink", { fg = muted })
  hl("SnacksIndent", { fg = soft })

  -- Neo-tree chrome that was painted with bg2
  hl("NeoTreeIndentMarker", { fg = soft })
  hl("NeoTreeDimText", { fg = muted })
  hl("NeoTreeDotfile", { fg = dim })
  hl("NeoTreeMessage", { fg = muted })
  hl("NeoTreeFloatBorder", { fg = muted })
  hl("NeoTreeWinSeparator", { fg = muted })
  hl("NeoTreeVertSplit", { fg = muted })

  -- Which-key / misc dim
  hl("WhichKeySeparator", { fg = muted })
  hl("LazyDimmed", { fg = muted })
end

apply()
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("readable_contrast", { clear = true }),
  callback = apply,
})

return {}
