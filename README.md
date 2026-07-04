## About
- This repository contains a hyprland.lua config (Lua-style config using the `hl` API) for Hyprland v0.55.4.
- Config path in this repo: `.config/hypr/hyprland.lua` (do not edit the dotfiles unless you want to).
- This config builds a 1920x1080@<refresh> monitor mode, where the refresh rate defaults to 60 Hz unless you set the `HYPR_REFRESH` environment variable.

## Quick setup on Debian
1. Install prerequisites (some packages may require backports or building from source):

   sudo apt update
   sudo apt install -y wayland-utils wl-clipboard grim slurp wf-recorder rofi dunst lxappearance xdg-desktop-portal \
     xdg-desktop-portal-hyprland hyprpaper

   Notes:
   - Hyprland may not be packaged in Debian stable. You can look for a backport, use a third-party package repository, or build Hyprland from source. See Hyprland docs for building.
   - `xdg-desktop-portal-hyprland` provides portal integrations on Hyprland.

2. Deploy the config from this repo to your local config directory (no files in this repo will be modified by this step):

   # copy
   cp .config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

   # or symlink (recommended if you want to keep the repo as the source of truth)
   ln -s $(pwd)/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua

3. Set the refresh rate you want (optional — default is 60 Hz):

   # temporary for current session
   export HYPR_REFRESH=180

   # persistent (add to ~/.profile or ~/.profile.d/hypr.sh so display managers inherit it)
   echo 'export HYPR_REFRESH=180' >> ~/.profile

   If you prefer to hardcode a default in the config, edit the `REFRESH` fallback in `hyprland.lua`.

4. Launch Hyprland
- From a TTY (manual): log into a plain TTY and run `Hyprland` (or your start script).
- From a display manager: ensure the DM uses a session that starts Hyprland with your environment.

## Recommended Debian packages
- hyprland (may require backport/build)
- hyprpaper
- xdg-desktop-portal-hyprland
- waybar
- dunst
- wl-clipboard
- grim, slurp
- wf-recorder
- rofi
- kitty (or your preferred terminal)
- nemo (optional; the config binds SUPER+E to `nemo`)

## Troubleshooting
- If Hyprland doesn't start, check journalctl for errors:

  journalctl --user -b -u hyprland.service

  or check system logs:

  journalctl -b | grep -i hyprland

- If monitor mode fails, try a lower refresh (e.g., 60) or remove `mode` from the `hl.monitor` block to let Hyprland auto-select.
- If you need to force a connector, edit `.config/hypr/hyprland.lua` and set `output = "DP-1"` (or your connector name).
## NEW UPDATE IM TOO LAZY TO DO A NEW RELEASE SO I DID IT HERE
- I added a install.sh script for - Void Linux - Arch Linux and Arch based - Debian and Debian or Ubuntu based - Solus - Gentoo And More! If there is any errors please let me know! Goodbye guys

