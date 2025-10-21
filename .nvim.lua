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

-- Custom RustAnalyzer command for advanced features with WASM target
vim.api.nvim_create_user_command("CustomCommandRAFeatureAdvanced", function()
	configure_rust_analyzer({
		cargo = {
			features = { "advanced" },
		},
	}, "advanced features, allTargets, and WASM target")
end, { desc = "Configure RustAnalyzer with advanced features, allTargets, and WASM target" })

-- Custom RustAnalyzer command for WASM features
vim.api.nvim_create_user_command("CustomCommandRAFeatureWasm", function()
	configure_rust_analyzer({
		cargo = {
			features = { "wasm-support" },
		},
	}, "wasm-support features, allTargets, and WASM target")
end, { desc = "Configure RustAnalyzer with wasm-support features, allTargets, and WASM target" })

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
