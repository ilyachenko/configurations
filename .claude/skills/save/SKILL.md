---
name: save
description: >
  Commit and push all uncommitted changes in the configurations repo.
  Generates a concise commit message from the conversation context.
---

# Save

1. **Update CLAUDE.md** if the conversation introduced new configs, files, or structure not yet documented there
2. **Update cheatsheet.md** if the conversation introduced new shortcuts, bindings, aliases, or commands not yet listed there
3. Run `git status` and `git diff` to see what changed
4. Stage all changed tracked files with `git add -u`, plus any relevant untracked files
5. Write a short commit message describing what changed — based on conversation context, no mention of Claude or AI
6. Commit and run `git push`
