#!/usr/bin/env bash
set -e

# Visual formatting variables
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'
MAX_ATTEMPTS=3

# Global execution variables
DRY_RUN=false
APT_FLAGS="-y"
PACMAN_FLAGS="-Syu --needed"
DNF_FLAGS="-y"
ZYPPER_FLAGS="-y"
XBPS_FLAGS="-Syu"
APK_FLAGS="add"

# Catch the simulation flag passed by the user
if [[ "$1" == "--dry-run" ]] || [[ "$1" == "--pretend" ]]; then
    echo -e "${YELLOW}=== [SIMULATION ACTIVE]: Testing Script Infrastructure Legitely ===${NC}"
    DRY_RUN=true
    APT_FLAGS="-s -y --reinstall"                      
    PACMAN_FLAGS="-Syup"                                
    DNF_FLAGS="install --setopt=tsflags=test -y"        
    ZYPPER_FLAGS="install --dry-run -y"                 
    XBPS_FLAGS="-Syun"                                  
    APK_FLAGS="add --simulate"                          
else
    echo -e "${GREEN}=== Universal Multi-Distro Hyprland Installer ===${NC}"
fi

# 1. Broad Distro and Family Tree Detection Matrix
if [ -f /etc/os-release ]; then
    . /etc/os-release
    LIKE_IDS=" $ID_LIKE "
else
    echo -e "${RED}Error: Cannot read /etc/os-release${NC}"
    exit 1
fi

# Multi-family checks covering core systems, downstreams, and independents
if [[ "$ID" =~ ^(debian|ubuntu|linuxmint|pop|neon|zorin|elementary|devuan|kali)$ ]] || [[ "$LIKE_IDS" =~ "debian" ]] || [[ "$LIKE_IDS" =~ "ubuntu" ]]; then
    IS_APT_BASED=true; FAMILY="Debian/Ubuntu/Mint Family"
elif [[ "$ID" =~ ^(arch|cachyos|manjaro|endeavouros|garuda|artix|parabola)$ ]] || [[ "$LIKE_IDS" =~ "arch" ]]; then
    IS_ARCH=true; FAMILY="Arch Family"
elif [[ "$ID" =~ ^(fedora|rhel|centos|rocky|almalinux|nobara)$ ]] || [[ "$LIKE_IDS" =~ "fedora" ]]; then
    IS_FEDORA=true; FAMILY="Fedora Family"
elif [[ "$ID" =~ ^(gentoo|calculate|redcore|funtoo)$ ]] || [[ "$LIKE_IDS" =~ "gentoo" ]]; then
    IS_GENTOO=true; FAMILY="Gentoo Family"
elif [[ "$ID" =~ ^(opensuse|suse|tumbleweed|leap)$ ]] || [[ "$LIKE_IDS" =~ "suse" ]]; then
    IS_SUSE=true; FAMILY="openSUSE Family"
elif [[ "$ID" == "void" ]]; then
    IS_VOID=true; FAMILY="Void Linux (Independent)"
elif [[ "$ID" == "alpine" ]]; then
    IS_ALPINE=true; FAMILY="Alpine Linux (Independent)"
elif [[ "$ID" == "solus" ]]; then
    IS_SOLUS=true; FAMILY="Solus (Independent)"
else
    echo -e "${RED}Error: Distribution '$NAME' is unrecognized or independent.${NC}"
    exit 1
fi

echo -e "Target System Detected: ${YELLOW}$NAME${NC} ($FAMILY)"

# 2. Secure DEB822 Repository Setup for APT Systems
if [ "$IS_APT_BASED" = true ]; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]: Would configure official Wiki-Compliant Debian Forky DEB822 repository block...${NC}"
    else
        echo -e "${YELLOW}Purging older configuration remnants...${NC}"
        sudo rm -f /etc/apt/sources.list.d/hyprland-sid.list
        sudo rm -f /etc/apt/sources.list.d/sid.sources
        sudo rm -f /etc/apt/sources.list.d/forky.sources

        echo -e "${YELLOW}Deploying official Wiki-Compliant Debian Forky DEB822 repository block...${NC}"
        sudo tee /etc/apt/sources.list.d/forky.sources > /dev/null <<EOF
Types: deb
URIs: http://deb.debian.org/debian/
Suites: forky
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
EOF
        echo -e "${GREEN}Repository injected securely with standard validation keyrings.${NC}"
    fi
fi

