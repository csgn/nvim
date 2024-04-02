local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local plugins = {
  -- colorscheme
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
        vim.cmd('colorscheme rose-pine')
    end
  },
  { "catppuccin/nvim", name = "catppuccin" },

  -- harpoon2
  {
    "ThePrimeagen/harpoon",
    name = 'harpoon2',
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },

  { 'nvim-tree/nvim-web-devicons', name = 'nvim-web-devicons' },
  { 'numToStr/Comment.nvim', name = 'comment' },
  { 'jiangmiao/auto-pairs', name = 'auto-pairs' },
  { 'mbbill/undotree', name = 'undotree'},

  {
    'nvim-telescope/telescope.nvim',
    name = 'telescope',
    tag = '0.1.4',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  {
    'tpope/vim-fugitive',
    name = 'fugitive'
  },

  {
    "nvim-treesitter/nvim-treesitter",
    name = 'treesitter',
    build = ":TSUpdate"
  },

  {'VonHeikemen/lsp-zero.nvim', name = 'lsp-zero', branch = 'v3.x'},
  {'neovim/nvim-lspconfig', name = 'lsp-config'},
  {'hrsh7th/cmp-nvim-lsp', name = 'cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp', name = 'nvim-cmp'},
  {'L3MON4D3/LuaSnip', name = 'luasnip'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},

  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.on_attach = function(client, bufnr)
        -- your on_attach function
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
  }

}

local opts = {}

require("lazy").setup(plugins, opts)
