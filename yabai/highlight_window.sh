#!/usr/bin/env bash

echo 'Event Signal Received!'
echo $(yabai -m query --spaces --space)
windows="$(yabai -m query --spaces --space | jq '.windows')"
echo $windows
if [[ $windows == *","* ]]
then
  yabai -m config window_border on
  yabai -m config active_window_border_color "0xFFFF00" #FF0000

else
  yabai -m config window_border off
fi