# 3. Resilient Multi-Distro Package Installation Engine
install_packages() {
    local attempt=1
    while [ $attempt -le $MAX_ATTEMPTS ]; do
        echo -e "${YELLOW}Attempt $attempt of $MAX_ATTEMPTS: Syncing packages...${NC}"
        
        # --- DEBIAN / UBUNTU / MINT BRANCH ---
        if [ "$IS_APT_BASED" = true ]; then
            if [ "$DRY_RUN" = false ]; then
                if ! sudo apt-get update; then
                    echo -e "${RED}Warning: apt update failed on attempt $attempt.${NC}"
                    ((attempt++))
                    sleep 3
                    continue
                fi
                echo -e "${YELLOW}Executing full system upgrade to migrate core dependencies to Forky...${NC}"
                sudo apt-get dist-upgrade $APT_FLAGS
            else
                echo -e "${YELLOW}[DRY-RUN]: Simulating complete package transaction layouts...${NC}"
                sudo apt-get dist-upgrade $APT_FLAGS
            fi

            # Run actual desktop utilities deployment
            if sudo apt-get install $APT_FLAGS hyprland wayland-utils wl-clipboard grim slurp rofi-wayland dunst lxappearance xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar kitty nemo; then
                return 0
            fi

        # --- ARCH / ARTIX / CACHYOS BRANCH ---
        elif [ "$IS_ARCH" = true ]; then
            if sudo pacman $PACMAN_FLAGS hyprland wayland-utils wl-clipboard grim slurp rofi-wayland dunst lxappearance xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar kitty nemo; then
                return 0
            fi

        # --- FEDORA / NOBARA BRANCH ---
        elif [ "$IS_FEDORA" = true ]; then
            if sudo dnf $DNF_FLAGS hyprland wl-clipboard grim slurp rofi-wayland dunst kitty nemo wayland-utils xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar; then
                return 0
            fi

        # --- GENTOO / CALCULATE BRANCH ---
        elif [ "$IS_GENTOO" = true ]; then
            local EMERGE_CMD="sudo emerge --ask=n"
            [ "$DRY_RUN" = true ] && EMERGE_CMD="emerge --pretend"
            if $EMERGE_CMD gui-wm/hyprland gui-apps/wl-clipboard gui-apps/grim x11-misc/dunst gui-apps/hyprpaper gui-apps/waybar x11-terms/kitty x11-misc/rofi; then
                return 0
            fi

        # --- openSUSE TUMBLEWEED BRANCH ---
        elif [ "$IS_SUSE" = true ]; then
            if sudo zypper $ZYPPER_FLAGS hyprland wl-clipboard grim slurp rofi-wayland dunst kitty nemo xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar; then
                return 0
            fi

        # --- VOID LINUX BRANCH (INDEPENDENT) ---
        elif [ "$IS_VOID" = true ]; then
            if sudo xbps-install $XBPS_FLAGS hyprland wayland-utils wl-clipboard grim slurp rofi-wayland dunst lxappearance xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar kitty nemo; then
                return 0
            fi

        # --- ALPINE LINUX BRANCH (INDEPENDENT) ---
        elif [ "$IS_ALPINE" = true ]; then
            if sudo apk $APK_FLAGS hyprland wl-clipboard grim slurp rofi-wayland dunst lxappearance xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar kitty nemo; then
                return 0
            fi

        # --- SOLUS BRANCH (INDEPENDENT) ---
        elif [ "$IS_SOLUS" = true ]; then
            local eopkg_flags="install -y"
            [ "$DRY_RUN" = true ] && eopkg_flags="install --dry-run"
            if sudo eopkg $eopkg_flags hyprland wl-clipboard grim slurp rofi dunst kitty nemo waybar; then
                return 0
            fi
        fi

        echo -e "${RED}Warning: Package installation manager transaction dropped on attempt $attempt.${NC}"
        ((attempt++))
        [ $attempt -le $MAX_ATTEMPTS ] && sleep 3
    done
    return 1
}

# Fire the multi-manager installer loop
if ! install_packages; then
    echo -e "${RED}Error: Installation failed consistently after $MAX_ATTEMPTS attempts. Exiting.${NC}"
    exit 1
fi

# 4. Safe Configuration Symlinking
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY-RUN]: Would create links inside ~/.config/ directory structures safely...${NC}"
    echo -e "${GREEN}=== Simulation Completed Successfully with Zero System Errors! ===${NC}"
else
    echo -e "${GREEN}Deploying application configuration links...${NC}"
    mkdir -p ~/.config/hypr
    ln -sf "$(pwd)/.config/hypr/hyprland.lua" ~/.config/hypr/hyprland.lua
    echo -e "${GREEN}=== Setup Executed Perfectly! Launch your session via SDDM or run 'Hyprland' ===${NC}"
fi
