require("trouble").setup({ icons = false })

vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
