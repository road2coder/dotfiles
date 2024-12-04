local wezterm = require("wezterm")

-- event: gui-startup
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("update-status", function(window)
  local date = wezterm.strftime("%b %-d %H:%M ")

  window:set_right_status(wezterm.format({
    { Text = " " },
    { Foreground = { Color = "#74c7ec" } },
    { Background = { Color = "rgba(0,0,0,0.4)" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = " " ..wezterm.nerdfonts.fa_calendar .. " " .. date },
    { Text = " " },
  }))
end)

-- tabs title: z means zoomed
wezterm.on("format-tab-title", function(tab, _, _, _, _)
  local suffix = tab.active_pane.is_zoomed and "z " or " "
  return {
    { Text = " " .. tab.tab_index + 1 .. suffix },
  }
end)

-- custom events
wezterm.on("trigger-max-window", function(window)
  window:maximize()
end)
