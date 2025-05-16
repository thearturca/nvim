return {
	{
		"tzachar/cmp-tabnine",
		build = "./install.ps1",
		opts = {
			max_lines = 1000,
			max_num_results = 20,
			sort = true,
			run_on_every_keystroke = true,
			snippet_placeholder = "..",
			ignored_file_types = {
				-- default is not to ignore
				-- uncomment to ignore in lua:
				-- lua = true
			},
			show_prediction_strength = false,
		},
	},
	{
		"Exafunction/windsurf.vim",
		config = function()
			vim.keymap.set("i", "<C-g>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "<c-k>", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "<c-j>", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
			vim.keymap.set("i", "<c-x>", function()
				return vim.fn["codeium#Clear"]()
			end, { expr = true })
		end,
	},
}
