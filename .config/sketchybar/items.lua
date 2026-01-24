local sbar = require("sketchybar")
local colors = require("colors")

-- Add spaces
local spaces = {}
for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    icon = {
      string = i,
      padding_left = 8,
      padding_right = 8,
    },
    label = {
      drawing = false,
    },
    background = {
      color = colors.bg_dark1,
      corner_radius = 6,
    },
    click_script = "aerospace workspace " .. i,
  })
  spaces[i] = space
end

-- Front app indicator
local front_app = sbar.add("item", "front_app", {
  icon = {
    drawing = false,
  },
  label = {
    font = {
      family = "SF Mono",
      style = "Medium",
      size = 13.0,
    },
    color = colors.fg,
  },
})

-- Clock
sbar.add("item", "clock", {
  icon = {
    string = "􀐫",
    color = colors.accent_red, -- Bright red as primary color
  },
  label = {
    font = {
      family = "SF Mono", 
      style = "Medium",
      size = 13.0,
    },
    color = colors.fg,
    align = "right",
  },
  update_freq = 10,
})

-- WiFi
sbar.add("item", "wifi", {
  icon = {
    string = "􀙇",
    color = colors.accent_red, -- Bright red as primary color
  },
  label = {
    font = {
      family = "SF Mono",
      style = "Medium", 
      size = 13.0,
    },
    color = colors.fg,
    align = "right",
  },
  update_freq = 5,
})

-- Battery
sbar.add("item", "battery", {
  icon = {
    string = "􀢋",
    color = colors.accent_red, -- Bright red as primary color
  },
  label = {
    font = {
      family = "SF Mono",
      style = "Medium",
      size = 13.0,
    },
    color = colors.fg,
    align = "right",
  },
  update_freq = 60,
})

-- Volume
sbar.add("item", "volume", {
  icon = {
    color = colors.accent_red, -- Bright red as primary color
  },
  label = {
    font = {
      family = "SF Mono",
      style = "Medium",
      size = 13.0,
    },
    color = colors.fg,
    align = "right",
  },
})

-- Subscribe to events
sbar.add("item", "space_events", {
  drawing = false,
  updates = true,
})
sbar.subscribe("space_events", {
  "space_change",
  "space_windows_change",
})

-- Update clock every second
sbar.add("item", "clock_update", {
  drawing = false,
  updates = true,
})
sbar.subscribe("clock_update", {
  "system_woke",
  "routine",
})

-- Subscribe to system events
sbar.subscribe("front_app", {
  "front_app_switched",
})

sbar.subscribe("volume", {
  "volume_change",
})

sbar.subscribe("battery", {
  "system_woke", 
  "power_source_change",
})