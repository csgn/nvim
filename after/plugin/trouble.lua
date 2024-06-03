require("trouble").setup({ 
    -- old version
    -- icons = true,
    -- fold_open = "▼",
    -- fold_closed = "▶",
    -- signs = {
    --   -- icons / text used for a diagnostic
    --   error = "🚨",
    --   warning = "⚠️",
    --   hint = "🤔",
    --   information = "🔎",
    --   other = "✨",
    -- },
})

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>",
  {silent = true, noremap = true}
)
