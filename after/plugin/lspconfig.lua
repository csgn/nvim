-- glsl
require("lspconfig")["glsl_analyzer"].setup({})

require("lspconfig")["clangd"].setup({
	cmd = {
		"clangd-17",
		"--background-index",
		"--clang-tidy",
		"--log=verbose",
		"--pch-storage=memory",       -- store precompiled headers in RAM
		"--clang-tidy-checks=*",      -- enable all clang-tidy checks
		"--completion-style=detailed", -- better completions
		"--header-insertion=never",   -- Include Cleaner önerileri için

	},
	init_options = {
		fallbackFlags = { '-std=c++17' },
	},
})

-- godot
require("lspconfig")["gdscript"].setup({
	name = "godot",
	cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
})

vim.api.nvim_set_keymap('n', '<leader>bb', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
