# macOS Setup

An idempotent bootstrap for a new Mac: Homebrew packages and applications,
chezmoi-managed dotfiles, mise runtimes, and macOS preferences.

## Before installation

Sign in to the Mac App Store. The `Brewfile` uses `mas` to install App Store
applications, including Xcode, and that stage will fail without an active
App Store account.

## Install

Run this command on a new Mac:

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/danulqua/macos-setup/main/bootstrap.zsh)"
```

The bootstrap will:

1. Install Xcode Command Line Tools when needed.
2. Install Homebrew and chezmoi.
3. Clone or fast-forward this repository in chezmoi's source directory.
4. Install everything declared in `Brewfile`.
5. Apply the dotfiles in `chezmoi/`.
6. Install the runtimes declared in the global mise configuration.
7. Apply the settings and keyboard shortcuts in `macos/`.

It is safe to run the command again. Existing repository changes are never
discarded: the update stops if it cannot be fast-forwarded.

To omit a stage, pass one or more flags after the command string:

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/danulqua/macos-setup/main/bootstrap.zsh)" -- --skip-macos
```

Available flags are `--skip-packages`, `--skip-dotfiles`, `--skip-runtimes`, and
`--skip-macos`.

After installation, open a new terminal and verify the result:

```bash
"$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel)/scripts/check.zsh"
```

## Manual setup

Application sign-ins, GitHub authentication, and secrets intentionally remain
manual. The bootstrap creates empty, private files for the local values:

- `~/.gitconfig.local`
- `~/.config/zsh/secrets.zsh`

## SSH Keys

### 1. Run command:

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/github.com -q -N "" -C "your_email@example.com"
```

- `-t ed25519` - key type, **ed25519** is a modern standard
- `-a 100` - specifies **the number of KDF (Key Derivation Function) rounds**.
    - Used when protecting the private key with a passphrase
    - Higher number = slower brute-force attacks
    - Default is usually **16**, so **100 is stronger**

    Since this command sets an **empty passphrase**, this option effectively has **no practical effect** here.

- `-f ~/.ssh/github.com` - specifies the output file
- `-q` - run `ssh-keygen` command silently
- `-N ''` - new passphrase, empty in this case
- `-C "your_email@example.com"` - provides a comment. If omitted, the host machine name is used, such as `username@username-macbook-pro`.

### 2. Create the config file:

```bash
touch ~/.ssh/config
```

### 3. Configure the GitHub host:

```bash
echo "IgnoreUnknown UseKeychain
Host github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github.com" >> ~/.ssh/config
```

Or manually add the following content to `~/.ssh/config`:

```sshconfig
IgnoreUnknown UseKeychain

Host github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github.com
```

### 4. Add GitHub to known hosts:

```bash
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
```

### 5. Copy the public key:

```bash
cat ~/.ssh/github.com.pub
```

Add the displayed public key to your GitHub account.

## ZSH Shell Configuration

Store sensitive environment variables in:

```text
~/.config/zsh/secrets.zsh
```

This file is loaded automatically by the managed `.zshrc`.

## Git Configuration

Add your identity to `~/.gitconfig.local`:

```gitconfig
[user]
  email = johndoe@gmail.com
  name = John Doe
```

You can optionally use a different identity for repositories in a particular
directory:

```gitconfig
[includeIf "gitdir:~/dev/work/"]
  path = ~/dev/work/.gitconfig-work
```

Example `~/dev/work/.gitconfig-work`:

```gitconfig
[user]
  email = johndoework@gmail.com
  name = John Doe
```