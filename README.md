# dotfiles

Personal development configs — currently focused on **Neovim (LazyVim)** and **tmux** from an Omarchy/Arch setup.

## What's here

| Path | Description |
|------|-------------|
| [`.config/nvim/`](.config/nvim/) | LazyVim Neovim config (C++, TS/React, asm, SQL, DAP, CP, …) |
| [`.config/tmux/tmux.conf`](.config/tmux/tmux.conf) | Tmux config + resurrect |
| [`.tmux.conf`](.tmux.conf) | Stub that sources the XDG tmux config |
| [`NVIM_TMUX.md`](NVIM_TMUX.md) | **Full guide** — every keybinding & workflow |
| [`INSTALL.md`](INSTALL.md) | Install / inventory notes |
| [`.config/i3/`](.config/i3/), [`.vimrc`](.vimrc), … | Older i3/Vim leftovers (optional) |

## Quick install

```bash
git clone https://github.com/msohail22/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles

ln -sfn "$PWD/.config/nvim" ~/.config/nvim
mkdir -p ~/.config/tmux
ln -sfn "$PWD/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -sfn "$PWD/.tmux.conf" ~/.tmux.conf

# tmux plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# open tmux → prefix (Ctrl-Space) then I
```

Then open `nvim` once and let Mason install LSPs.

## Documentation

→ **[NVIM_TMUX.md](NVIM_TMUX.md)** — full encyclopedia (~2200+ lines): install, Vim grammar, LazyVim, LSP, DAP, Dadbod, CP, tmux, workflows, drills, runbooks, cheatsheets.

## Secrets

Never commit DB passwords. Copy:

```bash
cp ~/.config/nvim/lua/config/db-secrets.example.lua \
   ~/.config/nvim/lua/config/db-secrets.lua
```

(`db-secrets.lua` is gitignored.)
