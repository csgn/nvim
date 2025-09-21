local map = vim.keymap.set
local fn = vim.fn

----------------------------------
-- INSTALL LAZY ------------------
----------------------------------
local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

----------------------------------
-- PLUGINS -----------------------
----------------------------------
require("lazy").setup({
	-- nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-vsnip" },
			{ "hrsh7th/vim-vsnip" }
		},
		opts = function()
			local cmp = require("cmp")
			local conf = {
				sources = {
					{ name = "nvim_lsp" },
					{ name = "vsnip" },
				},
				snippet = {
					expand = function(args)
						-- Comes from vsnip
						fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					-- None of this made sense to me when first looking into this since there
					-- is no vim docs, but you can't have select = true here _unless_ you are
					-- also using the snippet stuff. So keep in mind that if you remove
					-- snippets you need to remove this select
					["<CR>"] = cmp.mapping.confirm({ select = true })
				})
			}
			return conf
		end
	},
	-- nvim-metals
	{
		"scalameta/nvim-metals",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
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
								runType = "runOrTestFile",
								--args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
							},
						},
						{
							type = "scala",
							request = "launch",
							name = "Test Target",
							metals = {
								runType = "testTarget",
							},
						},
					}
				end
			},
		},
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()

			-- Example of settings
			metals_config.settings = {
				showImplicitArguments = true,
				excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
			}

			-- *READ THIS*
			-- I *highly* recommend setting statusBarProvider to either "off" or "on"
			--
			-- "off" will enable LSP progress notifications by Metals and you'll need
			-- to ensure you have a plugin like fidget.nvim installed to handle them.
			--
			-- "on" will enable the custom Metals status extension and you *have* to have
			-- a have settings to capture this in your statusline or else you'll not see
			-- any messages from metals. There is more info in the help docs about this
			metals_config.init_options.statusBarProvider = "off"

			metals_config.capabilities = require("lsp-zero").get_capabilities()

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

				map("n", "<leader>ws", function()
					require("metals").hover_worksheet()
				end)

				-- Example mappings for usage with nvim-dap. If you don't use that, you can
				-- skip these
				map("n", "<leader>dc", function()
					require("dap").continue()
				end)

				map("n", "<leader>dr", function()
					require("dap").repl.toggle()
				end)

				map("n", "<leader>dK", function()
					require("dap.ui.widgets").hover()
				end)

				map("n", "<leader>dt", function()
					require("dap").toggle_breakpoint()
				end)

				map("n", "<leader>dso", function()
					require("dap").step_over()
				end)

				map("n", "<leader>dsi", function()
					require("dap").step_into()
				end)

				map("n", "<leader>dl", function()
					require("dap").run_last()
				end)
			end

			return metals_config
		end,
		config = function(self, metals_config)
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
				group = nvim_metals_group,
			})
		end
	},
	-- colorscheme
	{
		'jesseleite/nvim-noirbuddy',
		dependencies = {
			{ 'tjdevries/colorbuddy.nvim' }
		},
		lazy = false,
		priority = 1000,
	},
	{
		'ishan9299/modus-theme-vim'
	},
	-- trouble
	{
		"folke/trouble.nvim",
		name = "trouble",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{
				"<leader>tt",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)"
			},
			{
				"<leader>tT",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)"
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
	-- harpoon2
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	},
	-- nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	-- comment
	{
		"numToStr/Comment.nvim"
	},
	-- undotree
	{
		"mbbill/undotree"
	},
	-- lsp
	{ 'VonHeikemen/lsp-zero.nvim',        branch = 'v4.x' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		'jinh0/eyeliner.nvim',
		dependencies = {
			"https://github.com/rhysd/clever-f.vim"
		},
		config = function()
			require 'eyeliner'.setup {
				-- show highlights only after keypress
				highlight_on_key = false,

				-- dim all other characters if set to true (recommended!)
				dim = true,

				-- set the maximum number of characters eyeliner.nvim will check from
				-- your current cursor position; this is useful if you are dealing with
				-- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
				max_length = 9999,

				-- filetypes for which eyeliner should be disabled;
				-- e.g., to disable on help files:
				-- disabled_filetypes = {"help"}
				disabled_filetypes = {},

				-- buftypes for which eyeliner should be disabled
				-- e.g., disabled_buftypes = {"nofile"}
				disabled_buftypes = {},

				-- add eyeliner to f/F/t/T keymaps;
				-- see section on advanced configuration for more information
				default_keymaps = false,
			}
		end
	},
	{
		"rachartier/tiny-glimmer.nvim",
		event = "VeryLazy",
		opts = {
			default_animation = "fade",
			animations = {
				fade = {
					max_duration = 300,
					chars_for_max_duration = 40,
					lingering_time = 50,
					to_color = "#FF00FF",
				},
			}
		},
	},
	-- {
	--     "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},
	-- Indentation Highlighting
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		---@module "ibl"
		---@type ibl.config
		opts = {},
	},
	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"HiPhish/rainbow-delimiters.nvim"
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	}

})

----------------------------------
-- OPTIONS -----------------------
----------------------------------
-- global
vim.opt_global.completeopt = { "menuone", "noinsert", "noselect" }
