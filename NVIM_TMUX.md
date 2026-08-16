# Neovim + Tmux — Complete Encyclopedia

> **This is the full operator manual** for the LazyVim Neovim + tmux setup in this dotfiles repo.
> It is written to be huge on purpose: skim the TOC, jump to what you need, or read end-to-end once.

**Configs**

| Repo path | Installs to |
|-----------|-------------|
| `.config/nvim/` | `~/.config/nvim/` |
| `.config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` |
| `.tmux.conf` | `~/.tmux.conf` (sources the XDG path) |

**Leader key:** `Space` (written as `<leader>` below).

**Tmux prefix:** `Ctrl-Space` (primary) or `Ctrl-a` (secondary).

---

## How to use this document

1. **New machine?** → Part A (Install), then Part B §1–4.
2. **Daily coding?** → Part B navigation/LSP + Part C tmux + Part D workflows.
3. **Debugging?** → Part B §12 (very detailed).
4. **Forgot a key?** → Part E cheatsheets + glossary.
5. **Something broken?** → Part E troubleshooting / FAQ.

---

# PART A — Philosophy & install

## A1. What this stack is

This is not “vanilla Vim.” It is:

- **Neovim** — the editor
- **LazyVim** — a batteries-included Neovim distribution (plugins, keys, LSP wiring)
- **Your overlays** — CP layout, git blame color, contrast fixes, asm-lsp, Dadbod secrets wiring, Omarchy theme hooks
- **tmux** — terminal multiplexer (sessions/windows/panes) with **tmux-resurrect**

Mental model:

```
Hyprland / OS
  └── terminal
        └── tmux session
              ├── window: nvim (editing)
              ├── window: servers / builds
              └── window: git / btop / DB tunnel
```

You live in the terminal. Neovim edits. Tmux keeps context alive.

## A2. What this stack is optimized for

| Domain | Support |
|--------|---------|
| C / C++ | clangd LSP, codelldb DAP, CP keymaps |
| TypeScript / React | vtsls, Tailwind, ESLint, Prettier, js-debug |
| Hono / Drizzle | via TypeScript + package types (no special LSP) |
| GNU Assembly (GAS) | asm-lsp |
| SQL / remote DB | Dadbod + DBUI + tunnel pattern |
| Docker / YAML / JSON | language extras |
| HTTP APIs | Kulala / `.http` files |
| Monorepos | Project extra + Snacks pickers |

## A3. What was deliberately NOT added

- AI completion extras (by choice)
- Harpoon continuum / auto-everything beyond resurrect
- Format-on-save (autoformat is **off**)
- Telescope as primary (Snacks picker is default in this LazyVim)

## A4. Quick start (copy-paste)

```bash
git clone https://github.com/msohail22/dotfiles.git ~/Github/dotfiles
cd ~/Github/dotfiles

# Neovim
ln -sfn "$PWD/.config/nvim" ~/.config/nvim

# Tmux
mkdir -p ~/.config/tmux
ln -sfn "$PWD/.config/tmux/tmux.conf" ~/.config/tmux/tmux.conf
ln -sfn "$PWD/.tmux.conf" ~/.tmux.conf

# TPM + resurrect
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Inside tmux: prefix then I

# Optional asm-lsp global config
mkdir -p ~/.config/asm-lsp
cat > ~/.config/asm-lsp/.asm-lsp.toml <<'EOF'
[default_config]
assembler = "gas"
instruction_set = "x86/x86-64"

[opts]
compiler = "gcc"
diagnostics = true
default_diagnostics = true
compile_flags_txt = ["-x", "assembler-with-cpp", "-g", "-Wall"]
EOF

# Optional DB secrets (never commit)
cp ~/.config/nvim/lua/config/db-secrets.example.lua \
   ~/.config/nvim/lua/config/db-secrets.lua
```

Then:

```bash
nvim   # let Lazy + Mason bootstrap
tmux   # prefix + I to install plugins
```

## A5. Requirements checklist

### Required

- [ ] Neovim 0.11+ (`nvim -v`)
- [ ] git, curl
- [ ] C compiler (Treesitter parsers)
- [ ] tmux 3.x

### Strongly recommended

- [ ] `clangd`, `g++`/`clang` (C++ / asm diagnostics)
- [ ] Node.js + npm/pnpm (TS tooling, many Mason packages)
- [ ] `tsx` or `ts-node` (TS DAP launch)
- [ ] ripgrep (`rg`) for fast search

### Optional

- [ ] `psql` / `mysql` client for Dadbod
- [ ] Docker CLI
- [ ] lazygit (if you bind/use LazyGit)

## A6. First 15 minutes after install

1. `nvim`
2. Wait for Lazy to install plugins (UI appears)
3. `:Mason` — confirm servers installing (`vtsls`, `eslint-lsp`, `prettier`, `asm-lsp`, …)
4. Open a `.ts` or `.cpp` file → `:LspInfo`
5. `<leader><space>` → file picker works
6. Enter tmux → `prefix` `q` reload → `prefix` `I` plugins
7. Create a throwaway session → `prefix` `Ctrl-s` save → kill tmux server → restore with `prefix` `Ctrl-r`

## A7. Updating later

```vim
:Lazy sync
:Mason
:LazyExtras
```

```bash
# tmux plugins
# prefix + U  (TPM update) when available
```

Pull this repo when you change configs on the main machine.

## A8. Omarchy / Arch notes

- Live Omarchy may **symlink** `lua/plugins/theme.lua` to the current theme; this repo stores a **real matteblack** file so clones work anywhere.
- **Do not** run `omarchy-refresh-tmux` if you want to keep this tmux config.
- Contrast fixes assume a very dark / black background (matteblack).

## A9. Directory map (nvim)

```text
~/.config/nvim/
├── init.lua                 # bootstraps LazyVim
├── lazyvim.json             # enabled extras (source of truth for extras)
├── lazy-lock.json           # pinned plugin commits
├── lua/config/
│   ├── autocmds.lua
│   ├── keymaps.lua          # CP + harpoon pin
│   ├── lazy.lua
│   ├── options.lua          # autoformat off, etc.
│   ├── remote_clipboard.lua
│   ├── db-secrets.example.lua
│   └── db-secrets.lua       # YOU create; gitignored
├── lua/plugins/
│   ├── theme.lua
│   ├── gitsigns-blame.lua
│   ├── readable-contrast.lua
│   ├── asm.lua
│   ├── dadbod.lua
│   ├── omarchy-theme-hotreload.lua
│   └── …
└── plugin/after/transparency.lua
```

## A10. Directory map (tmux)

```text
~/.config/tmux/tmux.conf     # canonical config
~/.tmux.conf                 # stub → source-file the above
~/.tmux/plugins/tpm/
~/.tmux/plugins/tmux-resurrect/
~/.tmux/resurrect/           # save files (created after first save)
```

---

# PART B — Neovim deep dive

## B0. Table of contents (Neovim)

1. Mental model & modes
2. Vim grammar (operators × motions × text objects)
3. LazyVim UI & which-key
4. Files, buffers, windows, tabs
5. Snacks picker & neo-tree
6. Editing QoL (yanky, surround, illuminate, context, rename)
7. Git & blame
8. LSP (all languages)
9. Completion, snippets, diagnostics
10. Format & lint
11. DAP debugging (full)
12. Databases
13. REST client
14. Competitive programming
15. Harpoon & project
16. Custom plugin reference
17. Options that matter in THIS config

---

## B1. Mental model & modes

Neovim is modal. You are always in a mode:

| Mode | Enter | What you do |
|------|-------|-------------|
| Normal | `<Esc>` | Move, operate, command |
| Insert | `i` `a` `o` `I` `A` `O` | Type text |
| Visual | `v` `V` `Ctrl-v` | Select, then operate |
| Command-line | `:` `/` `?` | Ex commands / search |
| Terminal | `:term` / LazyVim terminal | Shell inside nvim |
| Replace | `R` | Overwrite characters |

**Rule:** spend most time in Normal. Insert is temporary.

### Mode entry cheat

| Key | Mode action |
|-----|-------------|
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at line start (non-blank) |
| `A` | Insert at line end |
| `o` / `O` | New line below / above |
| `v` | Character visual |
| `V` | Line visual |
| `Ctrl-v` | Block visual |
| `R` | Replace mode |
| `<Esc>` / `Ctrl-[` | Back to Normal |

---

## B2. Vim grammar (learn this once)

Vim commands are a language:

```text
[count][operator][motion or text-object]
```

Examples:

