# Development setup inventory

This is a record of the development-related software installed on this Ubuntu 24.04 machine, refreshed on 2026-08-04. Package names below are the installed Debian/Ubuntu package names unless noted otherwise.

## Editors and terminal workflow

- `neovim` (installed separately at `/usr/local/bin/nvim`), `vim`
- `tmux`, `zsh`, `zplug`, `zsh-autosuggestions`, `zsh-syntax-highlighting`
- `git`, `git-email`, `gh`, `mercurial`
- `curl`, `wget`, `ripgrep`, `fzf`, `zoxide`, `eza`, `jq`, `tree`, `btop`, `fastfetch`

## C and C++ toolchain

- `build-essential`, `gcc`, `g++`, `make`, `cmake`, `cmake-extras`, `ninja-build`, `meson`, `ccache`
- `clang`, `clang-21`, `clangd`, `clangd-21`, `clang-format`, `clang-tidy`
- `llvm`, `lld`, `lld-21`, `lldb`, `valgrind`, `gdb`, `cppcheck`, `doxygen`, `lcov`
- `bison`, `flex`, `nasm`, `yasm`, `glslang-tools`, `vulkan-validationlayers`

## Language runtimes and SDKs

- JavaScript/TypeScript: `node`/`npm`/`npx` (managed with NVM), `pnpm`, `yarn`, `node-typescript`; `bun` and `deno` are not currently installed.
- Python: `python3`, `python3-pip`, `python3.12-venv`, `uv`.
- Go: `golang`.
- Rust: `rustup`, `cargo`, `rustc`.
- Java: `openjdk-17-jdk`.
- Other available runtimes: `ruby`, `perl`, `lua`.

## Containers, cloud, and infrastructure

- Docker: `docker-ce`, `docker-ce-cli`, `containerd.io`, `docker-buildx-plugin`, `docker-compose-plugin`.
- Kubernetes: `kubectl` (installed outside APT).
- Cloud tooling: `azure-cli`, `cloudflared`, `wrangler`.

## Databases and services

- `postgresql`, `postgresql-contrib`, `pgadmin4-desktop`
- `mongodb-org`, `mongodb-compass`
- `redis`

## AI and coding assistants

- `codex`, `claude`, `ollama`, `antigravity`, `opencode`.

## Desktop tools used by these dotfiles

- Window manager and status: `i3`, `i3-wm`, `i3lock`, `i3status`, `picom`, `polybar`.
- Terminal and launcher: `alacritty`, `kitty`, `rofi`, `dmenu` (via `suckless-tools`).
- Utilities: `flameshot`, `grim`, `slurp`, `cliphist`, `xclip`, `brightnessctl`, `playerctl`, `pamixer`, `pavucontrol`, `nitrogen`, `thunar-archive-plugin`.
- Fonts: `fonts-firacode`, `fonts-font-awesome`, `fonts-jetbrains-mono`.

## Install notes

APT packages can be installed with `sudo apt install <package...>`. Software installed outside APT is intentionally called out above because its installation method may vary (for example NVM, Rustup, npm, Cargo, or a standalone binary).

## Dotfiles in this repository

The configuration backups mirror their home-directory locations:

```text
.config/nvim/    -> ~/.config/nvim/
.config/i3/      -> ~/.config/i3/
.vim/            -> ~/.vim/
.vimrc           -> ~/.vimrc
.tmux.conf        -> ~/.tmux.conf
.i3status.conf    -> ~/.i3status.conf
```
