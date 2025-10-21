-- .nvim.lua - Neovim exrc configuration for RustAnalyzer and development tools

local has_snacks, snacks = pcall(require, "snacks")
if not has_snacks then
	snacks = nil
end

local function configure_rust_analyzer(config, description)
	if type(config) ~= "table" then
		vim.notify("RustAnalyzer config expects a Lua table", vim.log.levels.ERROR)
		return
	end

	local ok, config_str = pcall(vim.inspect, config, { newline = "", indent = "" })
	if not ok then
		vim.notify("Failed to encode config table: " .. config_str, vim.log.levels.ERROR)
		return
	end

	config_str = config_str:gsub("%s+", function(s)
		if s:find("\n") then
			return " "
		end
		return s
	end)

	local ok_cmd, err = pcall(vim.api.nvim_cmd, { cmd = "RustAnalyzer", args = { "config", config_str } }, {})
	if not ok_cmd then
		vim.notify(err .. "\n" .. config_str, vim.log.levels.ERROR)
		return
	end

	vim.notify("RustAnalyzer configured: " .. description, vim.log.levels.INFO)

	-- Trigger flycheck after config is loaded
	vim.defer_fn(function()
		vim.cmd("RustLsp flyCheck")
		vim.notify("Flycheck started", vim.log.levels.INFO)
	end, 100)
end

-- -- Custom RustAnalyzer command for advanced features with WASM target
-- vim.api.nvim_create_user_command("CustomCommandRAFeatureAdvanced", function()
-- 	configure_rust_analyzer({
-- 		runnables = {
-- 			extraArgs = {
-- 				"--workspace",
-- 			},
-- 		},
-- 		cargo = {
-- 			extraEnv = {
-- 				POA_TOKEN_WASM = "/Users/mat/intents/res/defuse_poa_token.wasm",
-- 				POA_TOKEN_WITH_NO_REGISTRATION_DIR = "/Users/mat/intents/res/poa-token-no-registration",
-- 				POA_TOKEN_WASM_NO_REGISTRATION_WASM = "/Users/mat/intents/res/poa-token-no-registration/defuse_poa_token.wasm",
-- 			},
-- 			extraArgs = {
-- 				"--workspacexxx",
-- 			},
-- 			allTargets = true,
-- 		},
-- 		check = {
-- 			workspace = true,
-- 			-- extraEnv = {
-- 			-- 	POA_TOKEN_WASM = "/Users/mat/intents/res/defuse_poa_token.wasm",
-- 			-- 	POA_TOKEN_WITH_NO_REGISTRATION_DIR = "/Users/mat/intents/res/poa-token-no-registration",
-- 			-- 	POA_TOKEN_WASM_NO_REGISTRATION_WASM = "/Users/mat/intents/res/poa-token-no-registration/defuse_poa_token.wasm",
-- 			-- },
-- 		},
-- 	}, "advanced features, allTargets, and WASM target")
-- end, { desc = "Configure RustAnalyzer with advanced features, allTargets, and WASM target" })

-- Configure RustAnalyzer after LSP is attached
local function setup_rust_analyzer_on_attach()
	configure_rust_analyzer({
		runnables = {
			extraArgs = {
				"--workspace",
			},
		},
		cargo = {
			extraEnv = {
				POA_TOKEN_WASM = "/Users/mat/intents/res/defuse_poa_token.wasm",
				POA_TOKEN_WITH_NO_REGISTRATION_DIR = "/Users/mat/intents/res/poa-token-no-registration",
				POA_TOKEN_WASM_NO_REGISTRATION_WASM = "/Users/mat/intents/res/poa-token-no-registration/defuse_poa_token.wasm",
			},
			extraArgs = {
				-- "--workspace",
			},
			allTargets = true,
		},
		check = {
			workspace = true,
			-- extraEnv = {
			-- 	POA_TOKEN_WASM = "/Users/mat/intents/res/defuse_poa_token.wasm",
			-- 	POA_TOKEN_WITH_NO_REGISTRATION_DIR = "/Users/mat/intents/res/poa-token-no-registration",
			-- 	POA_TOKEN_WASM_NO_REGISTRATION_WASM = "/Users/mat/intents/res/poa-token-no-registration/defuse_poa_token.wasm",
			-- },
		},
	}, "advanced features, allTargets, and WASM target")
end

-- Hook into LSP attach event to configure after initialization
local group = vim.api.nvim_create_augroup("RustAnalyzerConfig", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client and client.name == "rust-analyzer" then
			setup_rust_analyzer_on_attach()
			-- Remove autocmd after first successful attach to avoid reconfiguring
			vim.api.nvim_del_augroup_by_id(group)
		end
	end,
})

-- -- Custom RustAnalyzer command for WASM features
-- vim.api.nvim_create_user_command("CustomCommandRAFeatureWasm", function()
-- 	configure_rust_analyzer({
-- 		cargo = {
-- 			features = { "wasm-support" },
-- 		},
-- 	}, "wasm-support features, allTargets, and WASM target")
-- end, { desc = "Configure RustAnalyzer with wasm-support features, allTargets, and WASM target" })

-- Command to pick and execute custom commands using snacks picker
vim.api.nvim_create_user_command("CustomCommandPicker", function()
	if not snacks then
		vim.notify("snacks plugin is not available", vim.log.levels.ERROR)
		return
	end

	-- Get all user commands that start with "CustomCommand"
	local commands = {}
	local user_commands = vim.api.nvim_get_commands({})

	for cmd_name, cmd_info in pairs(user_commands) do
		if cmd_name:match("^CustomCommand") then
			table.insert(commands, cmd_name)
		end
	end

	if #commands == 0 then
		vim.notify("No CustomCommand* commands found", vim.log.levels.WARN)
		return
	end

	-- Use snacks picker to select a command
	snacks.picker.select(commands, {
		prompt = "Select Custom Command: ",
	}, function(choice)
		if choice then
			vim.cmd(choice)
			vim.notify("Executed: " .. choice, vim.log.levels.INFO)
		end
	end)
end, { desc = "Pick and execute custom RustAnalyzer feature commands" })

-- Map CustomCommandPicker to <space>cc
vim.keymap.set("n", "<space>cc", "<cmd>CustomCommandPicker<CR>", {
	noremap = true,
	silent = true,
	desc = "Open custom command picker",
})
