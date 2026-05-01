# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Dotfiles repository syncing terminal and editor configurations across machines via Git. Configs are symlinked from their expected system locations to this repo.

## GitHub Pages

`index.html` is a self-contained interactive cheatsheet published via GitHub Pages at `https://ilyachenko.github.io/configurations/`. It is generated from the same content as `cheatsheet.md` but with live search, collapsible sections, and styled key badges.

## Setup

Run the automated installer from the repo root:

```bash
./install.sh
```

This creates symlinks for tmux, ghostty, wezterm, mc, and gitui, backing up any existing files as `.bak`.

Install TPM for tmux plugins (required once per machine):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then inside tmux press `prefix + I` to install plugins.

Manual symlink commands:
```bash
ln -s ~/dev/configurations/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/dev/configurations/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
ln -s ~/dev/configurations/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
```

## Configurations

### tmux (`tmux/.tmux.conf`)
- Mouse support, vi copy-mode, 100k scrollback
- Prefix + `%`/`"` splits preserving current path
- Prefix + `H/J/K/L` for pane resizing (repeatable)
- Prefix + `C-c` opens VS Code in current pane path
- Prefix + `C-z` opens Zed in current pane path
- Prefix + `Q` kills a session interactively via fzf
- Status bar: session/window/pane index, current mode, time in Europe/Lisbon and Europe/Warsaw
- Plugins via TPM: `tmux-resurrect` (manual save/restore), `tmux-continuum` (auto-save every 15min, auto-restore on start), `tmux-fzf-url` (extract and open URLs)
  - `prefix + Ctrl-s` — save session, `prefix + Ctrl-r` — restore manually
  - `prefix + u` — extract URLs from pane into fzf, select to open in browser

After editing, apply changes without restarting tmux:
```bash
tmux source-file ~/.tmux.conf
```

### Ghostty (`ghostty/config`)
- Theme: Catppuccin Macchiato, opacity 0.95
- Quick terminal: Cmd+Backquote toggle
- Float toggle: Cmd+Alt+T
- Saves window state across sessions

### WezTerm (`wezterm/wezterm.lua`)
- Theme: Kanagawa (Gogh), opacity 0.85, macOS blur 25
- 100k scrollback, borderless-resizable window chrome
- Shift+Enter → ESC+Enter (matches Ghostty)
- Cmd+Alt+T toggles always-on-top
- Ctrl+Shift+Arrows for pane resize
- Ctrl+Click opens URLs (works inside tmux via `mouse_reporting = true`)

### Midnight Commander (`mc/ini`)
- Skin: `modarin256-defbg` (avoids ANSI color remapping conflicts with Catppuccin)
- Symlinked to `~/.config/mc/ini`

### gitui (`gitui/theme.ron`)
- Catppuccin Macchiato theme using hex colors (bypasses ANSI remapping)
- Symlinked to both `~/.config/gitui/theme.ron` and `~/Library/Application Support/gitui/theme.ron` (macOS uses the latter)

### Zsh common config (`zsh/common.zsh`)

Portable shell functions sourced from `~/.zshrc` via:
```zsh
source ~/dev/configurations/zsh/common.zsh
```

Currently includes:
- OSC 7 CWD reporting to tmux — keeps `pane_current_path` accurate for tmux-resurrect path restoration
- `claude()` stub — prevents accidentally running bare `claude` without a profile alias
- robbyrussell git prompt color overrides — green branch when clean, yellow `✗` when dirty (theme default is always red)
- `za()` — attach to a zellij session picked via fzf (`zellij list-sessions | fzf`)
### Zsh scripts (`zsh/`)

- `history-clean.py` — interactive fzf tool to find and remove long commands from `~/.zsh_history`
  - Usage: `~/dev/configurations/zsh/history-clean.py [-r] [min_length]` (default: 100 chars)
  - `-r` — show most recent entries first
  - Shows age of each entry; Tab to select, Alt-A to select all, Enter to remove

### Claude Code commands (`.claude/commands/`)

- `/backlog <idea>` — append an idea to `BACKLOG.md` in the current project root

### Claude Code statusline (`claude/statusline.md`)
- Command-based statusline config for `~/.claude/settings.json`
- Shared script at `claude/statusline-command.sh` — used by all profiles, profile badge detected via `$CLAUDE_CONFIG_DIR`
- Shortens directory names via `~/.zsh_custom_paths.txt` (format: `full_path:short_name`, one per line)
- Shows: `[P] <dir> (branch) ➜ <model> <remaining>% <reset>:<5h_usage>% <reset>:<7d_usage>%`
- Git branch in green (clean) or yellow (dirty); output style shown only when non-default; usage % colored green/yellow/red by urgency

### Claude Code multiple instances

Multiple isolated Claude Code profiles via `CLAUDE_CONFIG_DIR` aliases in `~/.zshrc`:

```zsh
alias cc-personal='CLAUDE_CONFIG_DIR=~/.cc-personal command claude'
alias cc-work='CLAUDE_CONFIG_DIR=~/.cc-work command claude'
function claude() { echo "Use cc-personal or cc-work instead of claude directly."; }
```

Each alias gets its own config directory with separate `settings.json` (API keys, permissions, statusline, MCP servers, etc.). The default `claude` command uses `~/.claude`.

The `claude` function stubs out the bare command to prevent accidentally launching Claude without a profile.

To install the statusline into a non-default profile, use the `statusline-setup` agent and specify the target `settings.json` path explicitly.

### Claude Code permissions (`~/.claude/settings.json`)

The following permission rules should be present in the user's global `~/.claude/settings.json` under `permissions.allow`:

- `WebFetch(domain:github.com)` — allow web access to github.com without prompting
