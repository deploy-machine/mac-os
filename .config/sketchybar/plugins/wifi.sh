#!/bin/sh
# WiFi plugin for SketchyBar

if [ "$SENDER" = "forced" ] || [ "$SENDER" = "routine" ]; then
  wifi_name=$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')
  wifi_signal=$(airport -I | grep agrCtlRSSI | awk '{print $2}')
  
  if [ -n "$wifi_name" ]; then
    sketchybar --set $NAME icon="" label="$wifi_name"
  else
    sketchybar --set $NAME icon="睊" label="No WiFi"
  fi
fi