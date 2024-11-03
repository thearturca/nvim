-- Utilities for creating configurations
local util = require("formatter.util")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},

		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},

		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettier,
		},

		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},

		javascriptreact = {
			require("formatter.filetypes.javascriptreact").prettier,
		},

		go = {
			require("formatter.filetypes.go").gofmt,
		},

		css = {
			require("formatter.filetypes.css").prettier,
		},

		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},

		html = {
			require("formatter.filetypes.html").prettier,
		},

		json = {
			require("formatter.filetypes.json").prettier,
		},

		jsonc = {
			require("formatter.filetypes.json").fixjson,
			require("formatter.filetypes.json").prettier,
		},

		markdown = {
			require("formatter.filetypes.markdown").prettier,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			function()
				if vim.fn.executable("sed") == 1 then
					return require("formatter.filetypes.any").remove_trailing_whitespace
				end
			end,
		},
	},
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})
