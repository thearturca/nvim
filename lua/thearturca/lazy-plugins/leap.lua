return {
	url = "https://codeberg.org/andyg/leap.nvim",
	config = function()
		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")
		vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
	end,
}
