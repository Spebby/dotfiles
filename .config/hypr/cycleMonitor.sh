#!/bin/bash

focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$1" = "move" ]; then
    hyprctl dispatch split-changemonitor next
fi

if [ "$focused_monitor" = "eDP-1" ]; then
    hyprctl dispatch focusmonitor HDMI-A-1
else
    hyprctl dispatch focusmonitor eDP-1
fi
