-- This file  needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

local M = {}

vim.cmd("highlight St_relativepath guifg=#626a83 guibg=#2a2b36")

local stbufnr = function()
	return vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
end

M.ui = {
	cmp = {
		style = "atom_colored",
	},
	telescope = { style = "borderless" },
	statusline = {
		theme = "vscode_colored",
		order = { "mode", "relativepath", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
		modules = {
			relativepath = function()
				local path = vim.api.nvim_buf_get_name(stbufnr())

				if path == "" then
					return ""
				end

				return "%#St_relativepath# " .. vim.fn.expand("%:.:h") .. "/"
			end,
		},
	},
}

M.base46 = {
	transparency = true,
	theme = "doomchad",
}

M.nvdash = {
	load_on_startup = true,
	header = { "yofsh", "", "" },
	-- buttons = {
	-- 	{
	-- 		txt = "  Find Projecct",
	-- 		keys = "Spc p p",
	-- 		cmd = "lua require'telescope'.extensions.project.project{display_type = 'full'}",
	-- 	},
	-- },
}

return M
