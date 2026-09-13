# macOS Setup

## ZSH Shell Configuration

All sensitive variables should be stored in `~/.config/zsh/secrets.zsh` — this file is loaded in the current setup so everything works as expected.

## Git Configuration

Create `.gitconfig.local` file for sensitive data:

```
[user]
  email = johndoe@gmail.com
  name = John Doe
```

Optionally: add path to other `.gitconfig` files, for example, for cases when you need to work from other email or just have different settings:

```
[includeIf "gitdir:~/dev/work/"]
  path = ~/dev/work/.gitconfig-work
```

`~/dev/work/.gitconfig-work`:
```
[user]
  email = johndoework@gmail.com
```