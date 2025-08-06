set -euo pipefail

#Variables
DOTFILES_DIR=$(pwd)

#Instalar YAY
sudo pacman -S --needed --noconfirm base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd ..

#Instalar programas necesarios
sudo pacman -S --needed --noconfirm cava
sudo pacman -S --needed --noconfirm rofi-wayland
sudo pacman -S --needed --noconfirm hyprpicker
sudo pacman -S --needed --noconfirm swww
sudo pacman -S --needed --noconfirm otf-codenewroman-nerd
sudo pacman -S --needed --noconfirm nwg-displays
sudo pacman -S --needed --noconfirm pavucontrol
sudo pacman -S --needed --noconfirm brightnessctl
sudo pacman -S --needed --noconfirm networkmanager
sudo pacman -S --needed --noconfirm network-manager-applet
sudo pacman -S --needed --noconfirm nm-connection-editor
sudo pacman -S --needed --noconfirm dunst
sudo pacman -S --needed --noconfirm waybar
sudo pacman -S --needed --noconfirm nautilus
sudo pacman -S --needed --noconfirm zsh
sudo pacman -S --needed --noconfirm hyprshot
sudo pacman -S --needed --noconfirm zoxide
sudo pacman -S --needed --noconfirm wl-clipboard
sudo pacman -S --needed --noconfirm noto-fonts-emoji
yay -S --noconfirm --needed blueman-git  
yay -S --noconfirm --needed hellwal 
yay -S --noconfirm --needed waypaper
yay -S --noconfirm --needed python-pywalfox
yay -S --noconfirm --needed pokemon-colorscripts-git
yay -S --noconfirm --needed clipse

#               Configuraciónes 
#Hyprland
echo "Aplicando configuraciones de Hyprland..."
rm -rf "$HOME/.config/hypr"
ln -srv "$DOTFILES_DIR/configs/hypr" "$HOME/.config/hypr"
echo "Listo"

#Bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

#Iconos
echo "Aplicando iconos..."
rm -rf "$HOME/.local/share/icons"
ln -srv "$DOTFILES_DIR/configs/icons" "$HOME/.local/share"

gsettings set org.gnome.desktop.interface icon-theme "kora"

echo "Listo"

#Cursor
hyprctl setcursor macOS 25

hyprctl reload

#Red
sudo systemctl enable --now NetworkManager
nm-applet --indicator

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

#Dunst
echo "Aplicando configuraciones de Dunst..."
rm -rf "$HOME/.config/dunst"
ln -srv "$DOTFILES_DIR/configs/dunst" "$HOME/.config/dunst"
killall dunst
echo "Listo"

# OH MY ZSH 
set +e
export RUNZSH=no CHSH=no ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
rm -rf "$HOME/.oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
set -e

# plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

rm -f "$HOME/.zshrc"
ln -sv "$DOTFILES_DIR/configs/.zshrc" "$HOME/.zshrc"


#Fuentes
echo "Aplicando configuraciones de las Fuentes..."
rm -rf "$HOME/.local/share/fonts"
ln -srv "$DOTFILES_DIR/configs/fonts" "$HOME/.local/share/fonts"
echo "Listo"

#Cambiamos Fondo de Pantalla
swww-daemon &
swww img $DOTFILES_DIR/configs/wallpaper.jpg
hellwal -i $DOTFILES_DIR/configs/wallpaper.jpg --neon-mode --bright-offset 1 && pkill -USR2 waybar & pywalfox update &
waybar &



