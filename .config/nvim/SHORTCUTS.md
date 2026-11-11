# Neovim shortcuts

Every key here was verified on this machine against nvim 0.12.6 and the installed
plugin set. Where a key comes from LazyVim rather than this repository, the
source file and line are named so the claim can be rechecked.

`<leader>` is the space bar.

## Competitive programming

Defined in `lua/config/cp.lua`. No plugin, no build system.

| Key | Does |
|---|---|
| `<leader>rl` | Three-pane layout: source \| input.txt / output.txt |
| `<leader>rr` | Compile and run on `input.txt` |
| `<leader>ri` | Open `input.txt` only |
| `<leader>ro` | Open `output.txt` only |
| `<leader>rt` | Paste `~/Github/cp-setup/template.cpp` into the buffer |

`<leader>rr` compiles with:

```
g++ -std=c++23 -O2 -Wall -DLOCAL <file> -o <file-without-extension>
```

`-DLOCAL` is what switches the `dbg()` macro on (`cp.lua:61`). The judge never
sees the flag, so the debug prints cost nothing there.

Where the output goes:

```
stdout ----------------------> output.txt, at the top
stderr (dbg) ---------------->  output.txt, under "--- stderr (dbg) ---"
compile error --------------->  output.txt, under "COMPILE ERROR"
```

So one window always answers "what happened". `output.txt` reloads in place via
`:checktime`; there is no need to close and reopen it.

`input.txt` and `output.txt` are created next to the file being edited
(`cp.lua:22`), not at the repository root. A problem in `Codeforces/2000/`
gets its own pair. Nothing is shared by accident.

### One sharp edge

`<leader>rr` compiles the CURRENT buffer (`cp.lua:15`, `expand('%:p')`). Press it
while the cursor is in the `input.txt` pane and it runs g++ on `input.txt`.
Move back to the source first.

## Moving between windows

LazyVim maps the single chords, so the `<C-w>` prefix is not needed
(`LazyVim/lua/lazyvim/config/keymaps.lua:14-17`).

| Key | Does |
|---|---|
| `<C-h>` | Window to the left |
| `<C-j>` | Window below |
| `<C-k>` | Window above |
| `<C-l>` | Window to the right |
| `<C-w>w` | Cycle through all windows |

In the three-pane layout:

```
+----------------+----------------+
|                |   input.txt    |
|    source      +----------------+
|                |   output.txt   |
+----------------+----------------+
        <C-l> ->        <- <C-h>
```

`<leader>rl` also returns the cursor to the source pane, because the layout
function ends with `wincmd t` (`cp.lua:125`).

## Harpoon: absolute jumps

Defined in `lua/plugins/harpoon.lua`.

| Key | Does |
|---|---|
| `<leader>a` | Add the current file to the list |
| `<leader>hh` | Open the harpoon menu (reorder or delete lines, then `:w`) |
| `<leader>1` .. `<leader>4` | Jump to slot 1-4 |

`<C-h>` is relative and needs a direction. Harpoon is absolute: slot 1 is always
the same file. Two keys instead of one chord, but nothing to work out.

Set it up once per repository: make the layout with `<leader>rl`, then press
`<leader>a` in each pane. The list is keyed by the working directory and
`sync_on_ui_close = true` writes it to disk, so each repository keeps its own
list across restarts.

The `select` function is overridden on purpose. Stock harpoon ends its jump with
`nvim_set_current_buf(bufnr)` (`harpoon/lua/harpoon/config.lua:131`), which
swaps the buffer in whichever window the cursor is in and would destroy the
three-pane layout. The override moves the cursor to a window that already shows
the file, and opens the file only when no window has it.

## Folding: hide a function body

This is the VSCode gutter arrow. It is built into nvim and needs no plugin.

| Key | Does |
|---|---|
| `za` | Toggle the fold under the cursor |
| `zc` / `zo` | Close / open it |
| `zM` | Close every fold ("Fold All") |
| `zR` | Open every fold ("Unfold All") |
| `zj` / `zk` | Jump to the next / previous fold |

```
before                     after za
void solve() {             +--- 14 lines: void solve() {-----
    int n;
    cin >> n;              int main() {
}
int main() {
```

Folding is by real syntax, not by indentation: LazyVim raises `foldmethod` to
`expr` with a treesitter fold expression whenever a parser is available
(`LazyVim/lua/lazyvim/plugins/treesitter.lua:129-132`). So it folds the
function, the `for` loop and the `#ifdef` block as the language defines them.

Folds look absent at first because `foldlevel = 99`
(`LazyVim/lua/lazyvim/config/options.lua:71`) means "open everything". The folds
are there; they just all start expanded. Press `zM` to see them.
