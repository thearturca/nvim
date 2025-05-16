return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"jay-babu/mason-nvim-dap.nvim",
				opts = { ensure_installed = { "delve" }, handlers = {} },
			},
			{
				"rcarriga/nvim-dap-ui",
				opts = {},
			},
			{ "nvim-neotest/nvim-nio" },
			-- {
			-- 	"microsoft/vscode-js-debug",
			-- 	lazy = true,
			-- 	build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
			-- },
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Breakpoint visuals
			vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
			local type_to_filtetype = {}
			type_to_filtetype["pwa-node"] = { "typescript", "javascript" }

			local continue = function()
				if vim.fn.filereadable(".vscode/launch.json") then
					require("dap.ext.vscode").load_launchjs(".vscode/launch.json", type_to_filetype)
				end
				dap.continue()
			end

			vim.keymap.set("n", "<F5>", continue)
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>dui", dapui.toggle)

			-- typescript/javascript dap
			-- require("dap-vscode-js").setup({
			-- 	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
			-- 	debugger_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/vscode-js-debug",
			-- 	-- debugger_cmd = { 'js-debug-adapter.cmd' },
			-- 	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
			-- 	-- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
			-- 	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
			-- 	-- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
			-- })
			--
			-- for _, language in ipairs({ "typescript", "javascript" }) do
			-- 	dap.configurations[language] = {
			-- 		{
			-- 			type = "pwa-node",
			-- 			request = "launch",
			-- 			name = "js-debug: Launch current file",
			-- 			program = "${file}",
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 		{
			-- 			type = "pwa-node",
			-- 			request = "attach",
			-- 			name = "js-debug: Attach",
			-- 			processId = require("dap.utils").pick_process,
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 		{
			-- 			type = "node-terminal",
			-- 			request = "launch",
			-- 			name = "js-debug: Launch dev terminal",
			-- 			cwd = "${workspaceFolder}",
			-- 		},
			-- 	}
			-- end
		end,
	},
}
