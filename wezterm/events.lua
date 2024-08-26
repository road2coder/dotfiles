local wezterm = require("wezterm")

-- event: gui-startup
local mux = wezterm.mux
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = mux.spawn_window(cmd or {})
-- 	window:gui_window():set_inner_size(1000, 600)
-- 	window:gui_window():set_position(100, 100)
-- end)
--
-- -- event: update-status
wezterm.on("update-status", function(window)
  local date = wezterm.strftime("%b %-d %H:%M ")

  -- local bat_str = ''

  -- for _, bat in ipairs(wezterm.battery_info()) do
  --   bat_str = bat_str .. string.format('%.0f%%', bat.state_of_charge * 100)
  -- end

  window:set_right_status(wezterm.format({
    { Text = " " },
    { Foreground = { Color = "#74c7ec" } },
    { Background = { Color = "rgba(0,0,0,0.4)" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = wezterm.nerdfonts.fa_calendar .. " " .. date },
    { Text = " " },
  }))
end)
--
-- -- event: format-tab-title
--
wezterm.on("format-tab-title", function(tab, _, _, _, _)
  -- i do not like how i can basically hide tabs if i zoom in
  local is_zoomed = ""
  if tab.active_pane.is_zoomed then
    is_zoomed = "z"
  end

  return {
    { Text = " " .. tab.tab_index + 1 .. is_zoomed .. " " },
  }
end)
