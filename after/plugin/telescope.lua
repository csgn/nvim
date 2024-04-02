local builtin = require 'telescope.builtin'
local actions = require 'telescope.actions'
local grep_args = { '--hidden', '--glob', '!**/.git/*' }


vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
vim.keymap.set('n', '<leader>gg', builtin.git_files, {})
vim.keymap.set('n', '<leader>gp', function()
    builtin.grep_string({ search = vim.fn.input("[Grep] ") });
end)

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        },
        file_ignore_patterns = {
            "node_modules",
            ".next",
            ".git",
            "venv",
            "build",
            "dist",
            "*.lock",
            ".bloop",
            ".metals",
            "target"
        }
    },
    pickers = {
        find_files = {
            find_command = { 'fd', '--type', 'f', '--hidden', '--exclude', '.git' }
        },
        live_grep = {
            additional_args = function(opts)
                return grep_args
            end
        },
        grep_string = {
            additional_args = function(opts)
                return grep_args
            end
        },
    },
}