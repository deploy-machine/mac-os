#!/bin/sh
# Volume plugin for SketchyBar

if [ "$SENDER" = "forced" ] || [ "$SENDER" = "routine" ]; then
  volume=$(osascript -e 'output volume of (get volume settings)')
  muted=$(osascript -e 'output muted of (get volume settings)')
  
  if [ "$muted" = "true" ]; then
    icon="婢"
    sketchybar --set $NAME icon="$icon" label="Muted"
  else
    if [ "$volume" -gt 66 ]; then
      icon=""
    elif [ "$volume" -gt 33 ]; then
      icon=""
    elif [ "$volume" -gt 0 ]; then
      icon=""
    else
      icon="婢"
    fi
    sketchybar --set $NAME icon="$icon" label="${volume}%"
  fi
fi