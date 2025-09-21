--vim.cmd.colorscheme("modus-vivendi")

vim.api.nvim_set_hl(0, 'EyelinerPrimary', { fg='#d9ff00', bold = true, underline = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { fg='#ff0aa9', underline = true })

require("noirbuddy").setup {
    colors = {
        background = '#000000',
        primary = '#777777',
        diagnostic_error = '#EC0034',
        diagnostic_warning = '#ff7700',
        diagnostic_info = '#d5d5d5',
        diagnostic_hint = '#f5f5f5',
        diff_add = '#f5f5f5',
        diff_change = '#737373',
        diff_delete = '#EC0034',
    },
}


