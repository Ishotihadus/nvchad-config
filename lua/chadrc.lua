-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "pastelDark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }

M.ui = {
	statusline = {
		order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "python_venv", "cwd", "cursor" },
		modules = {
			python_venv = function()
				local clients = vim.lsp.get_clients({ name = "pyright" })
				if #clients == 0 then
					return ""
				end
				local client = clients[1]
				local python_path = client.config
					and client.config.settings
					and client.config.settings.python
					and client.config.settings.python.pythonPath
				if python_path then
					local venv = python_path:match("([^/]+)/bin/python$")
					return venv and ("%#St_gitIcons# \u{e73c} " .. venv .. " ") or ""
				end
				return ""
			end,
		},
	},
	tabufline = {
		lazyload = false,
	},
}

return M
