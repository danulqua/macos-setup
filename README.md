# macOS Setup

An idempotent bootstrap for a new Mac: Homebrew packages and applications,
chezmoi-managed dotfiles, mise runtimes, Zsh configuration, and macOS
preferences.

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
5. Configure the full Xcode installation when available.
6. Install `/etc/zshenv` and configure Zsh to use `~/.config/zsh`.
7. Create the required XDG directories for Zsh.
8. Apply the dotfiles in `chezmoi/`.
9. Install the runtimes declared in the global mise configuration.
10. Apply the settings and keyboard shortcuts in `macos/`.

It is safe to run the command again. Existing repository changes are never
discarded: the update stops if it cannot be fast-forwarded.

### Options

To omit a stage, pass one or more flags after the command string:

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/danulqua/macos-setup/main/bootstrap.zsh)" -- --skip-macos
```

Available flags:

```text
--skip-packages   Do not run Homebrew Bundle
--skip-dotfiles   Do not apply chezmoi-managed user configuration
--skip-runtimes   Do not install tools declared in mise
--skip-macos      Do not apply macOS settings and shortcuts
-h, --help        Show help
```

For example:

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/danulqua/macos-setup/main/bootstrap.zsh)" -- --skip-packages --skip-macos
```

`--skip-dotfiles` only skips the chezmoi-managed user configuration. System
bootstrap configuration such as `/etc/zshenv` is still installed.

## Verify the installation

After installation, open a new terminal and run:

```bash
"$(git -C "$(chezmoi source-path)" rev-parse --show-toplevel)/scripts/check.zsh"
```

The check verifies that:

* core tools are available;
* chezmoi-managed files match the source state;
* local Git configuration exists;
* the local Zsh secrets file exists.

## Manual setup

Application sign-ins, GitHub authentication, and secrets intentionally remain
manual.

The bootstrap creates empty private files for machine-specific values:

```text
~/.gitconfig.local
~/.config/zsh/secrets.zsh
```

After installation:

1. Add your Git identity to `~/.gitconfig.local`.
2. Add secrets and machine-specific environment variables to
   `~/.config/zsh/secrets.zsh`.
3. Create and register your GitHub SSH key.
4. Sign in to installed applications.

## Zsh Configuration

Zsh follows the XDG directory layout instead of storing its configuration
directly in `$HOME`.

### System bootstrap

The repository contains:

```text
system/zshenv
```

During installation it is copied to:

```text
/etc/zshenv
```

It configures the base XDG config directory when necessary and tells Zsh to
look for its user startup files under `~/.config/zsh`:

```zsh
if [[ -z "$XDG_CONFIG_HOME" ]]
then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
```

System files that require root privileges, such as `/etc/zshenv`, are kept
under `system/` and installed by `scripts/install.zsh` rather than managed
directly by chezmoi.

### XDG directories

The installer creates the Zsh-specific directories used by the configuration:

```text
~/.config/zsh
~/.cache/zsh
~/.local/state/zsh
```

The managed `~/.config/zsh/.zshenv` defines the XDG base directories:

```zsh
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
```

This keeps application configuration, caches, data, and state out of the home
directory where supported.

### Managed Zsh files

The Zsh configuration is managed by chezmoi under:

```text
chezmoi/dot_config/zsh/
```

and applied to:

```text
~/.config/zsh/
```

The configuration includes:

```text
.zshenv
.zshrc
aliases.zsh
autosuggestions.zsh
completion.zsh
functions.zsh
fzf.zsh
highlighting.zsh
path.zsh
tools.zsh
```

Sensitive or machine-specific environment variables should be stored in:

```text
~/.config/zsh/secrets.zsh
```

This file is created automatically with private permissions and is not managed
by chezmoi.

## SSH Keys

### 1. Generate a key

```bash
ssh-keygen -t ed25519 -a 100 -f ~/.ssh/github.com -q -N "" -C "your_email@example.com"
```

Options:

* `-t ed25519` — use the modern Ed25519 key type.
* `-a 100` — use 100 KDF rounds when deriving a key from a passphrase.
* `-f ~/.ssh/github.com` — write the key to this path.
* `-q` — run quietly.
* `-N ""` — use an empty passphrase.
* `-C "your_email@example.com"` — add a comment identifying the key.

Because this command uses an empty passphrase, `-a 100` has no practical
effect unless a passphrase is added.

### 2. Create the SSH config

```bash
touch ~/.ssh/config
```

Add:

```sshconfig
IgnoreUnknown UseKeychain

Host github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github.com
```

### 3. Add GitHub to known hosts

```bash
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
```

### 4. Copy the public key

```bash
cat ~/.ssh/github.com.pub
```

Add the displayed public key to your GitHub account.

## Git Configuration

The global Git configuration is managed by chezmoi.

Machine-specific identity information is intentionally kept outside the
repository in:

```text
~/.gitconfig.local
```

Add your identity:

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

## Repository structure

```text
.
├── Brewfile
├── bootstrap.zsh
├── chezmoi/
│   └── dot_config/
│       ├── bat/
│       ├── ghostty/
│       ├── karabiner/
│       ├── mise/
│       └── zsh/
├── macos/
├── scripts/
│   ├── check.zsh
│   ├── install.zsh
│   └── lib.zsh
└── system/
    └── zshenv
```

The main responsibilities are:

* `bootstrap.zsh` — minimal entry point for a fresh Mac;
* `Brewfile` — Homebrew packages, casks, and Mac App Store applications;
* `chezmoi/` — user-level dotfiles;
* `system/` — system-level files requiring elevated privileges;
* `scripts/install.zsh` — installation orchestration;
* `scripts/check.zsh` — post-install verification;
* `macos/` — macOS defaults and keyboard shortcut configuration.
