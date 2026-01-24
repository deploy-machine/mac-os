#!/bin/sh
# Plugin for Aerospace workspace display

if [ "$SENDER" = "forced" ] || [ "$SENDER" = "routine" ]; then
  workspace=$(aerospace list-workspaces --focused)
  sketchybar --set $NAME label="$workspace"
fi