| Typed | Meaning |
|-------|---------|
| `dw` | delete word |
| `d$` | delete to end of line |
| `3dd` | delete 3 lines |
| `ci"` | change inside quotes |
| `ya{` | yank around braces |
| `>ap` | indent a paragraph |
| `gcip` | comment inner paragraph (if gc mapped) |

### Operators (must know)

| Op | Name |
|----|------|
| `d` | delete |
| `c` | change (delete + insert) |
| `y` | yank (copy) |
| `>` / `<` | indent / outdent |
| `=` | auto-indent |
| `g~` / `gu` / `gU` | toggle / lower / upper case |
| `gc` | comment (LazyVim/Comment plugin) |

### Motions (must know)

| Motion | Goes to |
|--------|---------|
| `h j k l` | left down up right |
| `w` `b` `e` | word forward / back / end |
| `W` `B` `E` | WORD (space-separated) |
| `0` `^` `$` | line start / first non-blank / end |
| `f{c}` `t{c}` | find / till character |
| `F{c}` `T{c}` | backward find / till |
| `;` `,` | repeat f/t same / opposite |
| `gg` `G` | file start / end |
| `{` `}` | paragraph |
| `%` | matching bracket |
| `H` `M` `L` | screen high / mid / low |
| `Ctrl-u` `Ctrl-d` | half page |
| `Ctrl-b` `Ctrl-f` | page back / forward |
| `n` `N` | next / prev search |
| `*` `#` | search word under cursor |

### Text objects (must know)

