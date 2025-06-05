local lint = require("lint")

-- Configure linters by filetype
lint.linters_by_ft = {
  python = { "ruff" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
  zsh = { "shellcheck" },
}

-- Create autocmd group for linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

-- Set up automatic linting on save only
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = lint_augroup,
  callback = function()
    local ft = vim.bo.filetype
    if lint.linters_by_ft[ft] then
      pcall(lint.try_lint)
    end
  end,
})