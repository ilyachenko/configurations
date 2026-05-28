---
name: save
description: >
  Commit and push all uncommitted changes in the configurations repo.
  Generates a concise commit message from the conversation context.
---

# Save

1. **Update CLAUDE.md** if the conversation introduced new configs, files, or structure not yet documented there
2. **Update cheatsheet.md** if the conversation introduced new shortcuts, bindings, aliases, or commands not yet listed there
3. **Sync index.html with cheatsheet.md** — if `cheatsheet.md` was modified (or you just updated it in step 2), check whether the corresponding entries exist in `index.html`. If any are missing, add them in the matching section using the same key-badge format as surrounding entries. Keep `index.html` and `cheatsheet.md` in sync.
4. Run `git status` and `git diff` to see what changed
5. **Group changes by purpose** — if the diff contains changes that belong to different features or topics (e.g. tmux bindings vs a zsh script), commit them separately. Each commit should stage only the files relevant to that group. Only combine changes into one commit when they are genuinely part of the same feature.
6. For each commit: stage the relevant files, write a short message describing that group — based on conversation context, no mention of Claude or AI
7. After all commits, run `git push`
