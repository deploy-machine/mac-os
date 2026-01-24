local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 40,
  color = colors.bg_dark,
  padding_right = 2,
  padding_left = 2,
  position = "top",
  sticky = true,
})