#!/bin/sh
# Battery plugin for SketchyBar

if [ "$SENDER" = "forced" ] || [ "$SENDER" = "routine" ]; then
  battery_percentage=$(pmset -g batt | grep -Eo '[0-9]{1,3}%' | sed 's/%//')
  charging=$(pmset -g batt | grep 'AC Power')
  
  if [ -n "$charging" ]; then
    icon="󰂄"
    color=0xffa6e3a1
  elif [ "$battery_percentage" -gt 80 ]; then
    icon="󰁹"
    color=0xffa6e3a1
  elif [ "$battery_percentage" -gt 60 ]; then
    icon="󰂂"
    color=0xfff9e2af
  elif [ "$battery_percentage" -gt 40 ]; then
    icon="󰁿"
    color=0xffebcb8b
  elif [ "$battery_percentage" -gt 20 ]; then
    icon="󰁾"
    color=0xfff92672
  else
    icon="󰁻"
    color=0xfff92672
  fi
  
  sketchybar --set $NAME icon="$icon" label="${battery_percentage}%" icon.color=$color
fi