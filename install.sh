set -euo pipefail

#Variables
DOTFILES_DIR=$(pwd)

#utilidades
log() { printf '\e[1;34m[INFO] %s\e[0m %s\n' "$*"; }
warn() { printf '\e[1;33m[WARN] %s\e[0m %s\n' "$*"; }
err() { printf '\e[1;31m[ERROR] %s\e[0m %s\n' "$*"; }
ok() { printf '\e[1;32m[OK] %s\e[0m\n' "$*";}

#Listas
PACMAN_PACKAGES=(
    cava rofi-wayland hyprpicker nwg-displays
    brightnessctl swaync waybar nautilus zsh hyprshot zoxide wl-clipboard
    xdg-desktop-portal-hyprland hyprpolkitagent nwg-look
    ntfs-3g exfat-utils dosfstools syncthing lsd
    tesseract tesseract-data-eng xdg-utils foot
)

AUR_PACKAGES=(
    hellwal python-pywalfox
    ttf-nerd-fonts-symbols awww-git
    quickshell-git tofi fluent-icon-theme-git
    kripton-theme-git quickshell-overview-git kwybars-git vicinae-git 
)

install_pacman_packages() {
    log "Sincronizando bases e instalando paquetes de pacman..."
    sudo pacman -Sy --noconfirm #> /dev/null 2>&1
    sudo pacman -S --needed "${PACMAN_PACKAGES[@]}" #> /dev/null 2>&1
    ok "Paquetes Pacman instalados exitosamente"
}

install_aur_packages() {
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
    gsettings set org.gnome.desktop.interface icon-theme "Fluent orange dark"
    ok "Listo"

    #Themes
    gsettings set org.gnome.desktop.interface gtk-theme Kripton
    gsettings set org.gnome.desktop.wm.preferences theme Kripton
    ok "Listo"

    #Cursor
    hyprctl setcursor macOS 25 #> /dev/null 2>&1
    hyprctl reload #> /dev/null 2>&1

    #Hellwal
    log "Aplicando configuraciones de Hellwal..."
    rm -rf "$HOME/.config/hellwal"
    ln -srv "$DOTFILES_DIR/configs/hellwal" "$HOME/.config/hellwal" #> /dev/null 2>&1

    #Waybar
    log "Aplicando configuraciones de Waybar..."
    rm -rf "$HOME/.config/waybar"
    ln -srv "$DOTFILES_DIR/configs/waybar" "$HOME/.config/waybar" #> /dev/null 2>&1
    ok "Listo"

    #Matugen
    log "Aplicando configuraciones de Matugen..."
    rm -rf "$HOME/.config/matugen"
    ln -srv "$DOTFILES_DIR/configs/matugen" "$HOME/.config/matugen" #> /dev/null 2>&1
    ok "Listo"

    log "Aplicando configuraciones de kwybars..."
    rm -rf "$HOME/.config/kwybars"
    ln -srv "$DOTFILES_DIR/configs/kwybars" "$HOME/.config/kwybars" #> /dev/null 2>&1
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

    #Foot terminal
    log "Aplicando configuraciones de Foot terminal..."
    rm -rf "$HOME/.config/foot"
    ln -srv "$DOTFILES_DIR/configs/foot" "$HOME/.config/foot" #> /dev/null 2>&1
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

    log "Configurando aplicaciones..."
  
    #GTK
    sudo mkdir -p "$HOME/.config/gtk-3.0"
    sudo mkdir -p "$HOME/.config/gtk-4.0"

    echo "@import 'colors.css';" > "$HOME/.config/gtk-3.0/gtk.css"
    echo "@import 'colors.css';" > "$HOME/.config/gtk-4.0/gtk.css"

    # Aplica wallpaper
    sudo chmod +x "$DOTFILES_DIR/configs/hellwal/changeWallpaper.sh"
    sudo chmod +x "$DOTFILES_DIR/configs/rofi/selector.sh"
    ./configs/hellwal/changeWallpaper.sh ./configs/wallpaper.jpg
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
    sudo pacman -Syyu
    ok "Listo"

    # log "Detectando yay"

    # if command -v yay >/dev/null 2>&1; then
    #      log "Instalando yay"
    #      sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
    # fi

    # install_pacman_packages
    # install_aur_packages
    configs

    echo "
    ▄▖   ▌    ▜ ▘  ▗
    ▐ ▛▌▛▌▛▌  ▐ ▌▛▘▜▘▛▌
    ▐ ▙▌▙▌▙▌  ▐▖▌▄▌▐▖▙▌

    "
}

main "$@"
