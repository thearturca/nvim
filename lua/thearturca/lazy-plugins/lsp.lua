return {
	"neovim/nvim-lspconfig",
	version = "v4.x",
	dependencies = {
		-- LSP Support
		{ "mfussenegger/nvim-lint" },
		{ "mason-org/mason.nvim", opts = {} },
		{ "mason-org/mason-lspconfig.nvim" },

		-- Autocompletion
		{ "hrsh7th/nvim-cmp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-cmdline" },
		{ "saadparwaiz1/cmp_luasnip" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{
			"windwp/nvim-autopairs",
			opts = {},
		},
		{
			"numToStr/Comment.nvim",
			opts = {},
		},

		-- Snippets
		{ "L3MON4D3/LuaSnip" },
		{ "rafamadriz/friendly-snippets" },

		{ "j-hui/fidget.nvim" },
	},
	config = function()
		-- lsp.preset("recommended")
		-- lsp.nvim_workspace()

		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- this is the function that loads the extra snippets to luasnip
		-- from rafamadriz/friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		require("fidget").setup({})

		require("mason-lspconfig").setup({
			ensure_installed = {
				"rust_analyzer",
				"lua_ls",
				"gopls",
				"vtsls",
				"html",
			},
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({ capabilities = capabilities })
				end,
				lua_ls = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = {
									version = "LuaJIT",
								},
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = {
										vim.env.VIMRUNTIME,
									},
								},
							},
						},
					})
				end,
			},
		})

		vim.diagnostic.config({
			virtual_text = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		-- cmp_mappings["<Tab>"] = nil
		-- cmp_mappings["<S-Tab>"] = nil

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "cmp_tabnine" },
				{ name = "luasnip", keyword_length = 2 },
			}, {
				{ name = "buffer" },
			}),
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
			}),
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(e)
				local opts = { buffer = e.buf }
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition()
				end, opts)
				vim.keymap.set("n", "K", function()
					vim.lsp.buf.hover({ border = "rounded" })
				end, opts)
				vim.keymap.set("n", "<leader>vws", function()
					vim.lsp.buf.workspace_symbol()
				end, opts)
				vim.keymap.set("n", "<leader>vd", function()
					vim.diagnostic.open_float()
				end, opts)
				vim.keymap.set("n", "[d", function()
					vim.diagnostic.goto_next()
				end, opts)
				vim.keymap.set("n", "]d", function()
					vim.diagnostic.goto_prev()
				end, opts)
				vim.keymap.set("n", "<leader>vca", function()
					vim.lsp.buf.code_action()
				end, opts)
				-- vim.keymap.set("n", "<leader>vrr", function()
				-- 	vim.lsp.buf.references()
				-- end, opts)
				vim.keymap.set("n", "<leader>vrn", function()
					vim.lsp.buf.rename()
				end, opts)
				vim.keymap.set("i", "<C-h>", function()
					vim.lsp.buf.signature_help()
				end, opts)
			end,
		})

		local lint = require("lint")
		lint.linters_by_ft = {
			typescript = { "oxlint" },
			javascript = { "oxlint" },
		}

		local function file_exists(name)
			local f = io.open(name, "r")
			return f ~= nil and io.close(f)
		end

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				if file_exists("oxlintrc.json") then
					lint.linters.oxlint.args = {
						"--config",
						"./oxlintrc.json",
						"--format",
						"unix",
					}
				else
					lint.linters.oxlint.args = {
						"--format",
						"unix",
					}
				end
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				require("lint").try_lint()
			end,
		})
	end,
}
