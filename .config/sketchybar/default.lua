local colors = require("colors")

-- Default properties that will be applied to all items unless overridden
sbar.default({
  position = "right",
  align = "center",
  background = {
    height = 28,
    corner_radius = 8,
    color = colors.bg_dark1,
    border_width = 0,
  },
  icon = {
    font = {
      family = "sketchybar-app-font",
      style = "Bold",
      size = 14.0,
    },
    color = colors.fg,
    padding_left = 8,
    padding_right = 8,
    string_width = 25,
  },
  label = {
    font = {
      family = "SF Mono",
      style = "Medium",
      size = 13.0,
    },
    color = colors.fg,
    padding_left = 8,
    padding_right = 8,
    string_width = 25,
  },
})