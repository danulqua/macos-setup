# macOS Setup

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
- `-C "your_email@example.com"` - Provides a new comment. If not provided, your host machine name is used like `username@username-macbook-pro` . You can provide your work email here

### 2. Create config file:

```bash
touch ~/.ssh/config
```

### 3. Run command to configure specific host:

```bash
echo "IgnoreUnknown UseKeychain
Host github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github.com" >> ~/.ssh/config
```

Or manually put the following content in `~/.ssh/config`:

```bash
IgnoreUnknown UseKeychain
Host github.com
  User git
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github.com
```

### 4. Add host to known hosts

```bash
ssh-keyscan -H github.com >> ~/.ssh/known_hosts
```

### 5. Copy and use the public key:

```bash
cat ~/.ssh/github.com.pub
```

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