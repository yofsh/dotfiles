return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre',
    config = function()
      require "configs.conform"
    end,
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },

  {
  	"williamboman/mason.nvim",
  	opts = {
  		ensure_installed = {
  			"lua-language-server", "stylua",
  			"html-lsp", "css-lsp" , "prettierd",
        "bash-language-server", "typescript-language-server", "json-lsp"
  		},
  	},
  },
  {
  	"nvim-treesitter/nvim-treesitter",
  	opts = {
  		ensure_installed = {
  			"vim", "lua", "vimdoc",
       "html", "css", "scss" ,
        "hyprlang", "ssh_config",
        "toml", "yaml", "json"

  		},
  	},
  },
  {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    branch='v0.6', --recommended as each new version will have breaking changes
    opts={
        --Config goes here
    },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "VeryLazy",
    config = function()
      require('telescope').setup {
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
              require("telescope._extensions.project.actions").change_working_directory(prompt_bufnr, false)
              -- require("harpoon.ui").nav_file(1)
            end
          }
        }
      }
    end
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
     event = "VeryLazy",
    config = function() 
      require("codecompanion").setup({
        strategies = {
          chat = "ollama",
          inline = "ollama",
          agent = "ollama"
        },
      })
    end
  },
  { 
    'echasnovski/mini.ai',
    version = false,
    config = function() 
      require('mini.ai').setup()
    end,
    event = "VeryLazy",
  },
}
