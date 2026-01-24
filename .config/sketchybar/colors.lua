local colors = require("colors")

return {
  -- Background colors from MilkOutside theme
  bg = "#040607", -- Dark background
  bg_dark = "#000000", -- Pure black background
  bg_dark1 = "#1a1e2e", -- Slightly lighter dark background
  bg_highlight = "#0f0f15", -- Background highlight color
  bg_popup = "#040607", -- Background for popups
  bg_search = "#292e42", -- Background for search results
  bg_sidebar = "#040607", -- Background for sidebars
  bg_visual = "#394b70", -- Background for selected areas

  -- Foreground colors
  fg = "#e8e8e8", -- Foreground text color (light gray)
  fg_dark = "#e0e0e0", -- Darker foreground text color
  fg_gutter = "#595959", -- Gutter text color
  fg_sidebar = "#e0e0e0", -- Foreground text color in sidebar

  -- Comment color
  comment = "#595959", -- Comment text color (gray)

  -- Grays from neutral palette
  dark3 = "#303030", -- Dark gray
  dark5 = "#474747", -- Mid-gray

  -- Blue colors
  blue = "#63c3dd", -- Light blue
  blue0 = "#48b5c7", -- Slightly darker blue
  blue1 = "#4fd1e0", -- Cyanish blue
  blue2 = "#62b9e8", -- Lighter blue
  blue5 = "#a7e3ff", -- Very light blue
  blue6 = "#daffff", -- Pale cyan
  blue7 = "#394b70", -- Dark blue

  -- Cyan
  cyan = "#7dcfff", -- Cyan color

  -- Green colors
  green = "#92cf9c", -- Light green
  green1 = "#5dd48c", -- Mid green
  green2 = "#3a9b6d", -- Darker green

  -- Magenta/Purple colors
  magenta = "#e79cfb", -- Light magenta
  magenta2 = "#f93a82", -- Bright pinkish magenta
  purple = "#9d7cd8", -- Soft purple

  -- Orange/Yellow colors
  orange = "#ffad00", -- Bright orange
  yellow = "#f8e063", -- Pale yellow

  -- Red colors (Primary accent color)
  red = "#fda1a0", -- Light red
  red1 = "#e45555", -- Darker red

  -- Teal
  teal = "#1abc9c", -- Teal color

  -- Terminal black
  terminal_black = "#1b1b1b", -- Dark terminal background

  -- Git colors
  git = {
    add = "#449dab", -- Added line color (blue)
    change = "#6183bb", -- Changed line color (blue)
    delete = "#914c54", -- Deleted line color (red)
  },

  -- Additional accent colors
  accent_blue = "#63d0df", -- Light blue accent
  accent_indigo = "#a1c1eb", -- Indigo accent
  accent_purple = "#e79cfb", -- Purple accent
  accent_pink = "#ff9cb1", -- Pink accent
  accent_red = "#fda1a0", -- Red accent (primary)
  accent_orange = "#ffad00", -- Orange accent
  accent_yellow = "#f8e063", -- Yellow accent
  accent_green = "#92cf9c", -- Green accent
  accent_warm_grey = "#cabbba", -- Warm gray accent
}