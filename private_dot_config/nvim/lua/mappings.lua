require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Debug commands to check formatter availability
map("n", "<leader>debug", function()
  local conform = require("conform")
  print("=== Formatter Debug Info ===")
  
  -- Check if formatters are available
  local formatters = { "goimports", "gofumpt", "stylua", "black", "isort", "ruff", "shfmt" }
  for _, formatter in ipairs(formatters) do
    local info = conform.get_formatter_info(formatter)
    print(string.format("%s: available=%s, command=%s", 
      formatter, 
      tostring(info.available), 
      info.command or "not found"
    ))
  end
  
  -- Check Mason installations
  print("\n=== Mason Tool Status ===")
  local mason_registry = require("mason-registry")
  local tools = { "gopls", "pyright", "goimports", "gofumpt", "black", "isort", "ruff", "shfmt" }
  for _, tool in ipairs(tools) do
    local pkg = mason_registry.get_package(tool)
    local is_installed = pkg:is_installed()
    print(string.format("%s: installed=%s", tool, tostring(is_installed)))
  end
end, { desc = "Debug formatter availability" })

-- Check system PATH for tools
vim.api.nvim_create_user_command("CheckPath", function()
  print("=== System PATH Tool Check ===")
  local tools = { "goimports", "gofumpt", "gopls", "python", "black", "isort", "ruff", "shfmt" }
  for _, tool in ipairs(tools) do
    local exists = vim.fn.executable(tool) == 1
    local path = exists and vim.fn.exepath(tool) or "not found"
    print(string.format("%s: %s (%s)", tool, exists and "✓" or "✗", path))
  end
end, { desc = "Check if tools are in system PATH" })

-- Go specific mappings with verbose error reporting
map("n", "<leader>gf", function()
  require("conform").format({ formatters = { "goimports", "gofumpt" }, async = true })
end, { desc = "Go format and organize imports" })

map("n", "<leader>gi", function()
  -- Try conform first, fallback to LSP
  local success = pcall(require("conform").format, { formatters = { "goimports" }, async = true, timeout_ms = 3000 })
  if not success then
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end
end, { desc = "Go organize imports only" })

-- LSP-based import organization (fallback)
map("n", "<leader>go", function()
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, { desc = "Organize imports via LSP" })

-- General formatting
map("n", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

map("v", "<leader>fm", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format selection" })

-- LSP keymaps for better development experience
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic list" })

-- Go specific LSP keymaps and commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    map("n", "<leader>gt", "<cmd>lua vim.lsp.buf.execute_command({command = 'gopls.test', arguments = {vim.fn.expand('%:p')}})<cr>", { desc = "Go test file" })
    map("n", "<leader>gc", "<cmd>lua vim.lsp.buf.execute_command({command = 'gopls.generate_gopls_mod'})<cr>", { desc = "Go generate mod" })
    
    -- Custom Go commands
    vim.api.nvim_buf_create_user_command(0, "GoImports", function()
      local success = pcall(require("conform").format, { formatters = { "goimports" }, async = true, timeout_ms = 500 })
      if not success then
        vim.lsp.buf.code_action({
          context = { only = { "source.organizeImports" } },
          apply = true,
        })
      end
    end, { desc = "Organize Go imports" })
    
    vim.api.nvim_buf_create_user_command(0, "GoImportsLSP", function()
      vim.lsp.buf.code_action({
        context = { only = { "source.organizeImports" } },
        apply = true,
      })
    end, { desc = "Organize Go imports via LSP" })
    
    vim.api.nvim_buf_create_user_command(0, "GoFormat", function()
      require("conform").format({ formatters = { "goimports", "gofumpt" }, async = true })
    end, { desc = "Format Go file and organize imports" })
    
    vim.api.nvim_buf_create_user_command(0, "GoDebug", function()
      local conform = require("conform")
      print("=== Go Formatter Debug ===")
      
      local formatters = { "goimports", "gofumpt" }
      for _, formatter in ipairs(formatters) do
        local info = conform.get_formatter_info(formatter)
        print(string.format("%s:", formatter))
        print("  available:", info.available)
        print("  command:", info.command or "not found")
        print("  reason:", info.reason or "none")
      end
      
      -- Test if tools exist in PATH
      local goimports_exists = vim.fn.executable("goimports") == 1
      local gofumpt_exists = vim.fn.executable("gofumpt") == 1
      print("\nDirect PATH check:")
      print("  goimports in PATH:", goimports_exists)
      print("  gofumpt in PATH:", gofumpt_exists)
      
    end, { desc = "Debug Go formatter setup" })
    
    vim.api.nvim_buf_create_user_command(0, "GoLint", function()
      require("conform").format({ formatters = { "goimports", "gofumpt" }, async = true })
      vim.cmd("write")
    end, { desc = "Format, organize imports, and save" })
    
    -- Quick keymap for fixing imports without go.mod
    map("n", "<leader>gx", ":GoFixImports<CR>", { desc = "Quick fix missing imports", buffer = true })
  end,
})

-- Shell script formatting keymaps
map("n", "<leader>sf", function()
  require("conform").format({ formatters = { "shfmt" }, async = true })
end, { desc = "Format shell script" })

-- Shell-specific commands for different shell types
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    -- Shell formatting commands
    vim.api.nvim_buf_create_user_command(0, "ShellFormat", function()
      require("conform").format({ formatters = { "shfmt" }, async = true })
    end, { desc = "Format shell script with shfmt" })
    
    vim.api.nvim_buf_create_user_command(0, "ShellLint", function()
      require("conform").format({ formatters = { "shfmt" }, async = true })
      vim.cmd("write")
    end, { desc = "Format shell script and save" })
    
    -- Shell-specific keymaps
    map("n", "<leader>sf", function()
      require("conform").format({ formatters = { "shfmt" }, async = true })
    end, { desc = "Format shell script", buffer = true })
    
    map("n", "<leader>sl", function()
      require("conform").format({ formatters = { "shfmt" }, async = true })
      vim.cmd("write")
    end, { desc = "Format shell script and save", buffer = true })
  end,
})

-- Obsidian keymaps
map("n", "<leader>on", "<cmd>ObsidianNew<cr>", { desc = "Obsidian new note" })
map("n", "<leader>od", "<cmd>ObsidianToday<cr>", { desc = "Obsidian daily note" })
map("n", "<leader>oo", "<cmd>ObsidianOpen<cr>", { desc = "Obsidian open in app" })
map("n", "<leader>ob", "<cmd>ObsidianBacklinks<cr>", { desc = "Obsidian backlinks" })
map("n", "<leader>ot", "<cmd>ObsidianTags<cr>", { desc = "Obsidian tags" })
map("n", "<leader>ol", "<cmd>ObsidianLinks<cr>", { desc = "Obsidian links in note" })
-- Obsidian find/search
map("n", "<leader>off", "<cmd>ObsidianQuickSwitch<cr>", { desc = "Obsidian find file" })
map("n", "<leader>ofw", "<cmd>ObsidianSearch<cr>", { desc = "Obsidian find word (grep)" })
map("n", "<leader>ofl", "<cmd>ObsidianFollowLink<cr>", { desc = "Obsidian follow link" })
