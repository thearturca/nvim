local lsp = require("lsp-zero")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

-- lsp.preset("recommended")
-- lsp.nvim_workspace()

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = cmp.mapping.preset.insert({
	["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
	["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
	["<C-y>"] = cmp.mapping.confirm({ select = true }),
	["<C-Space>"] = cmp.mapping.complete(),
	["<C-e>"] = cmp.mapping.abort(),
})

cmp_mappings["<Tab>"] = nil
cmp_mappings["<S-Tab>"] = nil

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "luasnip", keyword_length = 2 },
	},
	mapping = cmp_mappings,
	formatting = lsp.cmp_format(),
})

local lsp_attach = function(client, bufnr)
	-- lsp.default_keymaps({buffer = bufnr})
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
	end, opts)
	vim.keymap.set("n", "K", function()
		vim.lsp.buf.hover()
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
	-- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function()
		vim.lsp.buf.rename()
	end, opts)
	vim.keymap.set("i", "<C-h>", function()
		vim.lsp.buf.signature_help()
	end, opts)

	-- lsp.async_autoformat(client, bufnr)
end

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp.extend_lspconfig({
	capabilities = lsp_capabilities,
	lsp_attach = lsp_attach,
	float_border = "rounded",
	sign_text = true,
})

require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"rust_analyzer",
		"lua_ls",
		"prettier",
		"fixjson",
		"gopls",
		"oxlint",
		"vtsls",
		"stylua",
		"html",
	},
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({})
		end,
		lua_ls = function()
			require("lspconfig").lua_ls.setup({
				capabilities = lsp_capabilities,
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
