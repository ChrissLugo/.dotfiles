if pgrep -x spotify >/dev/null; then
    hyprctl dispatch workspace 6
else
    # Nos movemos al escritorio 6 y movemos el cursor a la izquierda
    hyprctl dispatch workspace 6
    hyprctl dispatch movecursor 50 500  

    # Lanzamos Kitty con cava y Spotify 
    hyprctl dispatch exec "kitty -e cava"
    hyprctl dispatch exec "spotify"   

    sleep 1

    # Ponemos las ventanas en pila y ajustamos tamaño
    hyprctl dispatch togglesplit
    hyprctl dispatch resizeactive 0 400
fi





