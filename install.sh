set -euo pipefail

#Variables
DOTFILES_DIR=$(pwd)
HAS_YAY=0

#Detectar yay
if command -v yay >/dev/null 2>&1; then HAS_YAY=1; fi

#utilidades
log() { printf '\e[1;34m[INFO] %s\e[0m %s\n' "$*"; }
warn() { printf '\e[1;33m[WARN] %s\e[0m %s\n' "$*"; }
err() { printf '\e[1;31m[ERROR] %s\e[0m %s\n' "$*"; }
ok() { printf '\e[1;32m[OK] %s\e[0m\n' "$*";}

#Listas
PACMAN_PACKAGES=(
    cava rofi-wayland hyprpicker otf-codenewroman-nerd nwg-displays
    pavucontrol brightnessctl network-manager-applet nm-connection-editor
    dunst waybar nautilus zsh hyprshot zoxide wl-clipboard noto-fonts-emoji
    xdg-desktop-portal-hyprland hyprpolkitagent nwg-look qt5-quickcontrols2
    layer-shell-qt qt5ct qt6ct qt5-wayland qt6-wayland kvantum
    ntfs-3g exfat-utils dosfstools syncthing grim imagemagick hyprlock lsd 
    tesseract tesseract-data-eng curl jq libnotify xdg-utils


)

AUR_PACKAGES=(
    blueman-git hellwal waypaper python-pywalfox pokemon-colorscripts-git 
    clipse nmgui-bin bongocat ttf-nerd-fonts-symbols swww-git swayosd-git
    ttf-meslo-nerd wayscriber quickshell-git tofi
)

install_pacman_packages() {
    log "Sincronizando bases e instalando paquetes de pacman..."
    sudo pacman -Sy --noconfirm #> /dev/null 2>&1
    sudo pacman -S --needed "${PACMAN_PACKAGES[@]}" #> /dev/null 2>&1
    ok "Paquetes Pacman instalados exitosamente"
}

install_aur_packages() {
    if [ "$HAS_YAY" -ne 1 ]; then
        warn "No encontré 'yay'. Saltando instalación AUR. Si quieres instalar AUR, instala yay o adapta el script."
    return
    fi
        log "Instalando paquetes AUR con yay..."
        yay -S --needed "${AUR_PACKAGES[@]}" #> /dev/null 2>&1
        ok "Paquetes AUR instalados exitosamente"

}

