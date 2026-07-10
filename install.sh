set -euo pipefail

#Variables
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

#Utilidades
log() { printf '\e[1;34m[INFO]\e[0m %s\n' "$*"; }
warn() { printf '\e[1;33m[WARN]\e[0m %s\n' "$*"; }
err() { printf '\e[1;31m[ERROR]\e[0m %s\n' "$*"; }
ok() { printf '\e[1;32m[OK]\e[0m %s\n' "$*"; }

#Listas
PACMAN_PACKAGES=(
    # Hyprland y piezas del compositor (imprescindibles en una PC en blanco)
    hyprland hyprlock hypridle sddm polkit hyprpolkitagent
    xdg-desktop-portal-hyprland
    # Audio
    pipewire pipewire-pulse pipewire-alsa wireplumber
    # Red y bluetooth
    networkmanager bluez bluez-utils
    # Utilidades usadas en hyprland.lua / waybar / rofi
    cava rofi-wayland hyprpicker nwg-displays hyprshutdown scrcpy
    brightnessctl swaync swayosd waybar nautilus zsh hyprshot zoxide wl-clipboard
    nwg-look pacman-contrib
    ntfs-3g exfat-utils dosfstools syncthing lsd
    tesseract tesseract-data-eng xdg-utils foot
    awww matugen
    # Dependencias de compilación para hyprpm (plugins de hyprland)
    cpio cmake meson gcc
    # Terminal SSH: banner + arte + fuzzy finder
    pokemon-colorscripts-git toilet fzf
)

AUR_PACKAGES=(
    python-pywalfox kwybars-bin vicinae-bin
)

# Rutas (relativas a configs/<componente>/) que Matugen regenera en cada
# equipo a partir del wallpaper local. Nunca deben quedar simlinkeadas al
# repo: si lo estuvieran, escribir ahí modificaría un archivo dentro de
# ~/.dotfiles, que se sincroniza por Syncthing entre las PCs, y el cambio
# de color de una máquina se propagaría a la otra.
MATUGEN_GENERATED_FILES=(
    "waybar/colors.css"
    "rofi/rofi_theme.rasi"
    "kwybars/themes/kwybars_custom.toml"
)

is_generated() {
    local needle="$1" f
    for f in "${MATUGEN_GENERATED_FILES[@]}"; do
        [ "$needle" = "$f" ] && return 0
    done
    return 1
}

ensure_hyprpm_plugin() {
    local url="$1" name="$2" state

    state=$(hyprpm list | sed -r 's/\x1b\[[0-9;]*[a-zA-Z]//g')

    if grep -q "Repository $name" <<< "$state"; then
        log "hyprpm: $name ya está agregado"
    else
        hyprpm add "$url"
        state=$(hyprpm list | sed -r 's/\x1b\[[0-9;]*[a-zA-Z]//g')
    fi

    if grep -A2 "Repository $name" <<< "$state" | grep -q "enabled: true"; then
        log "hyprpm: $name ya está habilitado"
    else
        hyprpm enable "$name"
    fi
}

set_permissions() {
    log "Dando permisos de ejecución a los scripts..."
    local file
    while IFS= read -r -d '' file; do
        chmod +x "$file"
    done < <(find "$DOTFILES_DIR" -type f \( -name "*.sh" -o -name "screenrecorder" \) -not -path "*/matugen/templates/*" -print0)
    ok "Permisos aplicados"
}

check_yay() {
    if command -v yay >/dev/null 2>&1; then
        log "yay ya está instalado"
        return
    fi

    log "yay no encontrado, instalando..."
    sudo pacman -S --needed --noconfirm git base-devel
    local tmpdir
    tmpdir=$(mktemp -d)
    git clone https://aur.archlinux.org/yay.git "$tmpdir/yay"
    (cd "$tmpdir/yay" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
    ok "yay instalado"
}

install_pacman_packages() {
    log "Sincronizando bases e instalando paquetes de pacman..."
    sudo pacman -Sy --noconfirm
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
    ok "Paquetes Pacman instalados exitosamente"
}

install_aur_packages() {
    log "Instalando paquetes AUR con yay..."
    yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"
    ok "Paquetes AUR instalados exitosamente"
}

# Vincula únicamente los archivos individuales de configs/<component>,
# nunca la carpeta completa, para que los archivos que Matugen regenera
# (ver MATUGEN_GENERATED_FILES) queden fuera del repo y no se sincronicen
# entre equipos. El directorio destino queda como carpeta real, no symlink.
link_config() {
    local component="$1"
    local src="$DOTFILES_DIR/configs/$component"
    local dest="$HOME/.config/$component"

    if [ ! -d "$src" ]; then
        warn "No existe $src, se omite"
        return
    fi

    # Migra instalaciones previas donde la carpeta completa era un symlink
    if [ -L "$dest" ]; then
        rm -f "$dest"
    fi
    mkdir -p "$dest"

    local file rel target linked=0 skipped=0
    while IFS= read -r -d '' file; do
        rel="${file#"$src"/}"

        case "$rel" in
            *.sync-conflict-*|*.bak.*)
                continue
                ;;
        esac

        if is_generated "$component/$rel"; then
            skipped=$((skipped + 1))
            continue
        fi

        target="$dest/$rel"
        mkdir -p "$(dirname "$target")"
        ln -sfr "$file" "$target"
        linked=$((linked + 1))
    done < <(find "$src" -type f -print0)

    ok "$component: $linked archivo(s) vinculado(s), $skipped generado(s) por Matugen respetado(s)"
}

