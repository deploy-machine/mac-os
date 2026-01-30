local sbar = require("sketchybar")

-- Create aerospace workspace items
local function create_aerospace_workspaces()
  local handle = io.popen("aerospace list-workspaces --all")
  if not handle then return end
  
  local workspaces = {}
  for workspace in handle:lines() do
    if workspace and workspace ~= "" then
      local item_name = "space." .. workspace
      
      sbar.add("item", item_name, {
        position = "left",
        background = {
          color = 0x44ffffff,
          corner_radius = 5,
          height = 20,
          drawing = false
        },
        label = workspace,
        click_script = "aerospace workspace " .. workspace,
        script = "$CONFIG_DIR/plugins/aerospace.sh " .. workspace
      })
      
      -- Subscribe to aerospace workspace changes
      sbar.subscribe(item_name, "aerospace_workspace_change")
      
      table.insert(workspaces, item_name)
    end
  end
  handle:close()
end

-- Create workspace items
create_aerospace_workspaces()