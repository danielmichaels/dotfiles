local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "goimports", "gofumpt" },
    python = { "isort", "black" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    rust = { "rustfmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    shfmt = {
      timeout_ms = 3000,
      args = {
        "-i", "2",  -- indent with 2 spaces
        "-ci",      -- indent switch cases
        "-sr",      -- redirect operators will be followed by a space
        "-kp",      -- keep column alignment paddings
      },
    },
    goimports = {
      timeout_ms = 500,
      cwd = function(ctx)
        local go_mod = vim.fn.findfile("go.mod", ".;")
        if go_mod ~= "" then
          return vim.fn.fnamemodify(go_mod, ":h")
        end
        return vim.fn.expand("%:p:h")
      end,
    },
    gofumpt = {
      timeout_ms = 500,
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
