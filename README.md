# Debian & Multi-Distro Hyprland Dotfiles

A custom Hyprland configuration utilizing a Lua-style config wrapper (`hl` API). It features dynamic refresh rate switching and automated installation scripts optimized for AMD hardware.

---

## 🚀 Installation

### Option 1: Automated Script (Multi-Distro)
The included installation script automatically detects and configures your system. It supports:
* **Arch Linux** (and derivatives)
* **Debian / Ubuntu** (and derivatives)
* **Void Linux**
* **Solus**
* **Gentoo**

To run the installer:
```bash
chmod +x install.sh
./install.sh
```

### Option 2: Manual Fallback Steps (By Distribution)
If the script fails while you are distro-hopping, use these verified command blocks to install the dependencies manually, then symlink your dotfiles.

#### 🟦 Arch Linux & Derivatives
```bash
sudo pacman -Syu --needed hyprland hyprpaper xdg-desktop-portal-hyprland waybar dunst kitty nemo wl-clipboard grim slurp wf-recorder rofi lxappearance
```

#### 🟪 Debian / Ubuntu & Derivatives
> ⚠️ **Note:** Hyprland is not packaged in the Debian Stable repos. You must enable Debian Backports, compile from source, or use a third-party repository.
```bash
sudo apt update && sudo apt install -y wayland-utils wl-clipboard grim slurp wf-recorder rofi dunst lxappearance xdg-desktop-portal xdg-desktop-portal-hyprland hyprpaper waybar kitty nemo
```

#### 🟩 Void Linux
```bash
sudo xbps-install -Syu hyprland hyprpaper xdg-desktop-portal-hyprland waybar dunst kitty nemo wl-clipboard grim slurp wf-recorder rofi lxappearance
```

#### 🟦 Solus
```bash
sudo eopkg it hyprland hyprpaper xdg-desktop-portal-hyprland waybar dunst kitty nemo wl-clipboard grim slurp wf-recorder rofi lxappearance
```

#### 🟫 Gentoo
Ensure your Wayland and desktop global `USE` flags are configured in `/etc/portage/make.conf` before compiling:
```bash
sudo emerge --ask gui-wm/hyprland gui-apps/hyprpaper gui-libs/xdg-desktop-portal-hyprland gui-apps/waybar x11-misc/dunst x11-terms/kitty gnome-extra/nemo gui-apps/wl-clipboard gui-apps/grim gui-apps/slurp gui-apps/wf-recorder x11-misc/rofi x11-misc/lxappearance
```

#### 🔗 Link Your Configuration File
Once your packages are installed, finish the manual setup by symlinking the config to your home folder:
```bash
mkdir -p ~/.config/hypr
ln -s \$(pwd)/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua
```

---

## ⚙️ Configuration & Refresh Rate

The configuration builds a `1920x1080` monitor mode. It defaults to **60 Hz** unless the `$HYPR_REFRESH` environment variable is set.

### Set a Custom Refresh Rate
* **Temporary (Current Session):**
  ```bash
  export HYPR_REFRESH=180
  ```
* **Persistent (Add to Profile):**
  ```bash
  echo 'export HYPR_REFRESH=180' >> ~/.profile
  ```
  *(Alternatively, hardcode your default fallback directly inside `.config/hypr/hyprland.lua`)*

---

## 🖥️ AMD GPU Optimization

This setup is tailored for AMD graphics cards utilizing the native open-source `amdgpu` kernel driver. 
* **Performance:** If you experience any micro-stutters, ensure your distro's `mesa` and `vulkan-radeon` packages are completely up to date.
* **Hardware Acceleration:** Ensure `libva-mesa-driver` is installed for efficient video decoding.

---

## 🔍 Troubleshooting

* **Hyprland fails to start:**
  Check the user journal logs:
  ```bash
  journalctl --user -b -u hyprland.service
  ```
  Or check global system logs:
  ```bash
  journalctl -b | grep -i hyprland
  ```
* **Monitor display/mode fails:**
  Lower the refresh rate to `60` or remove the `mode` parameter from the `hl.monitor` block to enable auto-detection.
* **Force a specific display output:**
  Edit `.config/hypr/hyprland.lua` and explicitly define your connector (e.g., `output = "DP-1"`).

---

## 🐛 Feedback & Bug Reports

If you encounter any bugs, setup errors, or script issues, please open an issue in this repository detailing your system setup, current distribution, and any error logs.
