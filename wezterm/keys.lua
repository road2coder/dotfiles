local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
  {
    key = "n",
    mods = "CTRL|SHIFT",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  { key = "{", mods = "SHIFT|ALT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "SHIFT|ALT", action = act.MoveTabRelative(1) },
  --  { key = 'r',  mods = 'SUPER',  action = act.ReloadConfiguration },
  --  { key = 'q',  mods = 'CTRL',   action = act.QuitApplication },
  --  -- tab
  --  { key = 'n',  mods = 'ALT',    action = act.SpawnTab 'CurrentPaneDomain' },
  --  { key = 'q',  mods = 'LEADER', action = act.CloseCurrentTab { confirm = false } },
  --  { key = '=',  mods = 'ALT',    action = act.ActivateTabRelative(1) },
  --  { key = '-',  mods = 'ALT',    action = act.ActivateTabRelative(-1) },
  --  { key = 'f',  mods = 'ALT',    action = act.ToggleFullScreen },
  --  -- move tab
  --  { key = ']',  mods = 'ALT',    action = act.MoveTabRelative(1) },
  --  { key = '[',  mods = 'ALT',    action = act.MoveTabRelative(-1) },
  --
  --  -- window
  --  { key = 'N',  mods = 'ALT',    action = act.SpawnWindow },
  --
  --  -- font size
  --  { key = '=',  mods = 'CTRL',   action = act.IncreaseFontSize },
  --  { key = '-',  mods = 'CTRL',   action = act.DecreaseFontSize },
  --  { key = '0',  mods = 'CTRL',   action = act.ResetFontSize },
  --
  --  --panel
  --  { key = 'j',  mods = 'ALT',    action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  --  { key = 'l',  mods = 'ALT',    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  --  { key = 'q',  mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
  --
  --  { key = 'h',  mods = 'CTRL',   action = act.ActivatePaneDirection 'Left' },
  --  { key = 'j',  mods = 'CTRL',   action = act.ActivatePaneDirection 'Down' },
  --  { key = 'k',  mods = 'CTRL',   action = act.ActivatePaneDirection 'Up' },
  --  { key = 'l',  mods = 'CTRL',   action = act.ActivatePaneDirection 'Right' },
  --  { key = 'z',  mods = 'CTRL',   action = act.TogglePaneZoomState },
  --
  --  { key = 'h',  mods = 'LEADER', action = act.AdjustPaneSize { 'Left', 5 } },
  --  { key = 'j',  mods = 'LEADER', action = act.AdjustPaneSize { 'Down', 5 } },
  --  { key = 'k',  mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  --  { key = 'l',  mods = 'LEADER', action = act.AdjustPaneSize { 'Right', 5 } },
  --
  --
  --  { key = '\\', mods = 'ALT',    action = act.QuickSelect },
  --
  --  { key = 'f',  mods = 'CTRL',   action = act.Search 'CurrentSelectionOrEmptyString' },
  --  { key = 'm',  mods = 'CTRL',   action = act.Hide },
  --  { key = 'P',  mods = 'CTRL',   action = act.ActivateCommandPalette },
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
  -- mouse = mouse,
}
