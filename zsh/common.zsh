# Override robbyrussell theme: green branch when clean, yellow ✗ when dirty
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

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
