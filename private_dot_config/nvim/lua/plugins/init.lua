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
                    "rust-analyzer",
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
       "html", "css", "go", "python", "bash", "rust", "toml",
       "markdown", "markdown_inline",
    		},
    	},
    },

    -- Rust development with cargo integration
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        ft = { "rust" },
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                        local nvlsp = require "nvchad.configs.lspconfig"
                        nvlsp.on_attach(client, bufnr)
                        local map = vim.keymap.set
                        local opts = { buffer = bufnr, silent = true }
                        map("n", "<leader>rr", "<cmd>RustLsp runnables<cr>", vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
                        map("n", "<leader>rt", "<cmd>RustLsp testables<cr>", vim.tbl_extend("force", opts, { desc = "Rust testables" }))
                        map("n", "<leader>rb", "<cmd>terminal cargo build<cr>", vim.tbl_extend("force", opts, { desc = "Rust cargo build" }))
                        map("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", vim.tbl_extend("force", opts, { desc = "Open Cargo.toml" }))
                        map("n", "<leader>re", "<cmd>RustLsp explainError<cr>", vim.tbl_extend("force", opts, { desc = "Explain error" }))
                        map("n", "<leader>rx", "<cmd>RustLsp expandMacro<cr>", vim.tbl_extend("force", opts, { desc = "Expand macro" }))
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = { allFeatures = true },
                            checkOnSave = { command = "clippy" },
                        },
                    },
                },
            }
        end,
    },

    -- Inline markdown rendering
    {
      "MeanderingProgrammer/render-markdown.nvim",
      ft = { "markdown", "Avante" },
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {},
    },

    -- Obsidian integration for note-taking
    {
      "epwalsh/obsidian.nvim",
      version = "*",
      lazy = true,
      ft = "markdown",
      cmd = {
        "ObsidianNew",
        "ObsidianToday",
        "ObsidianYesterday",
        "ObsidianSearch",
        "ObsidianOpen",
        "ObsidianQuickSwitch",
        "ObsidianFollowLink",
        "ObsidianBacklinks",
        "ObsidianTags",
        "ObsidianLinks",
      },
      dependencies = { "nvim-lua/plenary.nvim" },
      init = function()
        vim.api.nvim_create_autocmd("FileType", {
          pattern = { "markdown" },
          callback = function()
            vim.opt_local.conceallevel = 2
          end,
        })
      end,
      opts = {
        workspaces = {
          { name = "synadia", path = "~/Documents/synadia-obsidian/synadia" },
        },
        daily_notes = {
          folder = "dailies",
          date_format = "%d-%m-%Y",
        },
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },
        new_notes_location = "current_dir",
        picker = { name = "telescope.nvim" },
        attachments = {
          img_folder = "attachments",
        },
      },
    },
}
