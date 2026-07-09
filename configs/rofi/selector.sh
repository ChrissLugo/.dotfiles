WALL_DIR="$HOME/Pictures/Wallpapers"
MI_SCRIPT="$HOME/.config/hellwal/changeWallpaper.sh"
CACHE_DIR="$HOME/.cache/rofi-wallpapers-square"

mkdir -p "$CACHE_DIR"

SELECCION=$(
    find "$WALL_DIR" -maxdepth 1 -type f -iregex '.*\.\(jpg\|jpeg\|png\|webp\)' | sort | while read -r img; do
        nombre=$(basename "$img")
        miniatura="$CACHE_DIR/${nombre}"

        if [ ! -f "$miniatura" ]; then
            magick "$img" -thumbnail 300x300^ -gravity center -extent 300x300 -quality 60 "$miniatura" 2>/dev/null || \
            convert "$img" -thumbnail 300x300^ -gravity center -extent 300x300 -quality 60 "$miniatura"
        fi

        echo -en "${nombre}\0icon\x1f${miniatura}\n"
    done | rofi -dmenu -i -p "  Fondo" -show-icons -theme ~/.config/rofi/wallpapers.rasi
)

if [ -n "$SELECCION" ]; then
    # magick "$WALL_DIR/$SELECCION" "/home/lugo/.cache/current_wallpaper.png"
    #awww img "$WALL_DIR/$SELECCION" --transition-type wipe --transition-angle 240 --transition-step 90 --transition-fps 120 --transition-duration 1.5 
    matugen image "$WALL_DIR/$SELECCION" -m dark --verbose  --source-color-index 0
    #wait
fi
