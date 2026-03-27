# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Dotfiles repository syncing terminal and editor configurations across machines via Git. Configs are symlinked from their expected system locations to this repo.

## Setup

Run the automated installer from the repo root:

```bash
./install.sh
```

This creates symlinks for tmux, ghostty, and wezterm, backing up any existing files as `.bak`.

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
- Plugins via TPM: `tmux-resurrect` (manual save/restore) and `tmux-continuum` (auto-save every 15min, auto-restore on start)
  - `prefix + Ctrl-s` — save session, `prefix + Ctrl-r` — restore manually

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

### Claude Code statusline (`claude/statusline.md`)
- Command-based statusline config for `~/.claude/settings.json`
- Shortens directory names via `~/.zsh_custom_paths.txt` (format: `full_path:short_name`, one per line)
- Shows: `<dir> (branch) ➜ <model> | <output_style> ctx:<remaining>% 7d:<weekly_usage>%`
- Git branch in green (clean) or yellow (dirty)
