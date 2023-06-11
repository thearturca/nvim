-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'ThePrimeagen/harpoon'
  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.1',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- ColorScheme
  use({ 'rose-pine/neovim', as = 'rose-pine' })

  -- Syntax highlight
  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})

  use('mbbill/undotree')
  use 'tpope/vim-fugitive'

  -- LSP
  use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
              -- LSP Support
              {'neovim/nvim-lspconfig'},
              {'williamboman/mason.nvim'},
              {'williamboman/mason-lspconfig.nvim'},

              -- Autocompletion
              {'hrsh7th/nvim-cmp'},
              {'hrsh7th/cmp-buffer'},
              {'hrsh7th/cmp-path'},
              {'saadparwaiz1/cmp_luasnip'},
              {'hrsh7th/cmp-nvim-lsp'},
              {'hrsh7th/cmp-nvim-lua'},

              -- Snippets
              {'L3MON4D3/LuaSnip'},
              {'rafamadriz/friendly-snippets'},
        }
  }

  -- DAP
  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use "jay-babu/mason-nvim-dap.nvim"

  -- bottom line
  use {
            'nvim-lualine/lualine.nvim',
            requires = { 'nvim-tree/nvim-web-devicons', opt = true }
      }

use {
      'lewis6991/gitsigns.nvim',
      -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
}
end)

