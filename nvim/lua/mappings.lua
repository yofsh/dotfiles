require("nvchad.mappings")

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("n", "<leader><space>", "<cmd>Telescope find_files<CR>", { desc = "Telescope Find files" })
map(
	"n",
	"<leader>fd",
	"<cmd>Telescope find_files search_dirs=~/dotfiles,~/nix<CR>",
	{ desc = "Telescope Find dotfiles" }
)
map(
	"n",
	"<leader>fc",
	"<cmd>Telescope find_files search_dirs=~/.config/nvim/lua<CR>",
	{ desc = "Telescope Find config files" }
)

map("n", "<leader>pp", function()
	require("telescope").extensions.project.project({ display_type = "full" })
end, { desc = "Telecope Find project" })

map(
	"n",
	"<C-p>",
	":lua require'telescope'.extensions.project.project{display_type = 'full'}<CR>",
	{ desc = "Telescope Find project" }
)

map("n", "<leader>rr", "<cmd>Telescope resume<CR>", { desc = "Telescope Resume last search" })

map("n", "<A-x>", "<cmd>Telescope commands<CR>", { desc = "Telescope Find vim command" })
map("n", "<A-z>", "<cmd>Telescope command_history<CR>", { desc = "Telescope Find command history" })
map("n", "<leader>ht", "<cmd>Telescope help_tags<CR>", { desc = "Telescope Find vim help tags" })
map("n", "<leader>ho", "<cmd>Telescope vim_options<CR>", { desc = "Telescope Find vim options" })

map("n", "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<CR>", { desc = "Telescope Find buffer short" })
map("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Telescope Live grep short" })
map("n", "<leader>?", '<cmd>:lua require("telescope").extensions.live_grep_args.live_grep_args()<CR>')

map(
	"n",
	"<leader>8",
	':lua require\'telescope.builtin\'.live_grep({default_text = vim.fn.expand("<cword>"), shorten_path = true, word_match = "-w"} )<CR>',
	{ desc = "Telescope Find word in a proect" }
)
map(
	"n",
	"<leader>*",
	":lua require'telescope.builtin'.live_grep({default_text = vim.fn.expand(\"<cword>\")})<CR>",
	{ desc = "Telescope Find word in a proect" }
)

map("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Telescope Git banches" })

map(
	"n",
	"<leader>gG",
	'<cmd>!footclient -e zsh -c "source ~/.zshrc; lazygit"<CR>',
	{ desc = "Terminal LazyGit in separate terminal" }
)
map("n", "<leader>gg", function()
	require("nvchad.term").toggle({
		pos = "float",
		id = "lazygit",
		cmd = "lazygit;exit",
		float_opts = {
			border = "single",
			width = 0.98,
			height = 0.95,
		},
	})
end, { desc = "Terminal LazyGit" })

map({ "n", "t" }, "<A-`>", function()
	require("nvchad.term").toggle({
		pos = "float",
		id = "float",
		float_opts = {
			border = "single",
			width = 1,
			height = 0.6,
		},
	})
end, { desc = "Terminal Toggle Floating term" })

map("n", "<leader>cf", ":lua vim.lsp.buf.format()<CR>", { desc = "LSP Format buffer" })
map("n", "<leader>E", "yyp:.!zsh<CR>", { desc = "Misc execute row under curson in ZSH" })

-- AI
map("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
map("v", "<C-a>", "<cmd>CodeCompanionActions<cr>")
map("n", "<LocalLeader>a", "<cmd>CodeCompanionToggle<cr>", { desc = "CodeCompanion Toggle Chat" })
map("v", "<LocalLeader>a", "<cmd>CodeCompanionToggle<cr>")
map("v", "ga", "<cmd>CodeCompanionAdd<cr>", { desc = "CodeCompanion Add code to a chat" })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- Typescript
map("n", "<leader>lo", "<cmd>TSToolsOrganizeImports<CR>", { desc = "Typescript Orginize imports" })
map("n", "<leader>lr", "<cmd>TSToolsRemoveUnused<CR>", { desc = "Typescript Remove unused imports" })
map("n", "<leader>lm", "<cmd>TSToolsAddMissingImports <CR>", { desc = "Typescript Add missing imports" })

map(
	"n",
	"<leader>lO",
	":TSToolsAddMissingImports<cr>:TSToolsOrganizeImports<cr>:TSToolsRemoveUnused<cr>",
	{ desc = "Add missing + Orginize + Removed unused" }
)

-- Git Signs
local gs = require("gitsigns")
map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
map("n", "<leader>hS", gs.stage_buffer)
map("n", "<leader>hu", gs.undo_stage_hunk)
map("n", "<leader>hR", gs.reset_buffer)
map("n", "<leader>hp", gs.preview_hunk)
map("n", "<leader>hb", function()
	gs.blame_line({ full = true })
end)
map("n", "<leader>tb", gs.toggle_current_line_blame)
map("n", "<leader>hd", gs.diffthis)
map("n", "<leader>hD", function()
	gs.diffthis("~")
end)
map("n", "<leader>td", gs.toggle_deleted)

-- Text object
map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