configs(){
    #Red y Bluetooth
    log "Habilitando NetworkManager y Bluetooth..."
    sudo systemctl enable --now NetworkManager
    sudo systemctl enable --now bluetooth
    ok "Listo"

    #Cursor
    hyprctl setcursor Bibata-Modern-Ice 25 || true
    hyprctl reload || true

    #Config por-archivo (nunca por-carpeta) de cada componente
    for component in hypr waybar matugen kwybars rofi foot swayosd; do
        log "Aplicando configuración de $component..."
        link_config "$component"
    done

    # Intalacion de plugins (idempotente: hyprpm falla si el repo ya está agregado)
    hyprpm update

    ensure_hyprpm_plugin "https://github.com/sandwichfarm/hyprexpo" "hyprexpo"
    ensure_hyprpm_plugin "https://github.com/virtcode/hypr-dynamic-cursors" "dynamic-cursors"

    hyprpm reload

    # OH MY ZSH
    export RUNZSH=no CHSH=no ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Instalando OMZSH"
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        ok "Listo"
    else
        log "OMZSH ya está instalado, se omite"
    fi

    log "Instalando plugins de OMZSH"
    [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
    [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    [ -d "$HOME/.zsh/fzf-tab" ] || git clone https://github.com/Aloxaf/fzf-tab.git "$HOME/.zsh/fzf-tab"
    ok "Listo"

    ln -sfr "$DOTFILES_DIR/configs/.zshrc" "$HOME/.zshrc"

    #Shell por defecto
    log "Configurando zsh como shell predeterminada..."
    sudo chsh -s "$(command -v zsh)" "$USER"
    ok "Listo"

    #GTK
    log "Configurando GTK..."
    mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
    echo "@import 'colors.css';" > "$HOME/.config/gtk-3.0/gtk.css"
    ok "Listo"

    #Wallpapers y esquema de color (matugen)
    log "Copiando wallpapers y generando esquema de color..."
    local wall_dir="$HOME/Pictures/Wallpapers"
    mkdir -p "$wall_dir"
    local dotfiles_wallpapers=("$DOTFILES_DIR"/configs/Wallpapers/*.jpg)
    cp -f "${dotfiles_wallpapers[@]}" "$wall_dir/"
    local random_wallpaper="$wall_dir/$(basename "${dotfiles_wallpapers[RANDOM % ${#dotfiles_wallpapers[@]}]}")"
    matugen image "$random_wallpaper" -m dark --verbose --source-color-index 0
    ok "Listo"

    #Fuentes vendorizadas en configs/fonts (Nerd Font Symbols, Cascadia Code)
    log "Instalando fuentes..."
    local font_dir font_src font_dest
    for font_dir in "$DOTFILES_DIR"/configs/fonts/*/; do
        font_src="${font_dir%/}"
        font_dest="$HOME/.local/share/fonts/$(basename "$font_src")"
        mkdir -p "$font_dest"
        cp -f "$font_src"/*.ttf "$font_dest/"
    done
    fc-cache -f "$HOME/.local/share/fonts" >/dev/null
    ok "Listo"

    #Tema de cursor Bibata (hyprcursor, vectorial en SVG, no se pixela al agrandar)
    log "Instalando tema de cursor Bibata-Modern-Ice..."
    local cursor_dest="$HOME/.local/share/icons/Bibata-Modern-Ice"
    mkdir -p "$cursor_dest"
    cp -rf "$DOTFILES_DIR/configs/cursors/Bibata-Modern-Ice/." "$cursor_dest/"
    ok "Listo"
}

printTitle(){
   printf '\e[1;32m%s\e[0m\n' "
    .__                     .__  __          
    |  |  __ __  ____  __ __|__|/  |_  ____  
    |  | |  |  \/ ___\|  |  \  \   __\/  _ \ 
    |  |_|  |  / /_/  >  |  /  ||  | (  <_> )
    |____/____/\___  /|____/|__||__|  \____/ 
            /_____/                        
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
    sudo pacman -Syyu --noconfirm
    ok "Listo"

    set_permissions

    check_yay

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
