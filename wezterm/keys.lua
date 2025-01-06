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
  { key = "n", mods = "LEADER", action = act.SpawnTab({ DomainName = "local" }) },
  { key = "q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "Q", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },
  { key = "{", mods = "CTRL|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "CTRL|SHIFT", action = act.MoveTabRelative(1) },

  --panels
  { key = "H", mods = "LEADER", action = act.SplitPane({ direction = "Left" }) },
  { key = "J", mods = "LEADER", action = act.SplitPane({ direction = "Down" }) },
  { key = "K", mods = "LEADER", action = act.SplitPane({ direction = "Up" }) },
  { key = "L", mods = "LEADER", action = act.SplitPane({ direction = "Right" }) },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "f", mods = "LEADER", action = act.TogglePaneZoomState },
  { key = "?", mods = "CTRL|SHIFT", action = wezterm.action.PaneSelect },
  { key = "h", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "j", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
  { key = "k", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "l", mods = "CTRL|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

  -- toggle maximize
  {
    key = "m",
    mods = "LEADER",
    action = wezterm.action_callback(function(window)
      local old_dim = window:get_dimensions()
      window:maximize()
      local new_dim = window:get_dimensions()
      if (old_dim.pixel_width == new_dim.pixel_width) and (old_dim.pixel_height == new_dim.pixel_height) then
        window:restore()
      end
    end),
  },
  { key = "t", mods = "LEADER", action = act.EmitEvent("trigger-log") },
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
