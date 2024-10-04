return {
	{
		"nvim-telescope/telescope.nvim",
		opts = function()
			local conf = require("nvchad.configs.telescope")
			conf.defaults = {
				mappings = {
					i = {
						["<C-Down>"] = require("telescope.actions").cycle_history_next,
						["<C-up"] = require("telescope.actions").cycle_history_prev,
					},
				},
				layout_config = {
					horizontal = { width = 0.99, height = 0.99 },
				},
			}
			return conf
		end,
	},
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre',
		config = function()
			require("configs.conform")
		end,
	},

	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},

	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"lua-language-server",
				"stylua",
				"html-lsp",
				"css-lsp",
				"prettierd",
				"bash-language-server",
				"typescript-language-server",
				"json-lsp",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"scss",
				"hyprlang",
				"ssh_config",
				"toml",
				"yaml",
				"json",
			},
		},
	},
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6", --recommended as each new version will have breaking changes
		opts = {
			--Config goes here
		},
	},
	{
		"nvim-telescope/telescope-project.nvim",
		event = "VeryLazy",
		config = function()
			require("telescope").setup({
				extensions = {
					project = {
						-- base_dirs = {
						--   '~/dev/src',
						--   {'~/dev/src2'},
						--   {'~/dev/src3', max_depth = 4},
						--   {path = '~/dev/src4'},
						--   {path = '~/dev/src5', max_depth = 2},
						-- },
						-- hidden_files = true, -- default: false
						-- theme = "dropdown",
						-- order_by = "asc",
						-- search_by = "title",
						-- sync_with_nvim_tree = true, -- default false
						-- default for on_project_selected = find project files
						on_project_selected = function(prompt_bufnr)
							-- Do anything you want in here. For example:
							require("telescope._extensions.project.actions").change_working_directory(
								prompt_bufnr,
								false
							)
							-- require("harpoon.ui").nav_file(1)
						end,
					},
				},
			})
		end,
	},
	-- {
	-- 	"olimorris/codecompanion.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		-- require("codecompanion").setup({
	-- 		--   strategies = {
	-- 		--     chat = "ollama",
	-- 		--     inline = "ollama",
	-- 		--     agent = "ollama"
	-- 		--   },
	-- 		-- })
	--
	-- 		require("codecompanion").setup({
	-- 			adapters = {
	-- 				openai = function()
	-- 					return require("codecompanion.adapters").extend("openai", {
	-- 						env = {
	-- 						},
	-- 					})
	-- 				end,
	-- 				strategies = {
	-- 					chat = "openai",
	-- 					inline = "openai",
	-- 					agent = "openai",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
	{
		"echasnovski/mini.ai",
		version = false,
		config = function()
			require("mini.ai").setup()
		end,
		event = "VeryLazy",
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			require("mini.surround").setup({
				-- Add custom surroundings to be used on top of builtin ones. For more
				-- information with examples, see `:h MiniSurround.config`.
				custom_surroundings = nil,

				-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
				highlight_duration = 500,

				-- Module mappings. Use `''` (empty string) to disable one.
				mappings = {
					add = "ys", -- Add surrounding in Normal and Visual modes
					delete = "ds", -- Delete surrounding
					-- find = 'sf', -- Find surrounding (to the right)
					-- find_left = 'sF', -- Find surrounding (to the left)
					-- highlight = 'sh', -- Highlight surrounding
					replace = "cs", -- Replace surrounding
					update_n_lines = "ns", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},

				-- Number of lines within which surrounding is searched
				n_lines = 20,

				-- Whether to respect selection type:
				-- - Place surroundings on separate lines in linewise mode.
				-- - Place surroundings on each line in blockwise mode.
				respect_selection_type = false,

				-- How to search for surrounding (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
				-- see `:h MiniSurround.config`.
				search_method = "cover",

				-- Whether to disable showing non-error feedback
				silent = false,
			})
		end,
		event = "VeryLazy",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	},
	{
		event = "VeryLazy",
		"ruifm/gitlinker.nvim",
		config = function() end,
	},
	{
		event = "VeryLazy",
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
}
