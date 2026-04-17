#!/bin/zsh
input=$(cat)
config_file="$HOME/.zsh_custom_paths.txt"
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

fmt_reset() {
  local diff=$(( $1 - $(date +%s) ))
  if [[ $diff -le 0 ]]; then echo "now"
  elif [[ $diff -lt 3600 ]]; then echo "$((diff/60))m"
  elif [[ $diff -lt 86400 ]]; then printf "%dh%02dm" $((diff/3600)) $(( (diff%3600)/60 ))
  else printf "%dd%dh" $((diff/86400)) $(( (diff%86400)/3600 ))
  fi
}

custom_path=""
if [[ -f "$config_file" ]]; then
  while IFS=':' read -r full_path short_name; do
    [[ -z "$full_path" || "$full_path" =~ ^[[:space:]]*# ]] && continue
    full_path=${full_path/#\~/$HOME}
    if [[ "$current_dir" == "$full_path" || "$current_dir" == "$full_path"/* ]]; then
      if [[ "$current_dir" == "$full_path" ]]; then
        custom_path="$short_name"
      else
        relative_path=${current_dir#$full_path/}
        custom_path="$short_name/$relative_path"
      fi
      break
    fi
  done < "$config_file"
fi

if [[ -n "$custom_path" ]]; then
  dir_display="$custom_path"
else
  dir_display=$(basename "$current_dir")
fi

ESC=$'\033'
profile_label=""
if [[ "$CLAUDE_CONFIG_DIR" == *cc-personal* ]]; then
  profile_label="${ESC}[48;5;208m${ESC}[30m P ${ESC}[0m "
elif [[ "$CLAUDE_CONFIG_DIR" == *cc-intellias* ]]; then
  profile_label="${ESC}[48;5;34m${ESC}[30m I ${ESC}[0m "
fi

git_branch_color=""
git_branch_text=""
if git -C "$current_dir" rev-parse --no-flags --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    if ! git -C "$current_dir" diff --quiet 2>/dev/null || ! git -C "$current_dir" diff --cached --quiet 2>/dev/null; then
      git_branch_color="${ESC}[33m"
    else
      git_branch_color="${ESC}[32m"
    fi
    git_branch_text=" ($branch)"
  fi
fi

ctx_part=""
if [[ -n "$remaining" ]]; then
  ctx_part=" ${remaining}%"
fi

usage_color() {
  local pct=$(printf "%.0f" "$1")
  if [[ $pct -ge 80 ]]; then echo "${ESC}[31m"
  elif [[ $pct -ge 50 ]]; then echo "${ESC}[33m"
  else echo "${ESC}[32m"
  fi
}

DIM="${ESC}[2m"
RESET="${ESC}[0m"

five_hour_part=""
if [[ -n "$five_hour_pct" ]]; then
  local pct=$(printf "%.0f" "$five_hour_pct")
  local color=$(usage_color "$five_hour_pct")
  if [[ -n "$five_hour_reset" ]]; then
    five_hour_part=" ${DIM}$(fmt_reset "$five_hour_reset"):${RESET}${color}${pct}%${RESET}"
  else
    five_hour_part=" ${color}5h:${pct}%${RESET}"
  fi
fi

week_part=""
if [[ -n "$week_pct" ]]; then
  local pct=$(printf "%.0f" "$week_pct")
  local color=$(usage_color "$week_pct")
  if [[ -n "$week_reset" ]]; then
    week_part=" ${DIM}$(fmt_reset "$week_reset"):${RESET}${color}${pct}%${RESET}"
  else
    week_part=" ${color}7d:${pct}%${RESET}"
  fi
fi

style_part=""
[[ "$output_style" != "default" && -n "$output_style" ]] && style_part="[$output_style]"

printf "%s${ESC}[36m%s${ESC}[0m%s%s${ESC}[0m ${ESC}[32m➜${ESC}[0m %s%s⁞%s%s%s" \
  "$profile_label" "$dir_display" "$git_branch_color" "$git_branch_text" \
  "$model_name" "$style_part" "$ctx_part" "$five_hour_part" "$week_part"
