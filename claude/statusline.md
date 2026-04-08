# Claude Code Status Line

## What it shows

`[P] <dir> (branch) ➜ <model> | <output_style> ctx:<remaining>% 7d:<weekly_usage>%`

- **Profile badge**: colored label per profile — detected via `$CLAUDE_CONFIG_DIR`
- **Directory**: basename, shortened via `~/.zsh_custom_paths.txt` (format: `full_path:short_name`, one per line)
- **Git branch**: green (clean) or yellow (dirty); omitted outside git repos
- **Model** and **output style**
- **Context window** remaining %
- **7-day usage** %

---

## Profile mapping

Profile labels and colors are defined in `~/.claude/statusline-profiles.conf` (local, not committed).
See `claude/statusline-profiles.conf.example` for the format. When setting up on a new machine,
ask Claude to install the statusline — it will read the profiles conf and hardcode the correct
values into the script/settings.

---

## Setup

Two options: script file (recommended, easier to edit) or inline JSON command.

The profile badge block in both options looks like this — **ask Claude to fill in the correct
values from `~/.claude/statusline-profiles.conf`** for your machine:

```bash
ESC=$'\033'
profile_label=""
if [[ "$CLAUDE_CONFIG_DIR" == *cc-personal* ]]; then
  profile_label="${ESC}[48;5;208m${ESC}[30m P ${ESC}[0m "
elif [[ "$CLAUDE_CONFIG_DIR" == *cc-work* ]]; then
  profile_label="${ESC}[48;5;34m${ESC}[30m W ${ESC}[0m "
fi
```

### Option A — Script file (recommended)

**1. Create the script** (Claude fills in the profile block from your profiles conf):

```bash
mkdir -p ~/.cc-personal
cat > ~/.cc-personal/statusline-command.sh << 'EOF'
#!/bin/zsh
input=$(cat)
config_file="$HOME/.zsh_custom_paths.txt"
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

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
# --- profile badge: filled in from ~/.claude/statusline-profiles.conf ---
if [[ "$CLAUDE_CONFIG_DIR" == *cc-personal* ]]; then
  profile_label="${ESC}[48;5;208m${ESC}[30m P ${ESC}[0m "
elif [[ "$CLAUDE_CONFIG_DIR" == *cc-work* ]]; then
  profile_label="${ESC}[48;5;34m${ESC}[30m W ${ESC}[0m "
fi
# -----------------------------------------------------------------------

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
[[ -n "$remaining" ]] && ctx_part=" ctx:${remaining}%"

week_part=""
[[ -n "$week_pct" ]] && week_part=$(printf " 7d:%.0f%%" "$week_pct")

printf "%s${ESC}[36m%s${ESC}[0m%s%s${ESC}[0m ${ESC}[32m➜${ESC}[0m %s | %s%s%s" \
  "$profile_label" "$dir_display" "$git_branch_color" "$git_branch_text" \
  "$model_name" "$output_style" "$ctx_part" "$week_part"
EOF
chmod +x ~/.cc-personal/statusline-command.sh
```

**Gotcha:** the script must be executable (`chmod +x`). Without it, the statusline silently disappears.

**2. Point each profile's `settings.json` to the script:**

```json
{
  "statusLine": {
    "type": "command",
    "command": "/Users/YOUR_USERNAME/.cc-personal/statusline-command.sh"
  }
}
```

---

### Option B — Inline JSON command

Add directly to each profile's `settings.json`. Claude generates this from the script above, minified. Ask Claude to do it — it will read `~/.claude/statusline-profiles.conf` and inline the correct profile badge values.

---

## Dependencies

- `jq` — JSON parsing (`brew install jq`)
- `git` — branch detection
- `~/.zsh_custom_paths.txt` — optional, for directory shortening
- `~/.claude/statusline-profiles.conf` — profile label/color mapping (see example)
