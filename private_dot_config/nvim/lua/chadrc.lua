-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "ayu_dark",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}

-- M.nvdash = { load_on_startup = true }
M.ui = {
  statusline = {
    modules = {
      cwd = function()
        local cwd = vim.uv.cwd()
        if not cwd or cwd == "" then
          return ""
        end

        local sep_style = require("nvconfig").ui.statusline.separator_style
        local sep_icons = require("nvchad.stl.utils").separators
        local separators = (type(sep_style) == "table" and sep_style) or sep_icons[sep_style] or sep_icons.default
        local name = cwd:match "([^/\\]+)[/\\]*$" or cwd

        return vim.o.columns > 85 and ("%#St_cwd_sep#" .. separators.left .. "%#St_cwd_icon#󰉋 %#St_cwd_text# " .. name .. " ") or ""
      end,
    },
  },
}

return M