| Object | Meaning |
|--------|---------|
| `iw` / `aw` | inner / a word |
| `is` / `as` | sentence |
| `ip` / `ap` | paragraph |
| `i"` `a"` | inside / around double quotes (also `'`, `` ` ``) |
| `i(` `a(` | inside / around parens (also `)` `b`) |
| `i[` `a[` | brackets |
| `i{` `a{` | braces (`B`) |
| `it` `at` | XML/HTML/JSX tag |
| `i<` `a<` | angle brackets |

**Practice drill:** open any file and do `ci"`, `da(`, `yip`, `>ap` twenty times.

### Counts & repeats

- `3w` — 3 words forward
- `d3w` — delete 3 words
- `.` — repeat last change
- `@@` — repeat last macro
- `q{a-z}` record macro, `q` stop, `@{a-z}` play

### Registers (clipboard)

| Register | Use |
|----------|-----|
| `"` | unnamed (default) |
| `"0` | last yank |
| `"1`–`"9` | delete history |
| `"+` | system clipboard |
| `"*` | primary selection (X11) |
| `"_` | black hole (delete without yank) |

Examples: `"+y` yank to clipboard, `"_dd` delete line without overwriting yank.

Yanky (enabled) remembers yanks so you can cycle after paste.

### Marks & jumps

| Key | Action |
|-----|--------|
| `m{a-z}` | set mark |
| `'{a-z}` / `` `{a-z} `` | jump to mark (line / exact) |
| `Ctrl-o` / `Ctrl-i` | jump list back / forward |
| `gd` | go definition (LSP) — also adds jumps |
| `:jumps` | show jump list |
| `:marks` | show marks |

### Search & substitute

```vim
/pattern          " search forward
?pattern          " search backward
n / N             " next / prev
:noh              " clear highlight (or LazyVim mapping)
:%s/old/new/g     " replace all in file
:%s/old/new/gc    " replace with confirm
:'<,'>s/old/new/g " replace in visual selection
```

LazyVim often maps `<leader>ur` or similar to clear search — check which-key `u` menu.

---

## B3. LazyVim UI & which-key

### Leader

`<leader>` = **Space**.

Press Space and wait — **which-key** shows menus:

| Prefix | Typical menu |
|--------|----------------|
| `<leader>b` | buffers |
| `<leader>c` | code / LSP |
| `<leader>d` | debug |
| `<leader>f` | find / file |
| `<leader>g` | git |
| `<leader>q` | quit / session |
| `<leader>s` | search |
| `<leader>u` | UI toggles |
| `<leader>x` | diagnostics / trouble |
| `<leader>R` | REST (Kulala) |
| `<leader>D` | Dadbod UI |
| `<leader>h` / `H` | Harpoon |
| `<leader>r` | CP (`rl` `rr`) among others |

**If you forget everything:** press `Space` and read.

### Notification / command UIs

LazyVim uses snacks / noice-style UX depending on version. Commands still work:

```vim
:Lazy
:Mason
:LspInfo
:checkhealth
:messages
```

### Colorscheme

Matteblack via `lua/plugins/theme.lua`. Blame accent amber `#E68E0D`. Contrast plugin brightens dim UI greys.

---

## B4. Files, buffers, windows, tabs

### Definitions

| Thing | Meaning |
|-------|---------|
| Buffer | File contents in memory |
| Window | Viewport onto a buffer |
| Tab | Layout of windows |
| Argument list | Files from CLI `nvim a b c` |

### Buffers

| Key / cmd | Action |
|-----------|--------|
| `<leader>bd` | delete buffer |
| `<leader>bb` | other buffer |
| `]b` `[b` | next / prev buffer |
| `:ls` / `:buffers` | list |
| `:b <name>` | switch by name |
| `:bd!` | force delete |

### Windows (splits)

| Key / cmd | Action |
|-----------|--------|
| `:split` / `:vsplit` | split |
| `Ctrl-w` then `h/j/k/l` | move to window |
| `Ctrl-w` `w` | cycle windows |
| `Ctrl-w` `q` | close window |
| `Ctrl-w` `=` | equalize sizes |
| `Ctrl-w` `_` / `|` | max height / width |
| `Ctrl-w` `r` | rotate |

LazyVim may also map Ctrl-hjkl for window nav — verify with `:map <C-h>`.

### Tabs (less used in LazyVim)

```vim
:tabnew
:tabnext
:tabclose
gt / gT
```

Prefer buffers + splits + tmux windows over Vim tabs for this workflow.

### Saving / quitting

| Key | Action |
|-----|--------|
| `:w` | write |
| `:wa` | write all |
| `:q` | quit window |
| `:qa` | quit all |
| `:wq` / `ZZ` | write + quit |
| `:q!` / `ZQ` | quit discard |
| `<leader>qq` | LazyVim quit flow |

---

## B5. File navigation & search (Snacks + neo-tree)

### Snacks picker (primary)

| Key | Action |
|-----|--------|
| `<leader><space>` | Find files |
| `<leader>,` | Buffers |
| `<leader>/` | Grep (root) |
| `<leader>sg` | Grep |
| `<leader>sw` | Grep word under cursor (common LazyVim) |
| `<leader>ff` | Find files |
| `<leader>fr` | Recent files |
| `<leader>fc` | Config files (often) |
| `<leader>sk` | Search keymaps |
| `<leader>ss` | Search symbols / LSP (varies) |

Inside picker (typical):

| Key | Action |
|-----|--------|
| Type | Filter |
| `Enter` | Open |
| `Ctrl-s` / `Ctrl-v` | Split / vsplit (if mapped) |
| `Esc` | Close |
| `Ctrl-q` | Send to quickfix (sometimes) |

Paths before filenames use **readable grey** thanks to `readable-contrast.lua` (otherwise nearly invisible on black).

### Neo-tree

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle explorer |
| `<leader>E` | Explorer (root variants) |

In tree (common neo-tree keys):

| Key | Action |
|-----|--------|
| `a` | add |
| `d` | delete |
| `r` | rename |
| `y` / `x` / `p` | copy / cut / paste |
| `Enter` | open |
| `R` | refresh |

### Project roots

`util.project` helps monorepos. Open project picker via which-key (`<leader>f` / projects). When LSP feels “wrong root,” check `:LspInfo` root directory and open nvim from the package or workspace root.

### Search tips

- Prefer `<leader>/` over `:grep` 
- Respect `.gitignore` (Snacks/rg usually do)
- For one folder: run nvim from that folder or set cwd `:cd`

---

## B6. Editing QoL

### Yanky — yank history

Problem it solves: you yank A, then delete B, then `p` pastes B — classic Vim. Yanky keeps yank history.

Workflow:

1. Yank several things over time
2. `p` to paste
3. Cycle history with the Yanky cycle keys (LazyVim maps — often `]` / `[` after paste, or put mappings under which-key)

Open yank history picker if available (check `:map` for `Yanky` or which-key).

### Surround — mini.surround

LazyVim extra uses **`gs`** prefix (not necessarily tpope’s `ys`).

Typical actions (confirm with which-key after `gs`):

| Idea | Example goal |
|------|----------------|
| Add | word → `"word"` or `(word)` |
| Delete | remove surrounding quotes |
| Replace | `"word"` → `'word'` |
| Tag | wrap JSX/HTML |

Drill: visually select a word (`viw`) then surround with `"`.

### Illuminate

Automatic highlight of other occurrences of the word under cursor. No key. If noisy, toggle via LazyVim UI toggles (`<leader>u…`).

### Treesitter context

Sticky header shows enclosing function/class/component. Essential in large React/C++ files. No key.

### Incremental rename

| Key | Action |
|-----|--------|
| `<leader>cr` | `IncRename` with live preview |

Better than bare `vim.lsp.buf.rename` when you want to see edits apply live.

### Multi-cursor?

Not a default focus of this config. Prefer macros, `:global`, visual block, and LSP rename.

---

## B7. Git & blame

### Inline blame (custom)

`lua/plugins/gitsigns-blame.lua`:

- Enabled by default
- Color: amber `#E68E0D`
- Format: `author, relative-time • summary`

| Key | Action |
|-----|--------|
| `<leader>gB` | Toggle inline blame |
| `<leader>ghb` | Full blame popup for line |
| `<leader>ghB` | Blame buffer |

### Gitsigns hunks

| Key | Action |
|-----|--------|
| `]h` `[h` | next / prev hunk |
| `]H` `[H` | last / first hunk |
| `<leader>ghs` | stage hunk |
| `<leader>ghr` | reset hunk |
| `<leader>ghS` | stage buffer |
| `<leader>ghR` | reset buffer |
| `<leader>ghp` | preview hunk inline |
| `<leader>ghd` | diff this |
| `<leader>uG` | toggle git signs (LazyVim snacks toggle) |

### LazyGit / git UI

If LazyGit installed, LazyVim often maps `<leader>gg`. Otherwise use tmux pane:

```bash
git status
git diff
lazygit
```

### Commit from editor

```vim
:Git commit   " if fugitive-like available — else use terminal
```

Prefer terminal/lazygit for commit flow with this stack.

---

## B8. LSP — all languages

### Universal LSP keys

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `gD` | Declaration / TS go source def |
| `gr` | References |
| `gI` | Implementations |
| `gy` | Type definition (often) |
| `K` | Hover docs |
| `gK` | Signature help |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename |
| `<leader>cl` | LSP info / codelens menus (varies) |
| `]d` `[d` | next / prev diagnostic |
| `<leader>cd` | line diagnostics |
| `<leader>xx` | Trouble diagnostics (often) |

### Hover workflow

1. `K` on symbol
2. Read types / docs
3. `gd` to jump
4. `Ctrl-o` to return

### Code actions workflow

1. See diagnostic underline
2. `<leader>ca`
3. Pick fix / import / rewrite

### C / C++ (clangd)

**Extra:** `lang.clangd`  
**Server:** `clangd`  
**Helper:** `clangd_extensions.nvim`

Best results when the project has one of:

- `compile_commands.json` (CMake: `CMAKE_EXPORT_COMPILE_COMMANDS=ON`)
- `compile_flags.txt`
- `.clangd` config file

```bash
# CMake example
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json .
```

| Key | Action |
|-----|--------|
| `<leader>ch` | Switch source ↔ header |

Inlay hints: toggle via `<leader>uh` (common LazyVim).

### TypeScript / JavaScript / React (vtsls)

**Extra:** `lang.typescript`  
**Server:** `vtsls` (not old tsserver by default)

Works on `.ts` `.tsx` `.js` `.jsx`.

| Key | Action |
|-----|--------|
| `<leader>cM` | Add missing imports |
| `<leader>cD` | Fix all TS |
| `<leader>cV` | Select TypeScript version |
| `gR` | File references |
| `gD` | Go to source definition |

**Drizzle / Hono:** install packages; TypeScript server reads `.d.ts` / source. No drizzle-language-server required.

Monorepo tips:

- Open the correct package root or ensure `tsconfig` project references
- `:LspInfo` → check root
- `node_modules` must exist (`pnpm i`)

### Tailwind

Activates with Tailwind config present. Completes class names in JS/TS/HTML-ish files.

### JSON

SchemaStore integration — `package.json`, `tsconfig.json`, etc. get validation/completion.

### YAML

Good for GitHub Actions, Compose, K8s manifests.

### Docker

Dockerfile language features via docker extra.

### GNU Assembly (GAS)

**Plugin:** `lua/plugins/asm.lua`  
**Server:** `asm-lsp`  
**Treesitter:** `asm`

Files: `.s` `.S` `.asm`.

Global config: `~/.config/asm-lsp/.asm-lsp.toml` (gas + x86/x86-64).

Project needs `.git` or `.asm-lsp.toml` for root detection.

Hover (`K`) shows instruction docs. Diagnostics use `gcc` with assembler flags from config.

### SQL

Treesitter + sqlfluff + Dadbod completion in SQL buffers. See Databases section for query execution.

---

## B9. Completion, snippets, diagnostics

### Completion (blink.cmp in modern LazyVim)

While typing:

| Key | Typical action |
|-----|----------------|
| `Ctrl-n` / `Ctrl-p` | next / prev (or builtin) |
| `Enter` | confirm |
| `Ctrl-y` | confirm (vim style) |
| `Ctrl-e` | abort |
| `Tab` / `S-Tab` | sometimes snippet / next |

Sources include LSP, path, buffer, snippets, Dadbod (in SQL).

### Diagnostics

| Severity | Meaning |
|----------|---------|
| Error | must fix / broken |
| Warn | likely issue |
| Info / Hint | suggestions |

Trouble / quickfix:

```vim
:Trouble diagnostics
:copen
```

`<leader>x` menu is your friend.

---

## B10. Formatting & linting

| Tool | Via | Languages |
|------|-----|-----------|
| Prettier | extra | JS/TS/JSON/MD/… |
| ESLint | extra | JS/TS |
| sqlfluff | sql extra | SQL |
| clangd / clang-format | project | C/C++ |

**This config:** `vim.g.autoformat = false` in `options.lua`.

| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer |

Enable format-on-save:

```lua
-- lua/config/options.lua
vim.g.autoformat = true
```

ESLint auto-format may still apply depending on LazyVim eslint extra defaults — check behavior in a TS project.

---

## B11. Debugging (DAP) — full guide

This setup uses **nvim-dap** plus LazyVim’s `dap.core` extra, with language adapters from:

| Language | Extra | Adapter (Mason) |
|----------|-------|-----------------|
| C / C++ | `lang.clangd` | **codelldb** |
| JS / TS / React | `lang.typescript` | **js-debug-adapter** (`pwa-node`, also chrome/msedge adapters) |

Also included:

- **nvim-dap-ui** — scopes, stacks, breakpoints, watches (auto-opens on start)
- **nvim-dap-virtual-text** — variable values inline next to code
- **mason-nvim-dap** — helps install adapters
- VS Code **`launch.json`** support (comments allowed)

### B11.1 First-time setup

1. Open nvim and run `:Mason`
2. Ensure these are installed (or let the first `<leader>dc` pull them):
   - `codelldb`
   - `js-debug-adapter`
3. Confirm extras in `:LazyExtras` / `lazyvim.json`: `dap.core`, `lang.clangd`, `lang.typescript`

```vim
:DapInstall codelldb
:DapInstall js-debug-adapter
```

### B11.2 All debugger keymaps

Leader **`Space`**, then **`d`** for the debug menu (which-key).

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Conditional breakpoint (prompt) |
| `<leader>dc` | Continue / start debugging |
| `<leader>da` | Run / continue **with args** (prompts) |
| `<leader>dC` | Run to cursor |
| `<leader>dg` | Go to line (no execute) |
| `<leader>di` | Step **into** |
| `<leader>dO` | Step **over** |
| `<leader>do` | Step **out** |
| `<leader>dP` | Pause |
| `<leader>dl` | Run last configuration again |
| `<leader>dj` / `<leader>dk` | Frame down / up (stack) |
| `<leader>dr` | Toggle DAP REPL |
| `<leader>ds` | Show session |
| `<leader>dt` | Terminate |
| `<leader>dw` | Hover widgets |
| `<leader>du` | Toggle **DAP UI** |
| `<leader>de` | **Eval** expression under cursor (also visual) |

Signs appear in the gutter for breakpoints / stopped line.

### B11.3 Typical debug loop (any language)

1. Open source file
2. Put cursor on a line → `<leader>db` (red breakpoint mark)
3. `<leader>dc` → pick a configuration from the list
4. DAP UI opens (stacks, variables, breakpoints)
5. Step with `di` / `dO` / `do`, continue with `dc`
6. Eval with `<leader>de` or inspect DAP UI panes
7. Stop with `<leader>dt`

### B11.4 C / C++ debugging (codelldb)

#### What you need

- Build with **debug symbols**: `-g` (and usually `-O0` while debugging)
- A real binary path (not just the `.cpp` source)

Examples:

```bash
# Simple
g++ -g -O0 -o yo yo.cpp

# CMake Debug
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

Clangd (LSP) and codelldb (debugger) are separate: LSP helps edit; DAP runs/steps the binary.

#### Built-in configurations

For `c` / `cpp` buffers:

1. **Launch file** — prompts: `Path to executable:` (defaults to cwd)
2. **Attach to process** — pick a running PID

#### Step-by-step: launch

1. Compile with `-g`
2. Open the `.cpp` (or any C/C++ buffer)
3. `<leader>db` on the line you care about
4. `<leader>dc` → choose **Launch file**
5. Enter path, e.g. `/home/you/Github/cp-setup/yo` or `build/myapp`
6. When hit: inspect locals in DAP UI; step with `<leader>dO` / `<leader>di`

#### Step-by-step: attach

1. Start the program in a terminal/tmux pane
2. In nvim: `<leader>dc` → **Attach to process**
3. Pick the PID

#### Args / stdin

- Program args: `<leader>da` (LazyVim wraps continue with an args prompt) or a custom `launch.json`
- Interactive stdin: often easier to **attach**, or redirect in a custom config / run outside DAP for CP-style `input.txt`

#### Competitive programming tip

`<leader>rr` runs via `run.sh` (not DAP). For stepping through logic:

```bash
g++ -g -O0 -o yo yo.cpp
# then DAP Launch → ./yo
```

Or attach after starting `./yo < input.txt` in another pane.

#### C++ troubleshooting

| Problem | Fix |
|---------|-----|
| “codelldb not found” | `:Mason` → install `codelldb`; restart nvim |
| Breakpoints never hit | Rebuild with `-g`; disable heavy optimization; confirm you’re launching the binary you just built |
| Wrong source lines | Stale binary — rebuild; path mismatch between compile dir and sources |
| Prompt path wrong | Use absolute path to the executable |
| Only works for `c`/`cpp` ft | Open a C/C++ file before `<leader>dc` so the right configs load |

### B11.5 Node / TypeScript / React debugging (js-debug-adapter)

#### What you need

- Mason package **`js-debug-adapter`**
- For TypeScript “Launch file”: **`tsx`** or **`ts-node`** on PATH (LazyVim prefers `tsx` if present)

```bash
# optional but recommended for TS
npm i -g tsx
# or in project:
pnpm add -D tsx
```

#### Filetypes covered

`javascript`, `typescript`, `javascriptreact`, `typescriptreact`

#### Built-in configurations

1. **Launch file** — runs `${file}` with `pwa-node` (uses `tsx`/`ts-node` for TS)
2. **Attach** — attach to a running Node process (pick PID)

Adapters also register **`pwa-chrome`** / **`pwa-msedge`** (and VS Code–compatible `node` / `chrome` aliases) for browser-style debugging when you add configs / `launch.json`.

#### Step-by-step: launch current TS/JS file

1. Open e.g. `scripts/foo.ts`
2. `<leader>db` on a line
3. `<leader>dc` → **Launch file**
4. Steps hit in the TS source when source maps resolve (defaults skip `node_modules`)

#### Step-by-step: attach to a running server (Hono / Next / Vite API)

1. Start Node with the inspector, e.g.:
   ```bash
   node --inspect dist/index.js
   # or
   NODE_OPTIONS='--inspect' pnpm dev
   ```
2. In nvim (TS/JS buffer): `<leader>dc` → **Attach** → pick the process  
   Or use a `launch.json` attach-to-port config (see below)

#### React / browser

- Prefer a VS Code–style `launch.json` with Chrome/Edge + your Vite/Next URL
- Or debug server-side Node separately from the browser

#### `launch.json` (shared with VS Code)

LazyVim loads `.vscode/launch.json` (JSONC comments OK). Example project file:

```jsonc
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "pwa-node",
      "request": "launch",
      "name": "Debug API",
      "runtimeExecutable": "pnpm",
      "runtimeArgs": ["--filter", "api", "dev"],
      "cwd": "${workspaceFolder}",
      "console": "integratedTerminal"
    },
    {
      "type": "pwa-node",
      "request": "attach",
      "name": "Attach 9229",
      "port": 9229,
      "restart": true,
      "cwd": "${workspaceFolder}"
    },
    {
      "type": "pwa-chrome",
      "request": "launch",
      "name": "Vite Chrome",
      "url": "http://localhost:5173",
      "webRoot": "${workspaceFolder}/apps/web"
    }
  ]
}
```

Then `<leader>dc` and pick the named config.

#### Node / TS troubleshooting

| Problem | Fix |
|---------|-----|
| js-debug missing | `:MasonInstall js-debug-adapter` |
| TS launch fails | Install `tsx` (or `ts-node`); run from project with deps installed |
| Breakpoints unbound in TS | Ensure source maps; build/`tsx` serving maps; check `resolveSourceMapLocations` |
| Attach finds nothing | Process must be Node with `--inspect` / inspector enabled |
| Monorepo wrong cwd | Set `cwd` in `launch.json` to the package root |

### B11.6 DAP UI panes

On session start, DAP UI usually opens automatically; closes on terminate/exit.

| Pane (typical) | Use |
|----------------|-----|
| Scopes | Locals / globals |
| Stacks | Call stack — jump frames |
| Breakpoints | List / toggle |
| Watches | Expressions you add |
| REPL (`<leader>dr`) | Evaluate commands |

Toggle UI anytime: `<leader>du`.

### B11.7 Virtual text

While stopped, values often appear as virtual text at end of line (nvim-dap-virtual-text). If cluttered, disable via Lazy plugin opts later — enabled by default in this stack.

### B11.8 Debug + tmux workflow

Useful split:

| Tmux pane | Role |
|-----------|------|
| 1 | `nvim` — breakpoints + DAP UI |
| 2 | App process (`pnpm dev`, `./yo`, etc.) for attach |
| 3 | Logs / `curl` / tests |

Save layout with tmux-resurrect (`prefix` `Ctrl-s`) if you reuse it.

### B11.9 Commands worth knowing

```vim
:DapContinue
:DapToggleBreakpoint
:DapStepOver
:DapStepInto
:DapStepOut
:DapTerminate
:DapReplayLast
:DapInstall codelldb
:DapInstall js-debug-adapter
```

---


---

## B12. Databases (Dadbod) — full guide

### What you get

| Piece | Role |
|-------|------|
| `vim-dadbod` | Execute queries |
| `vim-dadbod-ui` | Drawer UI (`<leader>D`) |
| `vim-dadbod-completion` | Completion in SQL buffers |
| `lua/plugins/dadbod.lua` | Load connections from env + secrets file |

### Open UI

`<leader>D` → DBUI drawer.

Common DBUI keys (inside drawer — see `:h dadbod-ui`):

| Key | Action |
|-----|--------|
| `o` / `Enter` | open |
| `A` | add connection |
| `R` | redraw |
| `q` | quit |

Query buffers: write SQL, run with **`<leader>S`** (execute on save is **disabled** in this config).

### Connection methods

#### 1) Environment variables

```bash
export DATABASE_URL='postgres://user:pass@127.0.0.1:5432/mydb'
export DBUI_NAME='default'

export DB_DEV_URL='postgres://...'
export DB_STAGING_URL='postgres://...'
export DB_PROD_URL='postgres://...'
export DB_NEON_URL='postgres://...'   # → connection named "neon"
```

Restart nvim after exporting (env is read at Dadbod UI init).

#### 2) Secrets file (recommended for permanence)

```bash
cp ~/.config/nvim/lua/config/db-secrets.example.lua \
   ~/.config/nvim/lua/config/db-secrets.lua
```

```lua
return {
  { name = "local", url = "postgres://user:pass@127.0.0.1:5432/mydb" },
  { name = "tunnel", url = "postgres://user:pass@127.0.0.1:5433/mydb" },
  { name = "mysql", url = "mysql://user:pass@127.0.0.1:3306/mydb" },
}
```

Gitignored via `.gitignore`.

#### 3) `:DBUIAddConnection`

Interactive; stored under Dadbod UI save location (`stdpath('data')/dadbod_ui`).

### URL cookbook

```text
postgres://USER:PASS@HOST:5432/DBNAME
postgresql://USER:PASS@HOST:5432/DBNAME
mysql://USER:PASS@HOST:3306/DBNAME
sqlite:path/to/file.db
```

URL-encode special characters in passwords.

### Remote DB / SSH / Cloudflare tunnels

Neovim does **not** implement VS Code Remote Tunnels. Any tunnel that exposes a **local port** works:

```bash
# SSH local forward
ssh -N -L 5433:db.internal:5432 user@bastion

# Then Dadbod:
# postgres://user:pass@127.0.0.1:5433/dbname
```

Keep the tunnel alive in a **tmux pane**.

### Workflow: inspect Drizzle schema vs live DB

1. Tunnel up
2. `<leader>D` → select DB → browse tables
3. Open query → `SELECT * FROM ... LIMIT 50;` → `<leader>S`
4. Compare with `schema.ts` in editor (Harpoon both files)

### Safety

- Prefer read-only users for prod
- Never commit `db-secrets.lua`
- `execute_on_save` is false — good; don’t enable carelessly

---

## B13. REST client (Kulala)

**Extra:** `util.rest`  
**Files:** `*.http`

| Key | Action |
|-----|--------|
| `<leader>Rb` | Scratchpad |
| `<leader>Rs` | Send request |
| `<leader>Rr` | Replay |
| `<leader>Rt` | Toggle headers/body |
| `<leader>Rq` | Close |
| `<leader>Rn` / `Rp` | Next / prev request |
| `<leader>Rc` | Copy as cURL |
| `<leader>RC` | From cURL |
| `<leader>Re` | Set env |

Example `api.http`:

```http
### Health
GET http://localhost:3000/health

### Create
POST http://localhost:3000/api/items
Content-Type: application/json

{
  "name": "demo"
}
```

Perfect for Hono route smoke tests beside your code.

---

## B14. Competitive programming — full guide

### Assumptions

Repo layout like `cp-setup`:

```text
yo.cpp
input.txt
output.txt
run.sh
```

### Keys

| Key | Action |
|-----|--------|
| `<leader>rl` | 3-pane layout + Harpoon pins |
| `<leader>rr` | `wall` + `./run.sh <target>` + reload output |

### What `<leader>rl` does

1. Picks current `.cpp` or falls back to `yo.cpp`
2. `:only` — closes other windows
3. Opens code | `input.txt` / `output.txt` split
4. Focuses code pane
5. Clears Harpoon list and pins: `1=code`, `2=input`, `3=output`

### What `<leader>rr` does

1. Resolves target name from current/visible `.cpp` (default `yo`)
2. `:wall`
3. Runs `./run.sh <target>` asynchronously
4. Reloads `output.txt` buffers
5. Notifies success/failure

### Daily CP loop

1. `tmux` window for nvim in `cp-setup`
2. `<leader>rl`
3. Write solution
4. Edit input (`<leader>2`)
5. `<leader>rr`
6. Read output (`<leader>3`)
7. Repeat

### Debugging CP (DAP)

`<leader>rr` is **not** a debugger. For stepping:

```bash
g++ -g -O0 -o yo yo.cpp
```

Then DAP Launch → `./yo` (see B11). Feed input via shell redirection in another approach or attach.

### Multiple solutions

If you have `a.cpp`, `b.cpp`: open that file before `rl`/`rr`, or focus its window so target detection sees it.

---

## B15. Harpoon & project

### Harpoon keys

| Key | Action |
|-----|--------|
| `<leader>H` | Add current file |
| `<leader>h` | Quick menu |
| `<leader>1` … `9` | Select slot |

### When to use Harpoon

- CP trio (auto-pinned by `rl`)
- Monorepo: API entry, schema, web entry, shared package
- Jumping without re-searching every time

### When not to

If you always fuzzy-find (`<leader><space>`), Harpoon is optional.

### Project extra

Improves root detection for tools/pickers in multi-root trees. If LSP attaches to wrong root, fix cwd / open correct folder / check `tsconfig` references.

---

## B16. Custom plugin reference (every file)

| File | Purpose | Notes |
|------|---------|-------|
| `theme.lua` | matteblack colorscheme | Real file in repo |
| `gitsigns-blame.lua` | Inline blame + `<leader>gB` | Amber `#E68E0D` |
| `readable-contrast.lua` | Fix NonText-level greys | Snacks paths, LineNr, neo-tree |
| `asm.lua` | Mason asm-lsp + TS asm | GAS oriented |
| `dadbod.lua` | Env + secrets → `vim.g.dbs` | No secrets in git |
| `omarchy-theme-hotreload.lua` | Reload theme on Omarchy event | Harmless elsewhere |
| `snacks-animated-scrolling-off.lua` | Disable scroll anim | Preference |
| `disable-news-alert.lua` | Less LazyVim news noise | |
| `all-themes.lua` | Theme pack related | Omarchy ecosystem |
| `example.lua` | LazyVim example (disabled) | `if true then return {}` |
| `transparency.lua` | Clear backgrounds | After colorscheme |
| `keymaps.lua` | CP + harpoon pin | |
| `options.lua` | `relativenumber=false`, `autoformat=false` | |
| `remote_clipboard.lua` | Clipboard helper | Remote/dev setups |

---

## B17. Options that matter in THIS config

From `options.lua` and plugins:

| Setting | Value | Effect |
|---------|-------|--------|
| `relativenumber` | false | Absolute line numbers |
| `autoformat` | false | Manual `<leader>cf` |
| `db_ui_execute_on_save` | false | Don’t auto-run SQL |
| Inline blame | on | Amber EOL text |
| Scroll anim | off | Instant scroll |

---

## B18. Mason — what gets installed

Expect some of:

- `vtsls`, `eslint-lsp`, `prettier`, `json-lsp`
- `tailwindcss-language-server`
- `yaml-language-server` / docker-related
- `asm-lsp`
- `sqlfluff`
- `codelldb`, `js-debug-adapter` (on DAP use)
- `lua-language-server`, `stylua` (nvim lua)

`:Mason` to verify. Install manually if a server missing.

---

## B19. Neovim FAQ

**Q: Why doesn’t format run on save?**  
A: Intentional. `autoformat = false`. Use `<leader>cf`.

**Q: Picker paths are invisible.**  
A: Need `readable-contrast.lua`. Restart nvim.

**Q: Blame too bright/dim.**  
A: Edit `blame_fg` in `gitsigns-blame.lua`.

**Q: LSP not attaching.**  
A: `:LspInfo`, install Mason package, check root, `pnpm i`, `compile_commands.json`.

**Q: Can I use this without Omarchy?**  
A: Yes. Theme file is standalone matteblack.

**Q: Telescope?**  
A: Not primary. Snacks picker is.

**Q: How do I find any keymap?**  
A: `<leader>sk` or `:map` or which-key.

---

# PART C — Tmux deep dive

## C1. Concepts

| Concept | Meaning |
|---------|---------|
| Server | Background tmux process |
| Session | Named collection of windows (`Work`) |
| Window | “Tab” inside a session (Alt-1…) |
| Pane | Split inside a window |
| Client | Your terminal attached to a session |
| Prefix | Key chord that means “tmux command follows" |

Hierarchy:

```text
server
 └── session (Work)
      ├── window 1 (nvim)
      │     ├── pane: nvim
      │     └── pane: shell
      ├── window 2 (dev servers)
      └── window 3 (tunnel / btop)
```

## C2. Install & plugins

See Part A4. Plugins in config:

```tmux
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-strategy-nvim 'session'
```

TPM keys (standard):

| Key | Action |
|-----|--------|
| `prefix` `I` | Install plugins |
| `prefix` `U` | Update plugins |
| `prefix` `alt-u` | Remove unused (TPM) |

## C3. Prefixes & reload

| Key | Action |
|-----|--------|
| `Ctrl-Space` | Prefix |
| `Ctrl-a` | Prefix 2 |
| `prefix` `q` | Reload config + message |
| `prefix` `:` | Tmux command prompt |
| `prefix` `?` | List keys |

Status right shows `PREFIX` when prefix pressed, `COPY` in copy mode, `ZOOM` when zoomed.

### If Ctrl-Space fails

Some terminals capture it. Use `Ctrl-a`, or change terminal keybinds, or remap prefix.

## C4. Sessions — full

| Key / cmd | Action |
|-----------|--------|
| `prefix` `C` | New session (cwd) |
| `prefix` `K` | Kill session |
| `prefix` `R` | Rename session |
| `prefix` `P` / `N` | Prev / next session |
| `Alt-Up` / `Alt-Down` | Prev / next session |
| `prefix` `s` | Interactive session list |
| `prefix` `d` | Detach |
| `prefix` `L` | Last session (default often) |

CLI:

```bash
tmux new -s Work
tmux new -s cp -c ~/Github/cp-setup
tmux ls
tmux attach -t Work
tmux attach          # last/only
tmux kill-session -t Work
tmux rename-session -t old new
```

Omarchy Hyprland: **Super+Alt+Return** often runs `tmux attach || tmux new -s Work`.

### Session naming ideas

| Name | Use |
|------|-----|
| `Work` | default daily |
| `cp` | competitive programming |
| `lab` | low-level / asm |
| `ops` | tunnels / docker / btop |

## C5. Windows — full

| Key | Action |
|-----|--------|
| `prefix` `c` | New window (cwd) |
| `prefix` `X` | Kill window |
| `prefix` `r` | Rename window |
| `Alt-1` … `Alt-9` | Select window N |
| `Alt-Left` / `Right` | Prev / next |
| `Alt-Shift-Left` / `Right` | Swap window + follow |
| `prefix` `n` / `p` | next / prev (defaults may exist) |
| `prefix` `w` | window list (default) |

Windows indexed from **1**. Renumber on close enabled.

Auto name = basename of pane path (`#{b:pane_current_path}`).

### Suggested window layout for fullstack

| Win | Name | Contents |
|-----|------|----------|
| 1 | editor | nvim |
| 2 | api | `pnpm --filter api dev` |
| 3 | web | `pnpm --filter web dev` |
| 4 | db | ssh tunnel + optional `psql` |
| 5 | git | lazygit / shell |

## C6. Panes — full

| Key | Action |
|-----|--------|
| `Alt-Enter` | Split **vertical** (one above other) |
| `Alt-Shift-Enter` | Split **horizontal** (side by side) |
| `prefix` `-` | Split vertical |
| `prefix` `v` | Split horizontal |
| `Alt-Esc` | Kill pane |
| `prefix` `x` | Kill pane |
| `prefix` `h/j/k/l` | Move focus |
| `Ctrl-Alt-Arrows` | Move focus |
| `Ctrl-Alt-Shift-Arrows` | Resize 5 cells |
| `prefix` `z` | Zoom toggle |
| `prefix` `{` / `}` | Swap panes (defaults) |
| `prefix` `Space` | Next layout (default) |
| `prefix` `!` | Break pane to window |

All splits use **`#{pane_current_path}`** — stay in project directory.

### Pane layouts for nvim

**Editor + shell:**

```text
+------------------+----------+
| nvim             | shell    |
|                  |          |
+------------------+----------+
```

`Alt-Shift-Enter` then start shell commands.

**Editor + logs:**

Bottom split (`Alt-Enter`) running `pnpm dev` or `tail -f`.

## C7. Copy mode — full

| Key | Action |
|-----|--------|
| `prefix` `[` | Enter copy mode |
| `q` / `Esc` | Leave (typical) |
| `v` | Begin selection (vi) |
| `y` | Yank + exit |
| Mouse drag | Select (mouse on) |
| `Ctrl-b` / wheel | Scroll history |

History limit: **50000** lines.

`set -g set-clipboard on` + passthrough helps Wayland clipboards with modern terminals.

Search in copy mode (vi): `/` pattern, `n` next — tmux vi mode dependent.

## C8. Mouse

Mouse is **on**:

- Click to select pane
- Drag borders to resize
- Scroll to enter copy / scrollback
- Drag to select text

## C9. Status bar

- Position: **top**
- Left: session name (blue pill)
- Windows: index:name
- Right: COPY/PREFIX/ZOOM flags + hostname

## C10. Resurrect — full

| Key | Action |
|-----|--------|
| `prefix` `Ctrl-s` | Save |
| `prefix` `Ctrl-r` | Restore |

Saves sessions/windows/panes + pane contents. Nvim strategy `session` tries to restore editor sessions when possible.

### Ritual

Before reboot/logout:

1. `prefix` `Ctrl-s`
2. Wait for save confirmation

After boot:

1. Attach tmux
2. `prefix` `Ctrl-r`

### Limitations

- Not every process restores perfectly (some servers need restart)
- Not continuum (no auto-save timer) — **manual**
- Save files under `~/.tmux/resurrect/`

### Verify plugin loaded

```bash
tmux show -g @plugin
ls ~/.tmux/plugins/tmux-resurrect
```

## C11. Config options explained (this file)

| Option | Value | Why |
|--------|-------|-----|
| `default-terminal` | tmux-256color | correct colors |
| `terminal-overrides RGB` | on | truecolor |
| `escape-time` | 10ms | nvim feel (no duplicate 0) |
| `focus-events` | on | vim autoread / plugins |
| `allow-passthrough` | on | images / advanced term |
| `extended-keys` | on | better key encoding |
| `detach-on-destroy` | off | don’t drop client when killing last |
| `base-index` | 1 | human window numbers |
| `history-limit` | 50000 | deep scrollback |

## C12. CLI cookbook

```bash
tmux list-sessions
tmux list-windows -t Work
tmux list-panes -t Work:1
tmux capture-pane -p -S -1000
tmux source-file ~/.config/tmux/tmux.conf
tmux kill-server          # nuclear: kills all sessions
tmux new-session -d -s bot 'while true; do date; sleep 60; done'
```

## C13. Nested tmux / SSH

If you tmux over SSH inside local tmux:

- Local prefix `Ctrl-Space`
- Remote might use `Ctrl-a` or send-prefix tricks
- `prefix` `prefix` sends prefix through (`send-prefix`)

## C14. Tmux FAQ

**Q: Alt-1 does nothing.**  
A: WM/terminal steals Alt. Use `prefix` `1` defaults or free the binding in Hyprland/terminal.

**Q: Config reset after update.**  
A: Omarchy refresh overwrote it — restore from this repo.

**Q: Resurrect keys don’t work.**  
A: Plugin not installed — `prefix I` or clone repo.

**Q: Nvim colors wrong in tmux.**  
A: Ensure `tmux-256color` + RGB overrides; restart tmux server.

**Q: How do I sync pane path?**  
A: Already default for new splits; for existing, `cd` manually or open new split.

---

# PART D — Combined workflows (huge)

## D1. Morning attach

1. Super+Alt+Return (or `tmux a -t Work`)
2. If empty: restore `prefix` `Ctrl-r` OR create windows
3. Window 1: `nvim`
4. Window 2: start dev servers

## D2. Fullstack monorepo day

```text
Win1: nvim (apps/api + apps/web via picker/harpoon)
Win2: pnpm --filter api dev
Win3: pnpm --filter web dev
Win4: ssh -N -L 5433:...
```

In nvim:

- `<leader><space>` jump files
- `<leader>D` query DB on tunnel
- `<leader>Rs` hit HTTP endpoints from `.http`
- `<leader>db` + `<leader>dc` debug API when needed

## D3. CP contest mode

```text
Session: cp
Win1: nvim with <leader>rl
Win2: optional shell / standby
```

Loop: edit → `<leader>rr` → read output → Harpoon 1/2/3.

## D4. Low-level / asm lab

```text
Win1: nvim .s / .c
Win2: make / gdb or DAP
```

Ensure asm-lsp config; use `K` on instructions.

## D5. Debug-heavy day (Node)

1. `NODE_OPTIONS=--inspect pnpm --filter api dev` in tmux win2
2. nvim win1: breakpoints
3. `<leader>dc` → Attach
4. DAP UI on the side; zoom tmux pane if needed (`prefix z`)

## D6. Debug-heavy day (C++)

1. Build Debug binary in win2
2. Breakpoints in nvim
3. Launch via DAP or attach
4. Keep `input.txt` in harpoon for CP-like apps

## D7. DB investigation

1. Tunnel pane stays alive
2. DBUI for ad-hoc SQL
3. Schema file harpooned
4. REST file to reproduce API path that touches DB

## D8. Dotfiles editing

```bash
nvim ~/Github/dotfiles
# or symlink already points ~/.config/nvim → repo
```

After tmux.conf edit: `prefix q`.  
After nvim edit: restart nvim or `:source` as appropriate (Lazy configs often need restart).

## D9. End of day

1. `prefix` `Ctrl-s` (resurrect)
2. Detach `prefix` `d` (leave servers running) OR kill if done
3. Lock machine

## D10. Pairing / screen share

- Increase font in terminal
- Status bar already top — visible session name
- Avoid sharing DB secrets panes; use read-only URLs

---

# PART E — Reference

## E1. Troubleshooting mega-table

| Symptom | Area | Fix |
|---------|------|-----|
| LSP none | nvim | `:LspInfo` `:Mason` root `pnpm i` compile_commands |
| Picker paths invisible | nvim | readable-contrast; restart |
| Blame invisible | nvim | gitsigns-blame color |
| TS slow | nvim | exclude huge folders; restart vtsls |
| Format not on save | nvim | expected; `<leader>cf` |
| DAP no adapter | nvim | Mason codelldb / js-debug |
| C++ bp miss | nvim | `-g -O0` rebuild right binary |
| TS launch fail | nvim | install `tsx` |
| Dadbod empty | nvim | env or db-secrets.lua |
| SQL ran on save | nvim | should be off; check `g:db_ui_execute_on_save` |
| asm-lsp root | nvim | git init or toml |
| Prefix ignored | tmux | try Ctrl-a; check terminal |
| Alt keys dead | tmux | WM conflict |
| Resurrect missing | tmux | TPM install |
| Colors wrong | tmux | terminfo RGB; restart server |
| Config wiped | tmux | restore from dotfiles; avoid omarchy-refresh |

## E2. Cheatsheet — Neovim dense

```text
Modes: Esc normal | i insert | v visual | : command

Grammar: [count][op][motion/object]   e.g. d3w  ci"  ya{

Space          leader / which-key
Space Space    files
Space /        grep
Space e        explorer
Space sk       search keymaps
Space gB       toggle blame
Space ghb      blame line
Space ghs      stage hunk
Space D        database
Space Rs       REST send
Space rl/rr    CP layout/run
Space H/h      harpoon add/menu
Space 1..9     harpoon jump
Space db/dc    break/continue
Space dO/di/do step over/into/out
Space dt/du/de terminate/UI/eval
Space cr       rename
Space cf       format
Space ca       code action
gd K gr ]d     def/hover/refs/diag
```

## E3. Cheatsheet — Tmux dense

```text
C-Space / C-a     prefix
prefix q          reload
prefix I          TPM install
prefix C-s/C-r    resurrect save/restore

Alt-Enter         split vertical
Alt-S-Enter       split horizontal
Alt-Esc           kill pane
prefix hjkl       panes
C-M-arrows        panes
C-M-S-arrows      resize

Alt-1..9          windows
Alt-Left/Right    windows
prefix c / X      new / kill window
prefix r          rename window

Alt-Up/Down       sessions
prefix C / K      new / kill session
prefix R          rename session
prefix d          detach
prefix s          session picker
prefix z          zoom pane
prefix [  v y     copy mode
```

## E4. Cheatsheet — Debug C++

```text
g++ -g -O0 -o app app.cpp
nvim app.cpp → Space db → Space dc → Launch → ./app
Space dO step over | Space di into | Space dt stop
```

## E5. Cheatsheet — Debug Node/TS

```text
# launch file
nvim file.ts → Space db → Space dc → Launch file   (needs tsx)

# attach
NODE_OPTIONS=--inspect pnpm dev
nvim → Space dc → Attach → pick PID
```

## E6. Glossary

| Term | Definition |
|------|------------|
| LSP | Language Server Protocol — intel engine |
| DAP | Debug Adapter Protocol — debugger engine |
| Mason | Neovim package manager for LSP/DAP/tools |
| LazyVim | Neovim distro on lazy.nvim |
| Extra | Optional LazyVim feature pack |
| Hunk | Git changed region |
| Buffer | In-memory file |
| Root | Project directory LSP attached to |
| Prefix | Tmux leader key |
| Resurrect | Save/restore tmux state |
| vtsls | TS language server used here |
| codelldb | C/C++ debug adapter |
| Dadbod | DB client framework for Vim |
| Snacks | Folke’s UI/picker library |
| GAS | GNU Assembler |

## E7. File map (repo)

```text
.config/nvim/           LazyVim snapshot
.config/tmux/tmux.conf  Tmux + resurrect
.tmux.conf              Compatibility stub
NVIM_TMUX.md            This encyclopedia
README.md               Short entry
INSTALL.md              Install notes
KEYBINDINGS.md          Pointer here
```

## E8. Related upstream docs

- LazyVim: https://www.lazyvim.org/
- Hyprland (if desktop): https://wiki.hypr.land/
- tmux man page: `man tmux`
- asm-lsp: https://github.com/bergercookie/asm-lsp
- dadbod-ui: https://github.com/kristijanhusak/vim-dadbod-ui
- nvim-dap: https://github.com/mfussenegger/nvim-dap

## E9. Maintenance checklist (monthly)

- [ ] `git pull` dotfiles
- [ ] `:Lazy sync`
- [ ] `:Mason` update tools
- [ ] tmux `prefix U`
- [ ] Test resurrect save/restore
- [ ] Confirm DB secrets still valid
- [ ] Rebuild `compile_commands.json` for big C++ repos

## E10. Final dense “I forgot everything” card

```text
EDIT:  nvim in tmux    Space=leader    Space Space=files
CODE:  gd K ca cr cf   ]d diagnostics
GIT:   Space gB blame  ]h hunks
CP:    Space rl / rr   Space 1/2/3 files
DB:    Space D         tunnel to localhost port
DBG:   Space db dc dO di dt du
HTTP:  Space Rs in .http file
TMUX:  C-Space         Alt-Enter split   Alt-1 win
SAVE:  prefix C-s      RESTORE prefix C-r
```

---

*End of encyclopedia. This document intentionally over-explains so future-you never has to guess.*


---

# PART F — Practice curricula (get dangerous fast)

## F1. Vim grammar — 30 minute drill

Do this in a throwaway file (`nvim /tmp/drill.txt`):

1. Type 20 lines of nonsense.
2. `dd` five times; `u` undo.
3. `yy` then `p` then `3p`.
4. `viw` select word; `y`; move; `p`.
5. `ci"` on a quoted string (create `"hello"` first).
6. `da(` on `(x, y)`.
7. `>ap` then `<ap` on a paragraph.
8. Record macro `qa` … `q` that uppercases a word (`gUiw`) and moves down `j`; run `@a` then `10@a`.
9. `/hello` then `n` `n` `cgn` replacement pattern practice.
10. `gg=G` indent file (if filetype allows).

Repeat daily for a week.

## F2. LazyVim navigation — 20 minute drill

In a real repo:

1. `<leader><space>` open 5 different files without neo-tree.
2. `<leader>/` find a string; jump; `Ctrl-o` back.
3. `<leader>e` rename a file in neo-tree; open it.
4. Set Harpoon on 3 files; jump `<leader>1` `2` `3` only for 5 minutes (no picker).
5. `<leader>sk` find a keymap you forgot.

## F3. LSP — 20 minute drill

1. `gd` into a function; read; `Ctrl-o` back.
2. `gr` list refs; jump two of them.
3. `K` hover three symbols.
4. Trigger a diagnostic (break a type); `<leader>ca` fix.
5. `<leader>cr` rename a local symbol safely.

## F4. DAP — 20 minute drill (TS)

1. Create ` /tmp/dbg.ts` with a loop and `console.log`.
2. Breakpoint on loop; Launch file.
3. Step over 5 times; inspect variables in DAP UI.
4. `<leader>de` eval an expression.
5. Terminate; run again with `<leader>dl`.

## F5. DAP — 20 minute drill (C++)

```bash
cat > /tmp/dbg.cpp <<'EOF'
#include <iostream>
int main() {
  int s = 0;
  for (int i = 0; i < 5; ++i) s += i;
  std::cout << s << "\n";
}
EOF
g++ -g -O0 -o /tmp/dbg /tmp/dbg.cpp
nvim /tmp/dbg.cpp
```

Breakpoint in loop → Launch `/tmp/dbg` → step → watch `s`.

## F6. Tmux muscle memory — 15 minute drill

1. Create session `drill`.
2. Make 3 windows; rename them.
3. Split window 1 into 3 panes; resize; zoom; unzoom.
4. Kill one pane; create again.
5. `prefix Ctrl-s`; `tmux kill-server`; attach; `prefix Ctrl-r`.

## F7. One-week onboarding plan

| Day | Focus |
|-----|-------|
| 1 | Install + picker + neo-tree + save/quit |
| 2 | Vim grammar drill + buffers/splits |
| 3 | LSP keys in your main language |
| 4 | Git blame + hunks |
| 5 | Tmux sessions/windows/panes + resurrect |
| 6 | DAP for your main language |
| 7 | CP or fullstack combined workflow |

---

# PART G — Scenario runbooks

## G1. “I need to fix a Hono bug in a monorepo”

1. `tmux a -t Work` (or create).
2. Win1: `nvim` at repo root (or `apps/api`).
3. Win2: `pnpm --filter api dev` with `--inspect` if debugging.
4. `<leader><space>` → controller/route file.
5. `<leader>/` → search error string / route path.
6. `gd` through handlers; check Drizzle query.
7. Optional: `<leader>D` verify DB rows via tunnel.
8. Optional: `.http` file `<leader>Rs` reproduce.
9. If logic bug: breakpoint + attach DAP.
10. Commit from win3 lazygit/shell.

## G2. “Production DB look only”

1. Start SSH tunnel to read replica if possible.
2. Use read-only DB user in `db-secrets.lua`.
3. `<leader>D` → run `SELECT` only.
4. Never enable execute-on-save.
5. Close tunnel when done.

## G3. “Contest starts in 5 minutes”

1. `tmux new -s cp -c ~/Github/cp-setup`
2. `nvim` → `<leader>rl`
3. Paste template into `yo.cpp` if you use one
4. Keep `<leader>rr` finger-ready
5. Don’t start DAP unless stuck on logic

## G4. “Nvim feels broken after update”

1. `:checkhealth`
2. `:Lazy sync`
3. `:Mason` reinstall broken server
4. Move `lazy-lock.json` aside only if necessary (last resort)
5. Restore configs from this git repo

## G5. “Tmux wiped my layout”

1. `prefix Ctrl-r` restore last resurrect
2. If none: recreate using D2/D3 layouts
3. Immediately `prefix Ctrl-s` after rebuilding

## G6. “Clangd false errors everywhere”

1. Generate `compile_commands.json`
2. Symlink to project root
3. `:LspRestart`
4. Check `.clangd` for Remove/Add flags

## G7. “TS server using wrong version”

1. `<leader>cV` select workspace TS
2. Ensure local `node_modules/typescript` exists
3. Restart vtsls (`:LspRestart`)

---

# PART H — Annotated tmux.conf (line-by-line intent)

```tmux
# Prefixes: Ctrl-Space primary, Ctrl-a secondary (screen muscle memory)
set -g prefix C-Space
set -g prefix2 C-a
unbind C-b
bind C-Space send-prefix
bind C-a send-prefix -2

# prefix+q reloads THIS config path
bind q source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

# Vi copy mode + v/y like vim visual/yank
setw -g mode-keys vi
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send -X copy-selection-and-cancel

# Prefixless splits/kill for speed (Meta/Alt)
bind -n M-Enter split-window -v -c "#{pane_current_path}"
bind -n M-S-Enter split-window -h -c "#{pane_current_path}"
bind -n M-Escape kill-pane

# Prefixed splits + vim pane movement (h was freed from split)
bind - split-window -v -c "#{pane_current_path}"
bind v split-window -h -c "#{pane_current_path}"
bind x kill-pane
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Arrow pane nav / resize with Ctrl-Meta
# ... see config for full arrow bindings ...

# Windows: rename/new/kill; Alt-number jump; Alt-arrows move/swap
# Sessions: create/kill/rename; Alt-Up/Down switch

# Terminal hygiene for nvim/truecolor/clipboard/passthrough
# Status top; auto rename from path basename
# Resurrect + TPM at bottom — MUST stay at bottom (run tpm last)
```

Read the real file at `.config/tmux/tmux.conf` for exact lines.

---

# PART I — Annotated Neovim custom snippets

## I1. Blame color

In `gitsigns-blame.lua`, `blame_fg = "#E68E0D"`. Change to grey `#A3A3A3` if amber is loud.

## I2. Contrast palette

In `readable-contrast.lua`:

- `dim` — soft muted (`#8A8A8D`)
- `muted` — path text (`#A3A3A3`)
- `soft` — indent/separators (`#737373`)

## I3. CP harpoon pin function

`<leader>rl` clears Harpoon then adds code/input/output. If you want to keep other pins, remove `list:clear()` (code change).

## I4. Dadbod env pattern matching

Any `DB_FOO_URL` becomes connection `foo`. Avoid collisions with `DB_DEV_URL` (also added as `dev` explicitly).

---

# PART J — Keybinding conflict notes

| Combo | Where | Conflict risk |
|-------|-------|---------------|
| `Alt-Enter` | tmux split | Some terminals use for “new tab/window” |
| `Ctrl-Space` | tmux prefix | IME / OS spotlight sometimes |
| `Space` | nvim leader | Fine in normal mode; in insert Space inserts space |
| `Alt-1..9` | tmux windows | Hyprland rarely steals Alt alone; Super+Alt used instead |
| `<leader>D` | Dadbod | Capital D — not the same as `<leader>d` debug menu |
| `<leader>R` | REST | Capital R — CP uses `<leader>r` lowercase (`rl` `rr`) |

Remember: **case matters** for leader menus (`d` debug vs `D` database).

---

# PART K — Performance tips

## Neovim

- Don’t open gigantic generated folders; add to ignore
- Disable unused LazyExtras
- For huge TS monorepos, open package subdirectory sometimes
- `:LspStop` in huge JSON dumps if needed

## Tmux

- 50k history uses memory — reduce `history-limit` if RAM tight
- Many resurrected panes with build watchers → heavy; start watchers manually after restore

---

# PART L — Security notes

- Never commit `db-secrets.lua` or `.env`
- Prefer read-only DB users for tunnels
- Resurrect may restore pane contents — don’t leave secrets scrolled on screen if sharing
- `allow-passthrough` is powerful; keep terminal updated

---

# PART M — Migrating from the old NvChad/i3 dotfiles

This repo previously had NvChad-ish nvim + `.tmux.conf` flat + i3.

| Old | New |
|-----|-----|
| NvChad lua tree | LazyVim `.config/nvim` |
| `~/.tmux.conf` only | `~/.config/tmux/tmux.conf` + stub |
| i3 keybindings doc | Still present historically; editor focus is `NVIM_TMUX.md` |

When migrating a machine still on old paths:

1. Backup `~/.config/nvim` → `nvim.bak`
2. Symlink new tree
3. Move tmux to XDG path
4. Open nvim once offline-capable network for plugin fetch

---

# PART N — Printable pocket cards

### Card A — Edit

```text
Esc normal | Space leader | Space Space files | Space / grep
gd K ca cr | Space cf format | Space e tree
```

### Card B — Git/DB/CP

```text
Space gB blame | ]h hunks
Space D dbui | Space Rs http
Space rl layout | Space rr run | Space 1/2/3
```

### Card C — Debug

```text
Space db bp | Space dc go | Space dO over | Space di into
Space do out | Space dt stop | Space du ui | Space de eval
```

### Card D — Tmux

```text
C-Space prefix | Alt-Enter split | Alt-1..9 wins
prefix hjkl panes | prefix C-s save | prefix C-r restore
```

---

# PART O — Changelog of this documentation

| Version | Notes |
|---------|-------|
| v1 | Initial guide (~700 lines) |
| v2 | Expanded DAP section |
| v3 | Encyclopedia rewrite (~parts A–E) |
| v4 | Practice curricula, runbooks, annotations, pocket cards (this) |

---

# PART P — Index of everything (search keywords)

`asm-lsp` · `autoformat` · `blame` · `blink` · `breakpoint` · `clangd` · `codelldb` · `compile_commands` · `contrast` · `copy-mode` · `dadbod` · `dap` · `drizzle` · `eslint` · `gas` · `harpoon` · `hono` · `illuminate` · `inc-rename` · `js-debug` · `kulala` · `lazyvim` · `leader` · `mason` · `matteblack` · `neo-tree` · `prefix` · `prettier` · `project` · `resurrect` · `snacks` · `sql` · `surround` · `tailwind` · `tpm` · `treesitter-context` · `tsx` · `tunnel` · `vtsls` · `which-key` · `yanky` · `yo.cpp`

If you can name the keyword, `rg -n keyword NVIM_TMUX.md` jumps you here.

---

*Truly the end. If something is still missing, add a Part Q in a PR to yourself.*
