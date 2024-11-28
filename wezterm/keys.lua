local wezterm = require("wezterm")
local act = wezterm.action

local leader = { key = "c", mods = "CTRL" }

local keys = {
  -- Send "CTRL-C" to the terminal when pressing CTRL-C twice
  {
    key = "c",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendKey({ key = "c", mods = "CTRL" }),
  },
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },

  -- tabs
  { key = "n", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "{", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },

  --panels
  { key = "h", mods = "LEADER", action = act.SplitPane({ direction = "Left" }) },
  { key = "j", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
  { key = "k", mods = "LEADER", action = act.SplitPane({ direction = "Up" }) },
  { key = "l", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },
  { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
}

local mouse = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
}

return {
  keys = keys,
  leader = leader,
}
