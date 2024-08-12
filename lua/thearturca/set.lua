vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 6
vim.opt.softtabstop = 6
vim.opt.shiftwidth = 6
vim.opt.expandtab = true


vim.opt.cindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.title = true
vim.opt.titlelen = 0 -- do not shorten title
vim.opt.titlestring = 'nvim %{expand("%:p")}'
