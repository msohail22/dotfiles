#!/usr/bin/env bash
# Set up this machine from the dotfiles repository.
# Safe to run more than once. It never deletes a real file without backing it up.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ] && { echo "ok    $dst"; return; }
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.backup.$STAMP"
    echo "saved $dst.backup.$STAMP"
  fi
  ln -s "$src" "$dst"
  echo "link  $dst -> $src"
}

echo "== symlinks =="
link "$REPO/.zshrc"                  "$HOME/.zshrc"
link "$REPO/.config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
link "$REPO/claude"                 "$HOME/.claude"

echo
echo "== command line tools =="
PKGS=(ripgrep fd ast-grep sd jq go-yq miller bat eza difftastic xh github-cli
      just uv pnpm hyperfine tokei dust duf procs watchexec tealdeer tmux git-delta)
if command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --needed --noconfirm "${PKGS[@]}" || {
    echo "A package name may have changed. Check it with: pacman -Ss <name>"
    exit 1
  }
  command -v tldr >/dev/null 2>&1 && tldr --update || true
else
  echo "Not an Arch system. Install these by hand: ${PKGS[*]}"
fi

echo
echo "== left to do by hand =="
echo "Create the secrets file, which is NOT in this repository:"
echo "  mkdir -p ~/.config/claude-code"
echo "  chmod 700 ~/.config/claude-code"
echo "  echo 'export GROQ_API_KEY=...' >> ~/.config/claude-code/providers.env"
echo "  chmod 600 ~/.config/claude-code/providers.env"
echo "Install plugins from inside Claude Code with:  /plugin"
echo "See claude/MANIFEST.md for the full inventory."
