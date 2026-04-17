#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
    local src="$1"
    local dst="$2"
    local dir
    dir="$(dirname "$dst")"

    mkdir -p "$dir"

    if [[ -L "$dst" ]]; then
        echo "  relink: $dst"
        ln -sf "$src" "$dst"
    elif [[ -e "$dst" ]]; then
        echo "  backup: $dst -> $dst.bak"
        mv "$dst" "$dst.bak"
        ln -s "$src" "$dst"
    else
        echo "  link:   $dst"
        ln -s "$src" "$dst"
    fi
}

echo "==> tmux"
link "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link "$REPO_DIR/tmux/kill-session.sh" "$HOME/.tmux/kill-session.sh"

echo "==> ghostty"
link "$REPO_DIR/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

echo "==> wezterm"
link "$REPO_DIR/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

echo "==> mc"
link "$REPO_DIR/mc/ini" "$HOME/.config/mc/ini"

echo "==> gitui"
link "$REPO_DIR/gitui/theme.ron" "$HOME/.config/gitui/theme.ron"
link "$REPO_DIR/gitui/theme.ron" "$HOME/Library/Application Support/gitui/theme.ron"

echo "==> claude"
link "$REPO_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo ""
echo "Done. Existing files were backed up with a .bak suffix."
