local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end

vim.opt.rtp:prepend(lazypath)

local map = vim.keymap.set
local fn = vim.fn

local plugins = {
    -- colorscheme
    {
        dir = "csgn/nolife.nvim",
        name = "nolife",
        lazy = false,
        priority = 1000
    },
    -- trouble
    {
        "folke/trouble.nvim",
        name = "trouble",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        keys = {
            {
                "<leader>tt",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)"
            },
            {
                "<leader>tT",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)"
            },
            {
                "<leader>ts",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)"
            },
            {
                "<leader>tl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)"
            },
            {
                "<leader>tL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)"
            },
            {
                "<leader>tQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)"
            }
        }
    },
    {"catppuccin/nvim", name = "catppuccin"},
    -- harpoon2
    {
        "ThePrimeagen/harpoon",
        name = "harpoon2",
        branch = "harpoon2",
        dependencies = {"nvim-lua/plenary.nvim"}
    },
    {"nvim-tree/nvim-web-devicons", name = "nvim-web-devicons"},
    {"numToStr/Comment.nvim", name = "comment"},
    {"mbbill/undotree", name = "undotree"},
    {
        "nvim-telescope/telescope.nvim",
        name = "telescope",
        tag = "0.1.4",
        dependencies = {"nvim-lua/plenary.nvim"}
    },
    {
        "tpope/vim-fugitive",
        name = "fugitive"
    },
    {
        "nvim-treesitter/nvim-treesitter",
        name = "treesitter",
        build = ":TSUpdate",
        dependencies = {"HiPhish/nvim-ts-rainbow2"},
        opts = function(_, opts)
            opts.rainbow = {
                enable = true,
                query = "rainbow-parens",
                strategy = require("ts-rainbow").strategy.global
            }
        end
    },
    {"VonHeikemen/lsp-zero.nvim", name = "lsp-zero", branch = "v3.x"},
    {"neovim/nvim-lspconfig", name = "lsp-config"},
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            {"hrsh7th/cmp-nvim-lsp"},
            {"hrsh7th/cmp-vsnip"},
            {"hrsh7th/vim-vsnip"}
        },
        opts = function()
            local cmp = require("cmp")
            local conf = {
                sources = {
                    {name = "nvim_lsp"},
                    {name = "vsnip"}
                },
                snippet = {
                    expand = function(args)
                        -- Comes from vsnip
                        fn["vsnip#anonymous"](args.body)
                    end
                },
                mapping = cmp.mapping.preset.insert(
                    {
                        -- None of this made sense to me when first looking into this since there
                        -- is no vim docs, but you can't have select = true here _unless_ you are
                        -- also using the snippet stuff. So keep in mind that if you remove
                        -- snippets you need to remove this select
                        ["<CR>"] = cmp.mapping.confirm({select = true})
                    }
                )
            }
            return conf
        end
    },
    {"L3MON4D3/LuaSnip", name = "luasnip"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "mfussenegger/nvim-dap",
                config = function(self, opts)
                    -- Debug settings if you're using nvim-dap
                    local dap = require("dap")

                    dap.configurations.scala = {
                        {
                            type = "scala",
                            request = "launch",
                            name = "RunOrTest",
                            metals = {
                                runType = "runOrTestFile"
                                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
                            }
                        },
                        {
                            type = "scala",
                            request = "launch",
                            name = "Test Target",
                            metals = {
                                runType = "testTarget"
                            }
                        }
                    }
                end
            }
        },
        ft = {"scala", "sbt", "java"},
        opts = function()
            local metals_config = require("metals").bare_config()

            metals_config.settings = {
                showImplicitArguments = true,
                excludedPackages = {"akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl"}
            }
            metals_config.init_options.statusBarProvider = "off"
            metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

            metals_config.on_attach = function(client, bufnr)
                require("metals").setup_dap()

                -- LSP mappings
                map("n", "gD", vim.lsp.buf.definition)
                map("n", "K", vim.lsp.buf.hover)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gds", vim.lsp.buf.document_symbol)
                map("n", "gws", vim.lsp.buf.workspace_symbol)
                map("n", "<leader>cl", vim.lsp.codelens.run)
                map("n", "<leader>sh", vim.lsp.buf.signature_help)
                map("n", "<leader>rn", vim.lsp.buf.rename)
                map("n", "<leader>f", vim.lsp.buf.format)
                map("n", "<leader>ca", vim.lsp.buf.code_action)

                map(
                    "n",
                    "<leader>ws",
                    function()
                        require("metals").hover_worksheet()
                    end
                )

                -- all workspace diagnostics
                map("n", "<leader>aa", vim.diagnostic.setqflist)

                -- all workspace errors
                map(
                    "n",
                    "<leader>ae",
                    function()
                        vim.diagnostic.setqflist({severity = "E"})
                    end
                )

                -- all workspace warnings
                map(
                    "n",
                    "<leader>aw",
                    function()
                        vim.diagnostic.setqflist({severity = "W"})
                    end
                )

                -- buffer diagnostics only
                map("n", "<leader>d", vim.diagnostic.setloclist)

                map(
                    "n",
                    "[c",
                    function()
                        vim.diagnostic.goto_prev({wrap = false})
                    end
                )

                map(
                    "n",
                    "]c",
                    function()
                        vim.diagnostic.goto_next({wrap = false})
                    end
                )

                -- Example mappings for usage with nvim-dap. If you don't use that, you can
                -- skip these
                map(
                    "n",
                    "<leader>dc",
                    function()
                        require("dap").continue()
                    end
                )

                map(
                    "n",
                    "<leader>dr",
                    function()
                        require("dap").repl.toggle()
                    end
                )

                map(
                    "n",
                    "<leader>dK",
                    function()
                        require("dap.ui.widgets").hover()
                    end
                )

                map(
                    "n",
                    "<leader>dt",
                    function()
                        require("dap").toggle_breakpoint()
                    end
                )

                map(
                    "n",
                    "<leader>dso",
                    function()
                        require("dap").step_over()
                    end
                )

                map(
                    "n",
                    "<leader>dsi",
                    function()
                        require("dap").step_into()
                    end
                )

                map(
                    "n",
                    "<leader>dl",
                    function()
                        require("dap").run_last()
                    end
                )
            end

            return metals_config
        end,
        config = function(self, metals_config)
            local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", {clear = true})
            vim.api.nvim_create_autocmd(
                "FileType",
                {
                    pattern = self.ft,
                    callback = function()
                        require("metals").initialize_or_attach(metals_config)
                    end,
                    group = nvim_metals_group
                }
            )
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {{"nvim-telescope/telescope.nvim", name = "telescope"}, "nvim-lua/plenary.nvim"}
    }
}

local opts = {}

require("lazy").setup(plugins, opts)
