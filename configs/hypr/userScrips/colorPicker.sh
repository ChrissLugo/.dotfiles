color=$(hyprpicker -a | grep '^#')
if [ -n "$color" ]; then
    notify-send -h string:bgcolor:$color "🎨 Color copiado" "$color"
else
    notify-send "❌ No se seleccionó ningún color"
fi

