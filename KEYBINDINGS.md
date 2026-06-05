# Keybindings Practice

This file is a muscle-memory checklist for the dotfiles in this repo.

Included configs:

- `~/.config/hypr/hyprland.conf`
- `~/.tmux.conf`
- `~/.config/nvim`

Notation:

- `SUPER` means the Hyprland main modifier.
- `Prefix` means tmux prefix. In this config, `Prefix = Ctrl-a`.
- `Leader` means Neovim leader. In this config, `Leader = Space`.
- `C-x` means `Ctrl-x`.
- `A-x` means `Alt-x`.

## 1. Hyprland

Practice these until window movement feels automatic.

### Launch

- `SUPER + Enter`: open terminal, `alacritty`
- `SUPER + D`: open launcher, `rofi -show drun`
- `SUPER + E`: open file manager, `thunar`

### Window Control

- `SUPER + Q`: close active window
- `SUPER + F`: toggle fullscreen
- `SUPER + Space`: toggle floating

### Move Focus

- `SUPER + H`: focus window left
- `SUPER + J`: focus window down
- `SUPER + K`: focus window up
- `SUPER + L`: focus window right

### Move Windows

- `SUPER + Shift + H`: move window left
- `SUPER + Shift + J`: move window down
- `SUPER + Shift + K`: move window up
- `SUPER + Shift + L`: move window right

### Resize Active Window

- `SUPER + Ctrl + H`: shrink width by 50
- `SUPER + Ctrl + L`: grow width by 50
- `SUPER + Ctrl + K`: shrink height by 50
- `SUPER + Ctrl + J`: grow height by 50

### Workspaces

- `SUPER + 1`: switch to workspace 1
- `SUPER + 2`: switch to workspace 2
- `SUPER + 3`: switch to workspace 3
- `SUPER + 4`: switch to workspace 4
- `SUPER + 5`: switch to workspace 5

### Move Window To Workspace

- `SUPER + Shift + 1`: move active window to workspace 1
- `SUPER + Shift + 2`: move active window to workspace 2
- `SUPER + Shift + 3`: move active window to workspace 3
- `SUPER + Shift + 4`: move active window to workspace 4
- `SUPER + Shift + 5`: move active window to workspace 5

### Screenshots

- `SUPER + S`: save full screenshot to `~/Pictures/screenshot.png`
- `SUPER + Shift + S`: select region with `slurp`, save screenshot to `~/Pictures/screenshot.png`

### Clipboard

- `SUPER + C`: copy current clipboard text back into clipboard with `wl-copy "$(wl-paste)"`
- `SUPER + Shift + C`: clear clipboard with `wl-copy ""`

### System

- `SUPER + Shift + R`: reload Hyprland config
- `SUPER + Shift + L`: lock session with `loginctl lock-session`

### Mouse

- `SUPER + Left Mouse Drag`: move window
- `SUPER + Right Mouse Drag`: resize window

### Hyprland Drills

Do this once per session for a week:

1. Open terminal: `SUPER + Enter`.
2. Open launcher: `SUPER + D`, then close it.
3. Open file manager: `SUPER + E`.
4. Put terminal and file manager side by side.
5. Move focus in a loop: `H -> L -> H -> L`.
6. If you have more windows open, move focus in a square: `H -> J -> K -> L`.
7. Move a window around with `SUPER + Shift + H/J/K/L`.
8. Resize it with `SUPER + Ctrl + H/J/K/L`.
9. Send the window to workspace 2: `SUPER + Shift + 2`.
10. Switch to workspace 2: `SUPER + 2`.
11. Move it back to workspace 1: `SUPER + Shift + 1`.
12. Switch back: `SUPER + 1`.
13. Toggle floating: `SUPER + Space`.
14. Toggle fullscreen: `SUPER + F`, then undo it.
15. Take a region screenshot: `SUPER + Shift + S`.
16. Reload config: `SUPER + Shift + R`.

## 2. tmux

This config changes the prefix from `Ctrl-b` to `Ctrl-a`.

### Prefix

- `Ctrl-a`: tmux prefix
- `Prefix + Ctrl-a`: send literal prefix, useful inside nested tmux
- `Ctrl-b`: disabled as prefix

### Panes

- `Prefix + h`: select pane left
- `Prefix + j`: select pane down
- `Prefix + k`: select pane up
- `Prefix + l`: select pane right

### Splits

- `Prefix + |`: split window horizontally, preserving current directory
- `Prefix + -`: split window vertically, preserving current directory

### Resize Panes

