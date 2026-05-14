#!/bin/bash
DIR="$HOME/.config/waybar"

CONFIG_OPEN="$DIR/config_open"
STYLE_OPEN="$DIR/style_open.css"

CONFIG_CLOSE="$DIR/config_close"
STYLE_CLOSE="$DIR/style_close.css"

CONFIG_LYRICS="$DIR/lyrics"
STYLE_LYRICS="$DIR/lyrics.css"

if pgrep -f "waybar -c $CONFIG_OPEN" > /dev/null; then
    pkill waybar
    waybar -c "$CONFIG_CLOSE" -s "$STYLE_CLOSE" &
else
    pkill waybar
    waybar -c "$CONFIG_OPEN" -s "$STYLE_OPEN" &
fi

waybar -c "$CONFIG_LYRICS" -s "$STYLE_LYRICS"
