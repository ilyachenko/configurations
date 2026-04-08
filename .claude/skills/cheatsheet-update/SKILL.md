---
name: cheatsheet-update
description: >
  Update /Users/idiachenko/dev/configurations/cheatsheet.md. Without arguments,
  syncs it to the current tmux, WezTerm, and Ghostty configs. With an argument,
  adds or updates the cheatsheet with the provided content (may be unrelated to configs).
---

# Cheatsheet Update

## With an argument

The user provided specific content or instructions. Add or update the cheatsheet
at `/Users/idiachenko/dev/configurations/cheatsheet.md` accordingly.
Keep the existing format and style.

## Without an argument

Sync the cheatsheet to the current state of the configs:

1. Read the current cheatsheet at `/Users/idiachenko/dev/configurations/cheatsheet.md`
2. Read the tmux config at `/Users/idiachenko/dev/configurations/tmux/.tmux.conf`
3. Read the WezTerm config at `/Users/idiachenko/dev/configurations/wezterm/wezterm.lua`
4. Read the Ghostty config at `/Users/idiachenko/dev/configurations/ghostty/config`
5. Update the cheatsheet to match the actual keybindings in all three configs — add missing shortcuts, remove outdated ones, keep the existing format and style.
