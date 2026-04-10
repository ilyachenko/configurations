---
name: tmux-statusline
description: >
  Edit the tmux status line. Use when the user wants to add, remove, or change
  items in the tmux status bar (CPU, RAM, time, timezone, etc.).
---

# Tmux Status Line Editor

The tmux config is at `~/.tmux.conf`. After every edit, reload with:

```
tmux source-file ~/.tmux.conf
```

Always run this after each change so the user sees results immediately.

## Current status-right location

Line 19 of `~/.tmux.conf`. The relevant settings:

```
set -g status-interval 10
set -g status-right "..."
```

## macOS-specific gotchas learned the hard way

### 1. Escape `%` inside `#()` as `%%`
Tmux runs strftime on the entire `status-right` string, **including inside `#()`**.
Any `%` in a shell command gets strftime-expanded before the command runs.

- `ps -A -o %cpu` → broken (`%c` = locale datetime). Use `pcpu` instead.
- `awk '{printf "%.0f", x}'` → use `\"%%.0f\"` in config so tmux reduces `%%` → `%` before awk sees it.
- `TZ=Europe/Warsaw date +%H:%M` → use `+%%H:%%M` in config.

### 2. macOS BSD awk has no ternary operator
`s > 100 ? 100 : s` → syntax error. Use `if/else` or avoid it.

### 3. Use `print int(x)` to avoid `%` in format strings
Instead of `printf "%.0f", x` (requires `%%` escaping), use `print int(x)` — no `%` at all.

## Working recipes

### CPU (macOS)
```
#(top -l 1 | awk '/CPU usage/{idle=substr($7,1,length($7)-1); print int(100-idle)}')%%
```
- `top -l 1` samples CPU once (~1s). Fine for 10s refresh.
- `$7` is the idle% field in `top` output: `CPU usage: X% user, Y% system, Z% idle`
- `print int(100-idle)` = used CPU%, no `%` format string needed.

### RAM % (macOS)
```
#(vm_stat | awk '/page size of/ {size=$8} /Pages active/ {active=$3+0} /Pages wired down/ {wired=$4+0} /Pages occupied by compressor/ {comp=$5+0} END {cmd=\"sysctl -n hw.memsize\"; cmd | getline total; close(cmd); print int((active+wired+comp)*size/total*100)}')%%
```
- `vm_stat` gives page counts; `sysctl -n hw.memsize` gives total bytes.
- Note: `cmd=\"sysctl -n hw.memsize\"` — inner double quotes must be escaped with `\"` in tmux config.

### Timezone clock
```
PT: #(TZ=Europe/Lisbon date +%%H:%%M)
PL: #(TZ=Europe/Warsaw date +%%H:%%M)
```

### Full current status-right
```
set -g status-right "CPU: #(top -l 1 | awk '/CPU usage/{idle=substr($7,1,length($7)-1); print int(100-idle)}')%% | RAM: #(vm_stat | awk '/page size of/ {size=$8} /Pages active/ {active=$3+0} /Pages wired down/ {wired=$4+0} /Pages occupied by compressor/ {comp=$5+0} END {cmd=\"sysctl -n hw.memsize\"; cmd | getline total; close(cmd); print int((active+wired+comp)*size/total*100)}')%% | PT: #(TZ=Europe/Lisbon date +%%H:%%M) | PL: #(TZ=Europe/Warsaw date +%%H:%%M)"
```

## What didn't work

- **Keyboard layout via `defaults read` plist**: unreliable in tmux shell context — avoid.
- **`ps -A -o %cpu`**: `%c` gets strftime-expanded. Use `pcpu`.
- **`~` in paths inside `#()`**: can fail in tmux's shell. Use full path or `$HOME` if needed.
