require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>r", function()
  vim.cmd("w")
  vim.cmd("!g++ -std=c++17 -O2 -Wall -Wextra % -o %< && ./%< < input.txt")
end, { desc = "Run C++" })

map("n", "<leader>o", function()
  vim.cmd("w")
  vim.cmd("!g++ -std=c++17 -O2 -Wall -Wextra % -o %< && ./%< < input.txt > output.txt")
end, { desc = "Run C++ → output.txt" })
