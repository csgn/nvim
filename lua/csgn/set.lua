--vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.backup = false         -- creates a backup file
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.showmode = false     -- we don't need to see things like -- INSERT -- anymore
vim.opt.mouse = "a"          -- allow the mouse to be used in neovim
vim.opt.swapfile = false     -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.expandtab = false
vim.opt.undofile = true      -- enable persistent undo
vim.opt.shiftwidth = 4       -- the number of spaces inserted for each indentation
vim.opt.tabstop = 4          -- insert 2 spaces for a tab
--vim.opt.softtabstop = 0
--vim.opt.smarttab = true
vim.opt.expandtab = false
vim.opt.smartindent = true -- make indenting smarter again
--vim.opt.autoindent = true -- make indenting smarter again
vim.opt.cursorline = true  -- highlight the current line
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.wrap = true -- display lines as one long line
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
vim.opt.shortmess:append "c"
vim.opt.nuw = 1
--vim.opt.signcolumn = "no"
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = "#7F00FF", bg = "#000000", bold = true})
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = "#ffffff", bg = "#000000", bold = false})
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = "#dddddd", bg = "#000000", bold = false})
vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
