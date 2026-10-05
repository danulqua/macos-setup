# OpenAI profile switcher

The OpenAI profile switcher keeps personal and work ChatGPT/Codex state
separate while using the same macOS application.

## Commands

```zsh
openai-personal  # activate personal state and remove work environment variables
openai-work      # activate work state and load local work environment variables
openai-status    # show the active profile without displaying credentials
```

Run profile changes from a normal macOS terminal, not from a terminal embedded
in ChatGPT/Codex. Switching closes and reopens the ChatGPT application.

## Managed by chezmoi

- `~/.local/bin/openai-env` — profile-switching program.
- `~/.config/zsh/openai.zsh` — shell functions and environment loader.
- `~/.config/openai-environments/personal.zsh` — optional personal-only
  environment variables.
- The `openai` entry in `~/.config/zsh/.zshrc`.

If no local profile marker exists, a newly bootstrapped Mac defaults to
`personal`.

## Local-only files

The following files contain credentials or mutable application state and must
not be added to the dotfiles repository:

- `~/.config/openai-environments/work.zsh`
- `~/.config/openai-environments/current`
- `~/.local/share/openai-environments/profiles/`
- `~/.local/state/openai-environments/switch.log`
- `~/.codex/`
- `~/Library/Application Support/Codex/`
- `~/Library/HTTPStorages/com.openai.codex*`

## Work setup on a new Mac

After applying the dotfiles, create
`~/.config/openai-environments/work.zsh` locally or restore it from an approved
secrets manager:

```zsh
export LUMI_BASE_URL="<corporate LUMI base URL>"
export LUMI_AUTH_TOKEN="<corporate authentication token>"
export LUMI_API_KEY="<corporate API key>"
```

Protect it and activate the work profile:

```zsh
chmod 600 ~/.config/openai-environments/work.zsh
openai-work
```

The work profile starts empty on a new Mac. Complete the corporate Mono/LUMI
Codex setup and sign into the work ChatGPT account while that profile is active.
Corporate setup may additionally create `~/.codex/config.toml` and
`~/.codex/lumi-env`; these stay inside the local work profile and must not be
managed by chezmoi.

Then return to the isolated personal profile with:

```zsh
openai-personal
```

The switcher moves the inactive profile into
`~/.local/share/openai-environments/profiles/`. It does not delete either
profile.
