# System Install Checklist

These dotfiles currently include:

- `~/.tmux.conf`
- `~/.config/hypr/hyprland.conf`
- `~/.config/hypr/hyprpaper.conf`
- `~/.config/nvim`

## Base desktop

Required for the Hyprland config:

- `hyprland`
- `waybar`
- `hyprpaper`
- `wl-clipboard`
- `grim`
- `slurp`
- `rofi`
- `alacritty`
- `thunar`
- `systemd` / `loginctl`

The wallpaper config expects this file:

```bash
~/wallpapers/wall.jpg
```

## Terminal and shell tools

Required or expected for the dev setup:

- `zsh`
- `tmux`
- `git`
- `curl`
- `wget`
- `unzip`
- `ripgrep`
- `zoxide`
- `fzf`
- `fd` / `fd-find`
- `bat` / `batcat`
- `eza`
- `jq`

## Neovim

Required for the Neovim/NvChad config:

- `neovim` 0.10 or newer
- `git`
- `ripgrep`
- `unzip`
- `tar`
- `gzip`
- `make`
- `gcc`
- `g++`
- `nodejs`
- `npm`
- `python3`
- `python3-pip`

Language and formatter tools referenced by the config:

- `clangd`
- `stylua`
- `vscode-langservers-extracted`

Useful optional tools:

- `tree-sitter-cli`
- `cargo` / `rustup`
- `nvm`
- `pnpm`
- `bun`

## Ubuntu install example

```bash
sudo apt update
sudo apt install -y \
  hyprland waybar wl-clipboard grim slurp rofi alacritty thunar \
  zsh tmux git curl wget unzip ripgrep fzf zoxide fd-find bat jq eza \
  build-essential clangd nodejs npm python3 python3-pip
```

Install Neovim 0.10 or newer from the official Neovim release, PPA, or your preferred package source if Ubuntu's package is too old.

Install formatter and language-server extras:

```bash
cargo install stylua
npm install -g vscode-langservers-extracted
```

## Restore paths

From this repo, place or symlink files to:

```bash
~/.tmux.conf
~/.config/hypr/
~/.config/nvim/
```

After restoring Hyprland files, reload inside a running Hyprland session:

```bash
hyprctl reload
```
