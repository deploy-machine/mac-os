local sbar = require("sketchybar")
local colors = require("colors")

-- Helper function to update clock
local function update_clock()
  local time = os.date("%H:%M")
  local date = os.date("%a %d %b")
  sbar.set("clock", { label = time .. "  " .. date })
end

-- Helper function to update wifi
local function update_wifi()
  local handle = io.popen("wifi-info")
  if handle then
    local wifi_info = handle:read("*a")
    handle:close()
    if wifi_info and wifi_info ~= "" then
      sbar.set("wifi", { label = wifi_info:gsub("\n", "") })
    else
      sbar.set("wifi", { label = "No WiFi" })
    end
  else
    sbar.set("wifi", { label = "WiFi: ???" })
  end
end

-- Helper function to update battery
local function update_battery()
  local handle = io.popen("pmset -g batt | grep -Eo '\\d+%' | cut -d% -f1")
  if handle then
    local percentage = handle:read("*a"):gsub("%s+", "")
    handle:close()
    
    local charging_handle = io.popen("pmset -g batt | grep 'AC Power'")
    local charging = charging_handle:read("*a")
    charging_handle:close()
    
    local icon = "􀢋"
    if charging and charging ~= "" then
      icon = "􀢋"
    elseif tonumber(percentage) and tonumber(percentage) < 20 then
      icon = "􀛪"
    end
    
    sbar.set("battery", { label = percentage .. "%" })
  end
end

-- Helper function to update volume
local function update_volume(env)
  local volume = env.INFO
  if volume then
    local icon = "􀊥"
    if volume == "0" then
      icon = "􀊢"
    elseif volume:match("^[6-9][0-9]") or volume == "100" then
      icon = "􀊨"
    elseif volume:match("^[3-5][0-9]") then
      icon = "􀊥"
    end
    sbar.set("volume", { label = volume .. "%", icon = icon })
  end
end

-- Helper function to update spaces
local function update_spaces(env)
  for i = 1, 10 do
    local space_name = "space." .. i
    local selected = env.SELECTED == tostring(i)
    sbar.set(space_name, {
      background = { 
        color = selected and colors.accent_red or colors.bg_dark1 
      }
    })
  end
end

-- Helper function to update front app
local function update_front_app(env)
  if env.INFO then
    sbar.set("front_app", { label = env.INFO })
  end
end

-- Event callbacks
sbar.add("item", "clock_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("clock_callback", {
  function(env)
    update_clock()
  end,
  "routine",
  "system_woke"
})

sbar.add("item", "wifi_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("wifi_callback", {
  function(env)
    update_wifi()
  end,
  "routine",
  "system_woke"
})

sbar.add("item", "battery_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("battery_callback", {
  function(env)
    update_battery()
  end,
  "routine",
  "system_woke",
  "power_source_change"
})

sbar.add("item", "volume_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("volume_callback", {
  function(env)
    update_volume(env)
  end,
  "volume_change"
})

sbar.add("item", "spaces_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("spaces_callback", {
  function(env)
    update_spaces(env)
  end,
  "space_change",
  "aerospace_workspace_change"
})

sbar.add("item", "front_app_callback", {
  drawing = false,
  updates = true,
})
sbar.subscribe("front_app_callback", {
  function(env)
    update_front_app(env)
  end,
  "front_app_switched"
})

-- Initial updates
update_clock()
update_wifi()
update_battery()