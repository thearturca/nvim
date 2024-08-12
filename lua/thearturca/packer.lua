-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
      -- Packer can manage itself
      use 'wbthomason/packer.nvim'

      -- Harpoon
      use 'ThePrimeagen/harpoon'

      use {
            'nvim-telescope/telescope.nvim', tag = '0.1.x',
            requires = { {'nvim-lua/plenary.nvim'}, {'nvim-tree/nvim-web-devicons'} }
      }

      -- leap
      use('ggandor/leap.nvim')

      -- visualize colors
      use('norcalli/nvim-colorizer.lua')

      -- ColorScheme
      use({ 'rose-pine/neovim', as = 'rose-pine' })

      -- Syntax highlight
      use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})
      use('nvim-treesitter/nvim-treesitter-context')

      use('mbbill/undotree')

      -- LSP
      use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v4.x',
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
      use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} }
      use "jay-babu/mason-nvim-dap.nvim"
      use { "mxsdev/nvim-dap-vscode-js", requires = {"mfussenegger/nvim-dap"} }
      use {
            "microsoft/vscode-js-debug",
            opt = true,
            run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out" 
      }

      -- bottom line
      use {
            'nvim-lualine/lualine.nvim',
            requires = { 'nvim-tree/nvim-web-devicons', opt = true }
      }

      -- git
      use {
            'lewis6991/gitsigns.nvim',
            -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
      }
      use 'tpope/vim-fugitive'

      -- AI Autocompletion
      use {
            'tzachar/cmp-tabnine',
            run='./install.ps1'
      }

      use {
            'Exafunction/codeium.vim',
            config = function ()
                  -- Change '<C-g>' here to any keycode you like.
                  vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true })
                  vim.keymap.set('i', '<c-k>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
                  vim.keymap.set('i', '<c-j>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
                  vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true })
            end
      }

      -- Comments
      use {
            'numToStr/Comment.nvim',
            config = function()
                  require('Comment').setup()
            end
      }

      -- autopairs
      use {
            "windwp/nvim-autopairs",
            config = function() require("nvim-autopairs").setup {} end
      }
end)

