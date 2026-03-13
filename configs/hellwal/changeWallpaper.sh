WALLPAPER=$1

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    echo "Error: Proporciona una ruta válida al wallpaper."
    exit 1
fi

awww img "$WALLPAPER" --transition-type wipe --transition-angle 240 --transition-step 90 --transition-fps 120 --transition-duration 1

FILE_HASH=$(echo -n "$WALLPAPER" | md5sum | awk '{print $1}')
THUMB_CACHE_DIR="$HOME/.cache/wall_thumbs"
THUMBNAIL="$THUMB_CACHE_DIR/${FILE_HASH}.png"

mkdir -p "$THUMB_CACHE_DIR"

if [ ! -f "$THUMBNAIL" ]; then
    magick "$WALLPAPER" -resize 16x16\! "$THUMBNAIL"
fi

hellwal -i "$THUMBNAIL" --check-contrast --neon-mode --bright-offset 0.5

orbit reload-theme
nautilus -q > /dev/null 2>&1 &
pywalfox update &
