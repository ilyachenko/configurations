---
name: sync
description: >
  Pull latest changes from the configurations repo, analyse what changed,
  and apply each change (source zsh, reload tmux, etc.).
---

# Sync

1. Run `git -C ~/dev/configurations pull` and capture the output
2. If already up to date, say so and stop
3. Run `git -C ~/dev/configurations diff HEAD@{1} HEAD --name-only` to see which files changed
4. For each changed file, apply it:
   - `zsh/common.zsh` → run `source ~/dev/configurations/zsh/common.zsh`
   - `tmux/.tmux.conf` → run `tmux source-file ~/.tmux.conf` (skip silently if tmux is not running)
   - `ghostty/config` → note: requires Ghostty restart, tell the user
   - `wezterm/wezterm.lua` → note: reloads automatically, tell the user
   - `claude/statusline-command.sh` or `claude/statusline.md` → note: active on next Claude session
   - Any other file → mention it was pulled but requires manual action if needed
5. Show a short summary: what was pulled and what was applied vs. what needs manual action
