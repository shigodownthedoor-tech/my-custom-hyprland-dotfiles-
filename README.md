# Debian & Multi-Distro Hyprland Dotfiles

A custom Hyprland configuration utilizing a Lua-style config wrapper (`hl` API). It features dynamic refresh rate switching and automated installation scripts.

---

## 🚀 Quick Start (Automated Install)

You can now use the included multi-distro installation script. It supports:
* **Arch Linux** (and derivatives)
* **Debian / Ubuntu** (and derivatives)
* **Void Linux**
* **Solus**
* **Gentoo**

To run the installer, navigate to the repository root and execute:
```bash
chmod +x install.sh
./install.sh
```

---

## 🛠️ Manual Setup (Debian Focus)

### 1. Install Prerequisites
Some packages may require Debian Backports or building from source:
```bash
sudo apt update && sudo apt install -y \
  wayland-utils wl-clipboard grim slurp wf-recorder \
  rofi dunst lxappearance xdg-desktop-portal \
  xdg-desktop-portal-hyprland hyprpaper
```
> ⚠️ **Note:** Hyprland is not in the Debian Stable repos. You must use backports, a third-party repo, or compile from source.

### 2. Deploy Configuration
Choose **one** of the methods below to deploy the configuration:

* **Option A: Copy files directly**
  ```bash
  cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua
  ```
* **Option B: Symlink (Recommended for Git tracking)**
  ```bash
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

## 📦 Package Recommendations

* **Core:** `hyprland`, `hyprpaper`, `xdg-desktop-portal-hyprland`
* **Status Bar:** `waybar`
* **Notifications:** `dunst`
* **Terminal:** `kitty` (Config default)
* **File Manager:** `nemo` (Bound to `SUPER + E`)
* **Utilities:** `wl-clipboard`, `grim`, `slurp`, `wf-recorder`, `rofi`

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

If you encounter any bugs, setup errors, or script issues, please let me know! Open an issue in this repository detailing your system setup and the error messages you received.
