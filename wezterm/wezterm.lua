local function merge(...)
  local result = {}
  for _, t in ipairs({ ... }) do
    for k, v in pairs(t) do
      result[k] = v
    end
  end
  return result
end
local wezterm = require("wezterm")
local config = wezterm.config_builder()

require("events")
local ui = require("ui")
local keys = require("keys")
return merge(config, ui, keys, { default_prog = { "nu" } })
