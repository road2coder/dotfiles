local wezterm = require("wezterm")
local sys = { default_prog = { "nu" } }

if string.match(wezterm.target_triple, "darwin") then
  sys.set_environment_variables = {
    PATH = "/opt/homebrew/bin:" .. os.getenv("PATH"),
  }
end

return sys
