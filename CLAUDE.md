# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Dotfiles repository syncing terminal and editor configurations across machines via Git. Configs are symlinked from their expected system locations to this repo.

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
- Theme: Catppuccin Macchiato, opacity 0.75, macOS blur 20
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

### Claude Code statusline (`claude/statusline.md`)
- Command-based statusline config for `~/.claude/settings.json`
- Shortens directory names via `~/.zsh_custom_paths.txt` (format: `full_path:short_name`, one per line)
- Shows: `<dir> (branch) ➜ <model> | <output_style> ctx:<remaining>% 5h:<five_hour_usage>% 7d:<weekly_usage>%`
- Git branch in green (clean) or yellow (dirty)

### Claude Code multiple instances

Multiple isolated Claude Code profiles via `CLAUDE_CONFIG_DIR` aliases in `~/.zshrc`:

```zsh
alias cc-personal='CLAUDE_CONFIG_DIR=~/.cc-personal claude'
alias cc-work='CLAUDE_CONFIG_DIR=~/.cc-work claude'
```

Each alias gets its own config directory with separate `settings.json` (API keys, permissions, statusline, MCP servers, etc.). The default `claude` command uses `~/.claude`.

To install the statusline into a non-default profile, use the `statusline-setup` agent and specify the target `settings.json` path explicitly.

### Claude Code permissions (`~/.claude/settings.json`)

The following permission rules should be present in the user's global `~/.claude/settings.json` under `permissions.allow`:

- `WebFetch(domain:github.com)` — allow web access to github.com without prompting
