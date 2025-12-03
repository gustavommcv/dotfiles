#!/bin/bash

if pgrep -x "rofi" > /dev/null; then
  pkill rofi
else
  rofi -show drun
  # rofi -show drun -modi drun,filebrowser,run,window
fi
