# 🧠 TMUX / WEZTERM CHEATSHEET

---

## 📋 Copying & Selection

### Tmux Copy Mode (vi mode)
- Enter copy mode → `Ctrl + b` then `[`
- Navigate → `h / j / k / l`
- Start selection → `v`
- Copy (stay in mode) → `y`
- Copy + exit → `Enter`
- Exit copy mode → `q` or `Escape`

### WezTerm Copying
- Copy mode → `Ctrl + Shift + X`
- Quick select mode → `Ctrl + Shift + Space`
- Copy + clear selection → `Ctrl + Shift + C`

### WezTerm Line Navigation
- Beginning of line → `Cmd + ←`
- End of line → `Cmd + →`
- Jump word left → `Option + ←`
- Jump word right → `Option + →`

---

## 🔗 Opening Links
- Open link → `Ctrl + Click` (WezTerm, works inside tmux)
- Extract URLs (tmux + fzf) → `Prefix + u`

---

## 🪟 Session Management

### Create Sessions
- Create & enter → `tmux new-session`
- Create in background → `tmux new-session -d -s java_questions`

### Attach / Switch
- Attach to session → `tmux attach`

### Exit / Close
- Close session → `exit`
- Kill session by name → `tmux kill-session -t session_name`

---

## 🧩 Pane Management

### Split Panes
- Vertical split → `Ctrl + b` then `%`
- Horizontal split → `Ctrl + b` then `"`

### Navigate Panes
- Switch panes → `Ctrl + b` then `← ↑ ↓ →`
- Switch panes (fast, no prefix) → `Alt + h / j / k / l`

### Resize Panes
- Resize → `Ctrl + b` then `H / J / K / L`

### Close Pane
- `exit` or `Ctrl + d`

---

## 🗂 Window Management

### Create / List
- New window → `Ctrl + b` then `c`
- List windows → `Ctrl + b` then `w`

### Navigate
- Next → `Ctrl + b` then `n`
- Previous → `Ctrl + b` then `p`
- Go to window → `Ctrl + b` then `0–9`

### Close
- Close window → `Ctrl + b` then `&`

---

## 💻 VS Code Integration
- Open VS Code → `Ctrl + b` then `Ctrl + c`

---

## 🤖 Claude Code Integration
- Resume last Claude session → `Ctrl + b` then `Ctrl + g`

---

## ✏️ Terminal Editing (Shell)

- Delete after cursor → `Ctrl + K`
- Delete whole line → `Ctrl + U`
- Open current command in `$EDITOR` → `Ctrl + X, E`

---

## ⚡ Notes
- `Ctrl + b` = tmux prefix
- Works together with WezTerm bindings