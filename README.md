# configurations

Dotfiles repository syncing terminal and editor configurations across machines via Git.

## Structure

```
tmux/         .tmux.conf
ghostty/      config
wezterm/      wezterm.lua
mc/           ini
gitui/        theme.ron
claude/       statusline-command.sh, statusline.md
install.sh
cheatsheet.md
```

## Setup

Run the automated installer from the repo root:

```bash
./install.sh
```

This creates symlinks for tmux, ghostty, wezterm, mc, and gitui, backing up any existing files as `.bak`. Also ensures the Claude statusline script is executable.

Install TPM for tmux plugins (required once per machine):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then inside tmux press `prefix + I` to install plugins.

## Configurations

- **tmux** — mouse, vi copy-mode, 100k scrollback, pane splits/resize, VS Code & Zed integration, fzf session killer, tmux-resurrect/continuum
- **ghostty** — Catppuccin Macchiato, quick terminal toggle, float toggle
- **wezterm** — Kanagawa theme, URL opening, always-on-top toggle, pane resize
- **mc** — modarin256-defbg skin
- **gitui** — Catppuccin Macchiato theme
- **claude** — shared statusline script for all Claude Code profiles

See `cheatsheet.md` for keybinding reference.