configs(){
    #Hyprland
    log "Aplicando configuraciones de Hyprland..."
    rm -rf "$HOME/.config/hypr"
    ln -srv "$DOTFILES_DIR/configs/hypr" "$HOME/.config/hypr" #> /dev/null 2>&1
    ok "Listo"

    #Clipse
    log "Aplicando configuraciones de Clipse..."
    rm -rf "$HOME/.config/clipse"
    ln -srv "$DOTFILES_DIR/configs/clipse" "$HOME/.config/clipse" #> /dev/null 2>&1
    ok "Listo"

    #Bluetooth
    sudo systemctl start bluetooth
    sudo systemctl enable bluetooth

    #Iconos
    log "Aplicando iconos..."
    rm -rf "$HOME/.local/share/icons"
    ln -srv "$DOTFILES_DIR/configs/icons" "$HOME/.local/share" #> /dev/null 2>&1

    gsettings set org.gnome.desktop.interface icon-theme "kora"

    ok "Listo"

    #Themes
    log "Aplicando temas..."
    rm -rf "$HOME/.local/share/themes"
    ln -srv "$DOTFILES_DIR/configs/themes" "$HOME/.local/share" #> /dev/null 2>&1

    gsettings set org.gnome.desktop.interface gtk-theme Kripton
    gsettings set org.gnome.desktop.wm.preferences theme Kripton
    ok "Listo"

    #Cursor
    hyprctl setcursor macOS 25 #> /dev/null 2>&1
    hyprctl reload #> /dev/null 2>&1

    #Red
    sudo systemctl enable --now NetworkManager

    #Waypaper
    log "Aplicando configuraciones de Waypaper..."
    rm -rf "$HOME/.config/waypaper"
    ln -srv "$DOTFILES_DIR/configs/waypaper" "$HOME/.config/waypaper" #> /dev/null 2>&1
    ok "Listo"

    #Hellwal
    log "Aplicando configuraciones de Hellwal..."
    rm -rf "$HOME/.config/hellwal"
    ln -srv "$DOTFILES_DIR/configs/hellwal" "$HOME/.config/hellwal" #> /dev/null 2>&1

    mkdir -p ~/.cache/hellwal
    mkdir -p ~/.cache/wal

    ln -sf ~/.cache/hellwal/colors ~/.cache/wal/colors #> /dev/null 2>&1
    ln -sf ~/.cache/hellwal/colors.json ~/.cache/wal/colors.json #> /dev/null 2>&1

    ok "Listo"

    #Waybar
    log "Aplicando configuraciones de Waybar..."
    rm -rf "$HOME/.config/waybar"
    ln -srv "$DOTFILES_DIR/configs/waybar" "$HOME/.config/waybar" #> /dev/null 2>&1
    ok "Listo"

    #sddm
    log "Aplicando configuraciones de SDDM..."
    sudo rm -f "/etc/sddm.conf"
    sudo ln -srv "$DOTFILES_DIR/configs/sddm.conf" "/etc/sddm.conf" #> /dev/null 2>&1
    
    #sddm minecraft theme
    sudo rm -rf ~/sddm-theme-minesddm
    git clone https://github.com/Davi-S/sddm-theme-minesddm.git ~/sddm-theme-minesddm #> /dev/null 2>&1
    sudo cp -r ~/sddm-theme-minesddm/minesddm /usr/share/sddm/themes/
    sudo rm -rf ~/sddm-theme-minesddm
    ok "Listo"

    #kvantum themes
    sudo rm -rf ./KvLibadwaita
    git clone https://github.com/GabePoel/KvLibadwaita.git #> /dev/null 2>&1
    cd KvLibadwaita
    ./install.sh
    sudo rm -rf ~/KvLibadwaita
    sudo rm -rf ./KvLibadwaita
    ok "Listo"

    #Overview
    sudo rm -rf ~/.config/quickshell/overview/
    git clone https://github.com/Shanu-Kumawat/quickshell-overview ~/.config/quickshell/overview  #> /dev/null 2>&1
    ok "Listo"

    #Hyprquickshot
    sudo rm -rf ~/.config/quickshell/hyprquickshot
    git clone https://github.com/jamdon2/hyprquickshot ~/.config/quickshell/hyprquickshot #> /dev/null 2>&1
    ok "Listo"

    #Rofi
    log "Aplicando configuraciones de Rofi..."
    rm -rf "$HOME/.config/rofi"
    ln -srv "$DOTFILES_DIR/configs/rofi" "$HOME/.config/rofi" #> /dev/null 2>&1
    ok "Listo"

    #Tofi
    log "Aplicando configuraciones de tofi..."
    rm -rf "$HOME/.config/tofi"
    ln -srv "$DOTFILES_DIR/configs/tofi" "$HOME/.config/tofi" #> /dev/null 2>&1
    ok "Listo"

    #Kitty
    log "Aplicando configuraciones de Kitty..."
    rm -rf "$HOME/.config/kitty"
    ln -srv "$DOTFILES_DIR/configs/kitty" "$HOME/.config/kitty" #> /dev/null 2>&1
    ok "Listo"

    #Dunst
    log "Aplicando configuraciones de Dunst..."
    rm -rf "$HOME/.config/dunst"
    ln -srv "$DOTFILES_DIR/configs/dunst" "$HOME/.config/dunst" #> /dev/null 2>&1
    ok "Listo"

    # OH MY ZSH 
    log "instalando OMZSH"
    export RUNZSH=no CHSH=no ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    export RUNZSH=no CHSH=no ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    rm -rf "$HOME/.oh-my-zsh"
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" #> /dev/null 2>&1
    ok "Listo"

    # plugins
    log "instalando plugins de OMZSH"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" #> /dev/null 2>&1
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" #> /dev/null 2>&1
    ok "Listo"

    rm -f "$HOME/.zshrc"
    ln -sv "$DOTFILES_DIR/configs/.zshrc" "$HOME/.zshrc" #> /dev/null 2>&1

    #Bongocat
    sudo usermod -a -G input $USER

    # Fuentes
    log "Aplicando configuraciones de las Fuentes..."
    mkdir -p "$HOME/.local/share"
    rm -rf "$HOME/.local/share/fonts"
    ln -s "$DOTFILES_DIR/configs/fonts" "$HOME/.local/share/fonts"
    fc-cache -fv > /dev/null 2>&1
    ok "Listo"

    mkdir -p ~/.config/quickshell 
    rm -rf ~/.config/quickshell/HyprQuickSnip
    git clone https://github.com/Ronin-CK/HyprQuickSnip.git ~/.config/quickshell/HyprQuickSnip
    
    log "Configurando aplicaciones..."
    # Inicia daemon si no está
    if ! pgrep -x swww-daemon >/dev/null; then
    swww-daemon &
    # Espera a que el socket exista
    while ! swww query >/dev/null 2>&1; do
        sleep 0.1
    done
fi

    # Aplica wallpaper
    swww img "$DOTFILES_DIR/configs/wallpaper.jpg" #> /dev/null 2>&1

    # Hellwal
    hellwal -i "$DOTFILES_DIR/configs/wallpaper.jpg" --neon-mode --bright-offset 1  #> /dev/null 2>&1

    pkill -USR2 waybar #> /dev/null 2>&1

    # Actualiza pywalfox
    pywalfox update & #> /dev/null 2>&1

    # Bongocat
    bongocat -t -c "$DOTFILES_DIR/configs/bongocat/bongocat.conf" #> /dev/null 2>&1 &

    ok "Listo"
}

printTitle(){
   printf '\e[1;32m%s\e[0m\n' "
    __________.____                                 
    \____    /|    |    __ __  ____   ____          
      /     / |    |   |  |  \/ ___\ /  _ \         
     /     /_ |    |___|  |  / /_/  >  <_> )        
    /_______ \|_______ \____/\___  / \____/         
            \/        \/    /_____/                 
        .___      __    _____.__.__                 
      __| _/_____/  |__/ ____\__|  |   ____   ______
     / __ |/  _ \   __\   __\|  |  | _/ __ \ /  ___/
    / /_/ (  <_> )  |  |  |  |  |  |_\  ___/ \___ \ 
    \____ |\____/|__|  |__|  |__|____/\___  >____  >
         \/                               \/     \/ 
    "
}

main() {
    
    printTitle
    log "Actualizando sistema antes de comenzar"
    sudo pacman -Syy #> /dev/null 2>&1
    sudo pacman -Syu #> /dev/null 2>&1
    ok "Listo"
    
    install_pacman_packages
    install_aur_packages
    configs

    echo "
    ▄▖   ▌    ▜ ▘  ▗   
    ▐ ▛▌▛▌▛▌  ▐ ▌▛▘▜▘▛▌
    ▐ ▙▌▙▌▙▌  ▐▖▌▄▌▐▖▙▌
                   
    "
}

main "$@"

