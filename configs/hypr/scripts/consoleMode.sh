#!/bin/bash

# 1. MATAR STEAM SI YA ESTÁ CORRIENDO
# Cerramos cualquier instancia para que pueda abrirse en modo consola sin errores
pkill -9 steam
sleep 1

# 2. VARIABLES DE ACELERACIÓN (Vital para tu GTX 1050)
# Sin esto, la interfaz de consola te irá lenta como antes
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json

# 3. LANZAR EN MODO CONSOLA
# -gamepadui: La interfaz de Steam Deck
# -steamos3: Habilita funciones de mando y menús de energía
# gamescope -f -W 1920 -H 1080 -r 165 -e -- steam -gamepadui     
systemd-inhibit --who="SteamConsole" --why="Gaming" --what=idle:sleep \
gamescope -f -W 1920 -H 1080 -r 165 -e -- steam -gamepadui