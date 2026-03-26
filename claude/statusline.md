# Claude Code Status Line

Add this to `~/.claude/settings.json` under the `statusLine` key:

```json
"statusLine": {
  "type": "command",
  "command": "input=$(cat); config_file=\"$HOME/.zsh_custom_paths.txt\"; current_dir=$(echo \"$input\" | jq -r '.workspace.current_dir'); model_name=$(echo \"$input\" | jq -r '.model.display_name'); output_style=$(echo \"$input\" | jq -r '.output_style.name'); remaining=$(echo \"$input\" | jq -r '.context_window.remaining_percentage // empty'); week_pct=$(echo \"$input\" | jq -r '.rate_limits.seven_day.used_percentage // empty'); custom_path=\"\"; if [[ -f \"$config_file\" ]]; then while IFS=':' read -r full_path short_name; do [[ -z \"$full_path\" || \"$full_path\" =~ ^[[:space:]]*# ]] && continue; full_path=${full_path/#\\~/$HOME}; if [[ \"$current_dir\" == \"$full_path\" || \"$current_dir\" == \"$full_path\"/* ]]; then if [[ \"$current_dir\" == \"$full_path\" ]]; then custom_path=\"$short_name\"; else relative_path=${current_dir#$full_path/}; custom_path=\"$short_name/$relative_path\"; fi; break; fi; done < \"$config_file\"; fi; if [[ -n \"$custom_path\" ]]; then dir_display=\"$custom_path\"; else dir_display=$(basename \"$current_dir\"); fi; ESC=$'\\033'; git_branch_color=\"\"; git_branch_text=\"\"; if git -C \"$current_dir\" rev-parse --no-flags --git-dir > /dev/null 2>&1; then branch=$(git -C \"$current_dir\" branch --show-current 2>/dev/null); if [[ -n \"$branch\" ]]; then if ! git -C \"$current_dir\" diff --quiet 2>/dev/null || ! git -C \"$current_dir\" diff --cached --quiet 2>/dev/null; then git_branch_color=\"${ESC}[33m\"; else git_branch_color=\"${ESC}[32m\"; fi; git_branch_text=\" ($branch)\"; fi; fi; ctx_part=\"\"; if [[ -n \"$remaining\" ]]; then ctx_part=\" ctx:${remaining}%\"; fi; week_part=\"\"; if [[ -n \"$week_pct\" ]]; then week_part=$(printf \" 7d:%.0f%%\" \"$week_pct\"); fi; printf \"${ESC}[36m%s${ESC}[0m%s%s${ESC}[0m ${ESC}[32m➜${ESC}[0m %s | %s%s%s\" \"$dir_display\" \"$git_branch_color\" \"$git_branch_text\" \"$model_name\" \"$output_style\" \"$ctx_part\" \"$week_part\""
}
```

## What it shows

`<dir> (branch) ➜ <model> | <output_style> ctx:<remaining>% 7d:<weekly_usage>%`

- Directory name shortened via `~/.zsh_custom_paths.txt` (same as zsh prompt)
- Git branch in green (clean) or yellow (dirty)
- Current model and output style
- Context window remaining %
- 7-day usage %
