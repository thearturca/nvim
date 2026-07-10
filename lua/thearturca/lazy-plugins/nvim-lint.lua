return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			typescript = { "oxlint" },
			javascript = { "oxlint" },
		}

		local function file_exists(name)
			local f = io.open(name, "r")
			return f ~= nil and io.close(f)
		end

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = lint_augroup,
			callback = function()
				local oxlint = require("lint").linters.oxlint
				if file_exists("oxlintrc.json") then
					oxlint.args = {
						"--config",
						"./oxlintrc.json",
						"--format",
						"github",
					}
				elseif file_exists("/usr/local/lib/node_modules/@thearturca/shared-configs/oxlint/base.json") then
					oxlint.args = {
						"--config",
						"/usr/local/lib/node_modules/@thearturca/shared-configs/oxlint/base.json",
						"--format",
						"github",
					}
				else
					oxlint.args = {
						"--format",
						"github",
					}
				end

				require("lint").try_lint()
			end,
		})
	end,
}
