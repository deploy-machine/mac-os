#!/bin/sh
# Clock plugin for SketchyBar

if [ "$SENDER" = "forced" ] || [ "$SENDER" = "routine" ]; then
  time=$(date +"%H:%M")
  sketchybar --set $NAME icon="" label="$time"
fi