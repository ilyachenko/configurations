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

---

## 🧩 Pane Management

### Split Panes
- Vertical split → `Ctrl + b` then `%`
- Horizontal split → `Ctrl + b` then `"`

### Navigate Panes
- Switch panes → `Ctrl + b` then `← ↑ ↓ →`

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

---

## 💻 VS Code Integration
- Open VS Code → `Ctrl + b` then `Ctrl + c`

---

## ✏️ Terminal Editing (Shell)

- Delete after cursor → `Ctrl + K`
- Delete whole line → `Ctrl + U`

---

## ⚡ Notes
- `Ctrl + b` = tmux prefix
- Works together with WezTerm bindings