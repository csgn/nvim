local harpoon = require("harpoon")
harpoon:setup()

local toggle_opts = {
	border = "rounded",
	title_pos = "center",
	ui_width_ratio = 0.70,
	height_in_lines = 24,
}


vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<leader>j", function() harpoon.ui:toggle_quick_menu(harpoon:list(), toggle_opts) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
