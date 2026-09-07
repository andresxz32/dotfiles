# Terminal Mastery & Neovim Learning Guide

Everything below assumes the dotfiles setup we built together (chezmoi + mise + Starship + LazyVim). This is your reference doc — bookmark it, don't try to absorb it all in one sitting.

---

## Part 1 — What each tool actually does

| Tool | What it replaces | What it actually gives you |
|---|---|---|
| **zsh** | bash | The shell itself. Better completion, plugins, and it's what Starship/mise hook into. |
| **Starship** | default prompt | Shows git branch/status, language versions, command duration — right in your prompt, per directory. |
| **eza** | `ls` | Icons, git status per file, tree view (`eza --tree`). |
| **bat** | `cat` | Syntax highlighting + line numbers when you print a file. |
| **ripgrep (`rg`)** | `grep` | Searches entire codebases in milliseconds, respects `.gitignore` automatically. |
| **fd** | `find` | Simple syntax (`fd config` vs `find . -iname "*config*"`), also respects `.gitignore`. |
| **fzf** | manual scrolling/`Ctrl+R` | Fuzzy-search anything: command history, files, git branches. The connective tissue between most other tools. |
| **zoxide** | `cd` | Learns your habits — `z proj` jumps to `~/dev/my-project` after you've visited it once. |
| **jq** | manual JSON reading | Query and reformat JSON from the command line (`curl ... \| jq .`). |
| **btop** | `top`/`htop` | Live CPU/memory/process view, mouse-clickable, much easier to read. |
| **lazygit** | raw `git` commands | Full git workflow (stage, commit, branch, rebase, stash) in a visual terminal UI. |
| **git-delta** | default git diff | Side-by-side, syntax-highlighted diffs (already wired into your `.gitconfig`). |
| **mise** | nvm / pyenv / rustup | One tool, one config file, manages Node/Python/Rust/Go versions per-project. |
| **Neovim (LazyVim)** | VS Code (optionally) | A fully keyboard-driven editor: modal editing, LSP, fuzzy-finding, all in the terminal. |
| **tmux** | multiple terminal windows | Persistent sessions — close your laptop, reopen, your panes/work are still there. |
| **WezTerm** | default terminal app | GPU-accelerated, single Lua config file, works identically across OSes. |
| **Docker Desktop** | manual VM/container mgmt | Runs containers; on Windows it uses your WSL2 Ubuntu as the actual backend. |
| **VS Code** | — | Kept as a secondary editor / for Remote-WSL work when you don't want full Neovim. |

---

## Part 2 — Productivity workflows (the combinations that matter)

Individually these tools are nice. Combined, they're the actual point.

**Finding and jumping around**
```sh
z proj          # zoxide: jump to the ~/dev/proj you've visited before
ll               # eza: see what's here, with git status inline
fd component     # find every file with "component" in the name
rg "TODO"        # find every TODO comment in the whole project instantly
```

**The fzf trick that changes everything:** press `Ctrl+R` in your terminal right now — that's fzf hijacking your shell history search. Type a few letters of a command you ran last week; it'll find it. Also try `Ctrl+T` to fuzzy-insert a file path into your current command.

**Git without leaving the keyboard**
```sh
lg               # opens lazygit — stage files with space, commit with c, push with P
```
Learn lazygit's on-screen key hints first; don't memorize anything upfront. It shows you the keys for whatever panel you're in.

**Runtime versions per project**
```sh
cd my-node-project
mise use node@20      # writes a .mise.toml pinning this project to Node 20
mise use python@3.11  # same project can also pin Python, independently
```
This is the whole point of `mise` over `nvm`: versions travel with the project, in git, so a teammate cloning it gets the same setup automatically.

**Terminal multiplexing (tmux) — the 4 commands you need to start**
| Key | Action |
|---|---|
| `tmux` | start a new session |
| `Ctrl+b` then `d` | detach (work keeps running in background) |
| `tmux attach` | reattach to it later |
| `Ctrl+b` then `%` / `"` | split pane vertically / horizontally |
| `Ctrl+b` then `Up/Down/Left/Right` | Move between pane |
| `Ctrl+b hold...` then `Up/Down/Left/Right` | Resize pane |

---

## Part 3 — Learning Neovim (LazyVim), without burning out

You're right that it's a real learning curve — but LazyVim removes about 80% of the usual setup pain, so you're really only learning **Vim motions** + **a handful of LazyVim-specific keybindings**. Go in this order, don't skip ahead:

### Week 1 — Survive without a mouse
Forget everything else. Master just this:
| Key | Action |
|---|---|
| `i` | insert mode (start typing) |
| `Esc` | back to normal mode |
| `h j k l` | left / down / up / right |
| `w` / `b` | jump forward / backward one word |
| `0` / `$` | start / end of line |
| `dd` | delete (cut) a line |
| `yy` | copy a line |
| `p` | paste |
| `u` | undo |
| `:w` then `:q` | save, then quit |

Do all your normal editing this way for a week before adding anything else. Painfully slow at first — that's expected and normal.

### Week 2 — Move like you mean it
| Key | Action |
|---|---|
| `ciw` | change the whole word your cursor is on |
| `dap` | delete a whole paragraph |
| `gg` / `G` | top / bottom of file |
| `Ctrl+d` / `Ctrl+u` | half-page down / up |
| `/searchterm` then `n` | search, jump to next match |
| `.` | repeat your last change — this one's a superpower |

### Week 3 — LazyVim's own tools (leader key = `Space`)
| Keys | Action |
|---|---|
| `<Space> f f` | fuzzy-find a file (this is Telescope, wired to `fd`) |
| `<Space> f g` | live grep across the whole project (wired to `ripgrep`) |
| `<Space> e` | toggle the file explorer sidebar |
| `<Space> w` | save (we mapped this ourselves in `keymaps.lua`) |
| `gd` | jump to a function/variable's definition (LSP) |
| `K` | show docs/type info for whatever's under the cursor |
| `<Space> c a` | code actions (auto-fix, rename, etc. — LSP-powered) |

### Week 4 — Git + terminal, without leaving Neovim
| Keys | Action |
|---|---|
| `<Space> g g` | opens **lazygit** inside a Neovim floating window |
| `<Space> f t` (if you add it) | toggle a terminal pane inside Neovim |

### Ongoing — how to actually get good
- **Don't reach for arrow keys or the mouse**, even when it's slower at first. The whole payoff is muscle memory.
- Keep a sticky note with just the Week 1 table until it's automatic — resist adding more too fast.
- When you're stuck, press `<Space>` and just **wait** — LazyVim's `which-key` popup shows every available keybinding from wherever you are. This is the built-in cheat sheet; you don't need to memorize much.
- Once Weeks 1–3 feel natural (probably 3–4 weeks of daily use), you'll naturally start wanting your own tweaks — that's when we come back and customize `lua/plugins/` further.

---

## Part 4 — Quick daily-driver checklist

A realistic day-one-productive workflow, start to finish:
```sh
z my-project          # zoxide jumps you there
lg                     # check git status visually, pull latest
nvim .                 # open the project
```
Inside Neovim: `<Space>ff` to open a file, edit with Week 1–2 motions, `<Space>gg` to commit via lazygit without leaving the editor, `:wq` when done.

---

## Where to go deeper (optional, don't rush these)
- `:Tutor` inside Neovim — the official interactive Vim tutorial, built in.
- LazyVim docs: https://www.lazyvim.org/
- `lazygit`'s own in-app `?` help screen shows every keybinding contextually.

Learning this stack is a multi-week process, not a weekend. Come back anytime you get stuck on something specific — that's more useful than trying to front-load everything now.
