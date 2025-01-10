vim.g.clever_f_not_overwrites_standard_mappings = 1

vim.keymap.set(
  {"n", "x", "o"},
  "f",
  function() 
    require("eyeliner").highlight({ forward = true })
    return "<Plug>(clever-f-f)"
  end,
  {expr = true}
)

vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg='#d9ff00', bold = true, underline = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg='#ff0aa9', underline = true })
