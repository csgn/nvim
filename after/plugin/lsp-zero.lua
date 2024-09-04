local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.format_on_save({
    format_opts = {
      async = false,
      timeout_ms = 10000,
    },
    servers = {
        ['tsserver'] = {'javascript', 'typescript'},
        ['ruff_lsp'] = {'python'},
        ['metals'] = {'scala'},
    }
})


lsp_zero.set_sign_icons({
    error = '󰚌', -- https://fontawesome.com/icons/bomb?f=classic&s=solid
    warn = '', -- https://fontawesome.com/icons/circle-exclamation?f=classic&s=solid
    hint = '󰌵', -- https://fontawesome.com/icons/lightbulb?f=classic&s=solid 
    info = '' -- https://fontawesome.com/icons/circle-info?f=classic&s=solid
})
