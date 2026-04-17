#!/usr/bin/env bash
# Select a tmux session via fzf and kill it.
set -euo pipefail

session=$(tmux list-sessions -F "#{session_name}: #{session_windows} windows (#{session_attached} attached)" \
  | fzf --prompt="Kill session> " --height=40% --reverse) || exit 0

session_name="${session%%:*}"
tmux kill-session -t "$session_name" && echo "Killed: $session_name"
