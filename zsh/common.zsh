# Override robbyrussell git_prompt_info: green branch when clean, yellow branch + ✗ when dirty
function git_prompt_info() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    echo "%{$fg_bold[blue]%}git:(%{$fg[yellow]%}${branch}%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%} "
  else
    echo "%{$fg_bold[blue]%}git:(%{$fg[green]%}${branch}%{$fg[blue]%})%{$reset_color%} "
  fi
}

# Prevent accidentally launching Claude without a profile
function claude() { echo "Use a profile alias (e.g. cc-personal) instead of claude directly."; }

# Report CWD to tmux via OSC 7 so pane_current_path stays accurate (fixes resurrect path loss)
if [[ -n "$TMUX" ]]; then
  _tmux_osc7_cwd() {
    printf '\033]7;file://%s%s\033\\' "$HOST" "$PWD"
  }
  precmd_functions+=(_tmux_osc7_cwd)
  chpwd_functions+=(_tmux_osc7_cwd)
fi
