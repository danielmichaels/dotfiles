return {
    {
      "stevearc/conform.nvim",
      event = 'BufWritePre', -- format on save enabled
      opts = require "configs.conform",
      keys = {
        {
          "<leader>fm",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          mode = { "n", "v" },
          desc = "Format file or range (in visual mode)",
        },
      },
    },

    -- Mason for automatic LSP server installation
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    -- LSP servers
                    "gopls",
                    "pyright",
                    -- Formatters
                    "goimports",
                    "gofumpt",
                    "black",
                    "isort",
                    "shfmt",
                    -- Linters
                    "ruff",
                    "shellcheck",
                },
            })
        end,
    },

    -- These are some examples, uncomment them if you want to see them work!
    {
        "neovim/nvim-lspconfig",
        dependencies = { "mason.nvim" },
        config = function()
            require "configs.lspconfig"
        end,
    },

    -- Linting support
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require "configs.lint"
        end,
    },

    -- test new blink
    -- { import = "nvchad.blink.lazyspec" },

    {
    	"nvim-treesitter/nvim-treesitter",
    	opts = {
    		ensure_installed = {
    			"vim", "lua", "vimdoc",
       "html", "css", "go", "python", "bash"
    		},
    	},
    },
}
