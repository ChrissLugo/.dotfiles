#!/bin/bash

if pgrep -x waybar >/dev/null; then
    # Si waybar está activo
    hyprctl keyword general:gaps_out 10
    pkill waybar
else
    # Si no está activo
    hyprctl keyword general:gaps_out "10, 10, 10, 46"
    waybar &
fi
