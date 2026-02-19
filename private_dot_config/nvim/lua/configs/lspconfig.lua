-- Neovim 0.11+ LSP configuration using vim.lsp.config
local nvlsp = require "nvchad.configs.lspconfig"

-- Common config for all LSP servers
local function make_config(settings)
  return vim.tbl_deep_extend("force", {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }, settings or {})
end

-- Go language server
vim.lsp.config("gopls", make_config({
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}))

-- Python language server
vim.lsp.config("pyright", make_config({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
      },
    },
  },
}))

-- HTML language server
vim.lsp.config("html", make_config())

-- CSS language server
vim.lsp.config("cssls", make_config())

-- Enable the servers
vim.lsp.enable({ "gopls", "pyright", "html", "cssls" })