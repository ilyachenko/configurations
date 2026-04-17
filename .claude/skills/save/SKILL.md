---
name: save
description: >
  Commit and push all uncommitted changes in the configurations repo.
  Generates a concise commit message from the conversation context.
---

# Save

Commit and push all uncommitted changes:

1. Run `git status` and `git diff` to see what changed
2. Stage all changed tracked files with `git add -u`, plus any relevant untracked files
3. Write a short commit message describing what changed — based on conversation context, no mention of Claude or AI
4. Commit and run `git push`
