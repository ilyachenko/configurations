# Handoff: git branch shows red instead of green in oh-my-zsh

## Context

On one Mac, the robbyrussell theme shows `git:(main)` in red even on a clean repo.
On another Mac with the same setup, it shows green. Needs diagnosis.

## How robbyrussell colors the branch

- **Green** = repo is clean
- **Yellow** = repo is dirty (uncommitted changes)

If you're seeing **red**, the terminal is likely rendering ANSI yellow as red (color palette mismatch), or the repo is actually dirty.

## Diagnosis — run these first

```bash
git status --porcelain
git config core.fileMode
```

If `git status --porcelain` outputs anything → the repo is dirty (even invisibly).

## Fixes depending on cause

**A) File permission changes make it dirty:**
```bash
git config core.fileMode false
```

**B) Untracked files make it dirty (and you don't care):**
Add to `~/.zshrc` before `source $ZSH/oh-my-zsh.sh`:
```zsh
DISABLE_UNTRACKED_FILES_DIRTY="true"
```

**C) Terminal color palette renders yellow as red:**
Align color scheme between machines (both should use Catppuccin Macchiato for Ghostty).

## Next step

Run the diagnosis, report results here (or to Claude on this machine), and we'll apply the right fix and add it to the shared config.