- `Prefix + H`: resize pane left by 5
- `Prefix + J`: resize pane down by 5
- `Prefix + K`: resize pane up by 5
- `Prefix + L`: resize pane right by 5

These are repeatable, so hold `Prefix`, then tap the resize key repeatedly.

### Reload

- `Prefix + r`: reload `~/.tmux.conf`

### Copy Mode

The config uses vi copy-mode keys.

- `Prefix + [`: enter copy mode, tmux default
- `v`: begin selection
- `y`: copy selection and exit copy mode

### tmux Drills

Do this inside one terminal:

1. Start tmux: `tmux`.
2. Split horizontally: `Prefix + |`.
3. Split vertically: `Prefix + -`.
4. Move panes in a loop: `Prefix + h/j/k/l`.
5. Resize each direction: `Prefix + H/J/K/L`.
6. Enter copy mode: `Prefix + [`.
7. Move with vim keys: `h/j/k/l`.
8. Select text: `v`.
9. Copy and exit: `y`.
10. Reload config: `Prefix + r`.

## 3. Neovim

This config imports NvChad mappings and adds a few custom mappings.

Leader key:

- `Leader = Space`

### Custom Mappings

- Normal `;`: enter command mode, same as `:`
- Insert `jk`: leave insert mode
- Normal `Leader + r`: save, compile current C++ file, run with input from `input.txt`
- Normal `Leader + o`: save, compile current C++ file, run with input from `input.txt`, write output to `output.txt`

### Insert Mode Movement

- Insert `C-b`: move to beginning of line
- Insert `C-e`: move to end of line
- Insert `C-h`: move left
- Insert `C-j`: move down
- Insert `C-k`: move up
- Insert `C-l`: move right
- Insert `jk`: exit insert mode

### Window Navigation

- Normal `C-h`: switch to window left
- Normal `C-j`: switch to window down
- Normal `C-k`: switch to window up
- Normal `C-l`: switch to window right

### General

- Normal `Esc`: clear search highlights
- Normal `C-s`: save file
- Normal `C-c`: copy whole file to system clipboard
- Normal `Leader + n`: toggle line numbers
- Normal `Leader + rn`: toggle relative line numbers
- Normal `Leader + ch`: open NvChad cheatsheet
- Normal/Visual `Leader + fm`: format file with Conform
- Normal `Leader + ds`: put diagnostics into location list

### Buffers

These are active when NvChad tabufline is enabled.

- Normal `Leader + b`: create new buffer
- Normal `Tab`: next buffer
- Normal `Shift + Tab`: previous buffer
- Normal `Leader + x`: close current buffer

### Comments

- Normal `Leader + /`: toggle comment on current line
- Visual `Leader + /`: toggle comment on selected lines

### File Tree

- Normal `C-n`: toggle NvimTree
- Normal `Leader + e`: focus NvimTree

### Telescope

- Normal `Leader + ff`: find files
- Normal `Leader + fa`: find all files, including hidden and ignored
- Normal `Leader + fw`: live grep
- Normal `Leader + fb`: find buffers
- Normal `Leader + fh`: find help tags
- Normal `Leader + fo`: find old files
- Normal `Leader + fz`: fuzzy find inside current buffer
- Normal `Leader + ma`: find marks
- Normal `Leader + cm`: git commits
- Normal `Leader + gt`: git status
- Normal `Leader + pt`: pick hidden terminal
- Normal `Leader + th`: open NvChad theme picker

### Terminal

- Terminal `C-x`: leave terminal mode
- Normal `Leader + h`: open new horizontal terminal
- Normal `Leader + v`: open new vertical terminal
- Normal/Terminal `Alt + h`: toggle horizontal terminal
- Normal/Terminal `Alt + v`: toggle vertical terminal
- Normal/Terminal `Alt + i`: toggle floating terminal

### Which-Key

- Normal `Leader + wK`: show all keymaps
- Normal `Leader + wk`: query Which-Key for a prefix

### LSP

These are active when an LSP is attached. Your config enables:

- `html`
- `cssls`
- `clangd`
- `lua_ls` through NvChad defaults

LSP mappings:

- Normal `gd`: go to definition
- Normal `gD`: go to declaration
- Normal `Leader + D`: go to type definition
- Normal `Leader + ra`: rename symbol with NvChad renamer
- Normal `Leader + wa`: add workspace folder
- Normal `Leader + wr`: remove workspace folder
- Normal `Leader + wl`: list workspace folders

### Neovim Drills

Do this in a small C++ file:

