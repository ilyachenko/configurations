# Report CWD to tmux via OSC 7 so pane_current_path stays accurate (fixes resurrect path loss)
if [[ -n "$TMUX" ]]; then
  _tmux_osc7_cwd() {
    printf '\033]7;file://%s%s\033\\' "$HOST" "$PWD"
  }
  precmd_functions+=(_tmux_osc7_cwd)
  chpwd_functions+=(_tmux_osc7_cwd)
fi
