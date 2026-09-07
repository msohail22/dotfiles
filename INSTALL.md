# Install notes

## Neovim + tmux (current)

See **[NVIM_TMUX.md](NVIM_TMUX.md)** for the full guide.

### Symlinks

```bash
mkdir -p ~/.config/git
ln -sfn "$PWD/.config/git/config" ~/.config/git/config
ln -sfn "$PWD/.config/nvim" ~/.config/nvim
mkdir -p ~/.config/tmux
ln -sfn "$PWD/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -sfn "$PWD/.tmux.conf" ~/.tmux.conf
```

### Git diffs

The Git config uses [Delta](https://github.com/dandavison/delta) for a syntax-highlighted, line-numbered side-by-side diff. On Arch:

```bash
sudo pacman -S git-delta
```

### Requirements

- Neovim 0.11+ (LazyVim)
- `git`, `curl`, C compiler (Treesitter)
- `tmux` 3.x
- Optional tools used by this config:
  - `clangd`, `gcc` / `clang` (C++ / asm diagnostics)
  - Node.js (TypeScript tooling, Mason packages)
  - DB clients as needed (`psql`, `mysql`, …) for Dadbod

### Tmux plugins (TPM)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Inside tmux: `Ctrl-Space` then `I` to install (`tmux-resurrect`).

Or clone manually:

```bash
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
```

### GNU Assembly LSP (optional)

```bash
mkdir -p ~/.config/asm-lsp
```

Put a `.asm-lsp.toml` there with `assembler = "gas"` — example in `NVIM_TMUX.md`.

### Database secrets (optional)

```bash
cp .config/nvim/lua/config/db-secrets.example.lua \
   ~/.config/nvim/lua/config/db-secrets.lua
# edit URLs — file is gitignored
```

### Omarchy note

If you use Omarchy: avoid `omarchy-refresh-tmux` / `omarchy refresh nvim`-style resets unless you intend to wipe these custom configs. Theme symlink for `theme.lua` may differ on Omarchy live systems; this repo stores a concrete matteblack theme file.

---

## Older inventory (historical)

Previously this file listed packages from an Ubuntu 24.04 machine (i3, etc.). That list is outdated relative to the current Omarchy/Arch + LazyVim setup. Prefer the guide above for Neovim/tmux.

### Legacy paths still in the repo

```text
.config/i3/       -> ~/.config/i3/
.vim/             -> ~/.vim/
.vimrc            -> ~/.vimrc
.i3status.conf    -> ~/.i3status.conf
```
