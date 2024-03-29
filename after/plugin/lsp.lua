local lsp = require('lsp-zero').preset({})

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'pyright'
})

lsp.nvim_workspace()

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_format_on_save = function(bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
            vim.lsp.buf.format()
            local filter = function(client)
                return client.name == "null-ls"
            end
        end,
    })
end


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
  suggest_lsp_servers = false,
  sign_icons = {
      error = '', -- https://fontawesome.com/icons/bomb?f=classic&s=solid
      warn = '', -- https://fontawesome.com/icons/circle-exclamation?f=classic&s=solid
      hint = '', -- https://fontawesome.com/icons/lightbulb?f=classic&s=solid 
      info = '' -- https://fontawesome.com/icons/circle-info?f=classic&s=solid
  }
})

lsp.on_attach(function(client, bufnr)
    lsp_format_on_save(bufnr)
end)

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    }
})


lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})