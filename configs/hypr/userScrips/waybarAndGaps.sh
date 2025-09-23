#!/bin/bash

if pgrep -x waybar >/dev/null; then
    # Si waybar está activo
    hyprctl keyword general:gaps_out 20
    pkill waybar
else
    # Si no está activo
    hyprctl keyword general:gaps_out "20, 20, 20, 5"
    waybar &
fi
