# configurations

Shared config files for tmux and ghostty, synced across laptops via git.

## Structure

```
tmux/
  .tmux.conf
ghostty/
  config
```

## Setup

Clone the repo, then create symlinks manually:

```bash
ln -s ~/dev/configurations/tmux/.tmux.conf ~/.tmux.conf
ln -s ~/dev/configurations/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

Back up any existing files before linking.
