local wezterm = require("wezterm")

-- event: gui-startup
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("update-status", function(window)
  local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")

  window:set_right_status(wezterm.format({
    { Text = " " },
    { Foreground = { Color = "#74c7ec" } },
    { Background = { Color = "rgba(0, 0, 0 ,0.2)" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = "  " .. date .. " " },
  }))
end)

-- tabs title: z means zoomed
wezterm.on("format-tab-title", function(tab, _, _, _, _)
  local suffix = tab.active_pane.is_zoomed and "z " or " "
  return {
    { Text = " " .. tab.tab_index + 1 .. suffix },
  }
end)

wezterm.on("trigger-log", function(window)
  local screens = wezterm.gui.screens()
  wezterm.log_info(screens)
end)