1. Open Neovim: `nvim main.cpp`.
2. Enter insert mode, type text, exit with `jk`.
3. Save with `C-s`.
4. Toggle line numbers: `Leader + n`.
5. Toggle relative numbers: `Leader + rn`.
6. Open file tree: `C-n`.
7. Focus file tree: `Leader + e`.
8. Find files: `Leader + ff`.
9. Live grep: `Leader + fw`.
10. Search current buffer: `Leader + fz`.
11. Open a horizontal terminal: `Leader + h`.
12. Exit terminal mode: `C-x`.
13. Toggle floating terminal: `Alt + i`.
14. Format file: `Leader + fm`.
15. Toggle comment on one line: `Leader + /`.
16. Select multiple lines, then `Leader + /`.
17. With `clangd` attached, jump to definition: `gd`.
18. Rename a symbol: `Leader + ra`.
19. Compile and run with input: `Leader + r`.
20. Compile and write output: `Leader + o`.

## 4. CLI Muscle Memory

These are not keybindings from the dotfiles, but they match the dev tools you said you use and should become automatic.

### zoxide

- `z project`: jump to a frequently used directory matching `project`
- `z ..`: move up and train directory history
- `zi`: interactive jump with fzf, if enabled

Practice:

1. `cd ~`
2. `z dotfiles`
3. `z hypr`
4. `z nvim`
5. `zi`

### ripgrep

- `rg "text"`: search text recursively
- `rg "text" path/`: search inside a path
- `rg -n "text"`: show line numbers
- `rg -i "text"`: case-insensitive search
- `rg --files`: list files quickly
- `rg --hidden "text"`: search hidden files too

Practice:

1. `rg "bind" ~/.config/hypr`
2. `rg "map" ~/.config/nvim`
3. `rg --files ~/.config/nvim`
4. `rg -i "leader" ~/.config/nvim`

### fzf

- `fzf`: fuzzy-select from stdin or current directory listing
- `Ctrl-r`: fuzzy-search shell history, if your shell integration is enabled
- `Alt-c`: fuzzy-change-directory, if your shell integration is enabled

Practice:

1. Run `fzf` in a repo.
2. Use `Ctrl-r` to search an old command.
3. Use `Alt-c` to jump to a directory.

### git

- `git status`: check working tree
- `git diff`: inspect unstaged changes
- `git add path`: stage a file
- `git commit -m "message"`: commit
- `git log --oneline --graph --decorate -n 10`: quick history

Practice in dotfiles:

1. `z dotfiles`
2. `git status`
3. `git diff`
4. `git log --oneline --graph --decorate -n 10`

## 5. Daily Practice Routine

Run this as a 15-minute loop.

### Round 1: Desktop

1. `SUPER + Enter`
2. `SUPER + D`
3. `SUPER + E`
4. `SUPER + H/J/K/L`
5. `SUPER + Shift + H/J/K/L`
6. `SUPER + Ctrl + H/J/K/L`
7. `SUPER + 1/2/3`
8. `SUPER + Shift + 1/2/3`

### Round 2: Terminal Multiplexing

1. Start tmux.
2. `Prefix + |`
3. `Prefix + -`
4. `Prefix + h/j/k/l`
5. `Prefix + H/J/K/L`
6. `Prefix + [`, then `v`, then `y`

### Round 3: Editor

1. `nvim main.cpp`
2. Insert text, exit with `jk`
3. `C-s`
4. `Leader + ff`
5. `Leader + fw`
6. `Leader + fm`
7. `Leader + /`
8. `gd`
9. `Leader + r`

### Round 4: Search And Jump

1. `z dotfiles`
2. `rg "bind" .`
3. `rg "map" .`
4. `rg --files`
5. `fzf`

## 6. Priority Order

Learn in this order:

1. Hyprland launch and focus: `SUPER + Enter/D/E/H/J/K/L`
2. Hyprland workspaces: `SUPER + 1-5`, `SUPER + Shift + 1-5`
3. tmux panes: `Prefix + |/-/h/j/k/l`
4. Neovim exit/save/search: `jk`, `C-s`, `Leader + ff`, `Leader + fw`
5. Neovim LSP: `gd`, `Leader + ra`, `Leader + fm`
6. CLI navigation: `z`, `rg`, `fzf`

## 7. One-Line Review

Memorize this compressed version:

```text
Hyprland: SUPER launch/focus/move/resize/workspaces.
tmux: Ctrl-a prefix, h/j/k/l panes, | and - splits.
Neovim: Space leader, jk escape, ff files, fw grep, fm format, gd definition.
CLI: z jump, rg search, fzf pick.
```
