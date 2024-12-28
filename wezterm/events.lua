local wezterm = require("wezterm")

-- event: gui-startup
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local _, _, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on("update-right-status", function(window)
  local date = wezterm.strftime("%Y-%m-%d %H:%M:%S")

  window:set_right_status(wezterm.format({
    { Text = " " },
    { Foreground = { Color = "#232536" } },
    { Background = { Color = "rgba(0, 0, 0, 0.3)" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = "  " .. date .. " " },
  }))
end)

-- tabs title: z means zoomed
wezterm.on("format-tab-title", function(tab)
  local cn_chars = { "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖", "拾" }
  local suffix = (tab.active_pane.is_zoomed and #tab.panes > 1) and "z " or " "
  local i = tab.tab_index + 1
  wezterm.log_info({
    zoomed = tab.active_pane.is_zoomed and #tab.panes > 1,
    length = #tab.panes,
    is_zoomed = tab.active_pane.is_zoomed,
    index = i,
  })
  local text = " " .. (cn_chars[i] or i) .. suffix
  wezterm.log_info(#tab.panes)
  return {
    { Foreground = { Color = tab.is_active and "#681da8" or "" } },
    { Text = text },
  }
end)

wezterm.on("trigger-log", function(window)
  local screens = wezterm.gui.screens()
  wezterm.log_info(screens)
end)
