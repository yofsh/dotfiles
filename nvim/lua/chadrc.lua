-- This file  needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/NvChad/blob/v2.5/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "ayu_dark",
  transparency = true,
  cmp = {
    style = "atom_colored"
  },
  -- telescope = {
  --   style = "borderless"
  -- }
   telescope = { style = "borderless" },
}


return M
