set -euo pipefail

#Variables
DOTFILES_DIR=$(pwd)

#Instalar programas necesarios
sudo pacman -S --needed --noconfirm cava
sudo pacman -S --needed --noconfirm rofi-wayland
sudo pacman -S --needed --noconfirm hyprpicker
sudo pacman -S --needed --noconfirm swww
sudo pacman -S --needed --noconfirm otf-codenewroman-nerd
sudo pacman -S --needed --noconfirm nwg-displays
sudo pacman -S --needed --noconfirm blueman  
sudo pacman -S --needed --noconfirm pavucontrol 
yay -S --noconfirm hellwal 
yay -S --noconfirm waypaper
yay -S --noconfirm python-pywalfox

#               Configuraciónes 
#Hyprland
echo "Aplicando configuraciones de Hyprland..."
rm -rf "$HOME/.config/hypr"
ln -srv "$DOTFILES_DIR/configs/hypr" "$HOME/.config/hypr"
hyprctl reload
echo "Listo"

#Waypaper
echo "Aplicando configuraciones de Waypaper..."
rm -rf "$HOME/.config/waypaper"
ln -srv "$DOTFILES_DIR/configs/waypaper" "$HOME/.config/waypaper"
echo "Listo"

#Hellwal
echo "Aplicando configuraciones de Hellwal..."

rm -rf "$HOME/.config/hellwal"
ln -srv "$DOTFILES_DIR/configs/hellwal" "$HOME/.config/hellwal"

mkdir -p ~/.cache/hellwal
mkdir -p ~/.cache/wal

ln -sf ~/.cache/hellwal/colors ~/.cache/wal/colors
ln -sf ~/.cache/hellwal/colors.json ~/.cache/wal/colors.json

echo "Listo"

#Waybar
echo "Aplicando configuraciones de Waybar..."
rm -rf "$HOME/.config/waybar"
ln -srv "$DOTFILES_DIR/configs/waybar" "$HOME/.config/waybar"
echo "Listo"

#Rofi
echo "Aplicando configuraciones de Rofi..."
rm -rf "$HOME/.config/rofi"
ln -srv "$DOTFILES_DIR/configs/rofi" "$HOME/.config/rofi"
echo "Listo"

#Kitty
echo "Aplicando configuraciones de Kitty..."
rm -rf "$HOME/.config/kitty"
ln -srv "$DOTFILES_DIR/configs/kitty" "$HOME/.config/kitty"
echo "Listo"

#Cambiamos Fondo de Pantalla
swww-daemon &
swww img $DOTFILES_DIR/configs/wallpaper.jpg
hellwal -i $DOTFILES_DIR/configs/wallpaper.jpg --neon-mode --bright-offset 1 && pkill -USR2 waybar & pywalfox update &





