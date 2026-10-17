# Repository guidance

## Purpose and layout

This repository bootstraps a personal macOS environment. Keep setup repeatable,
idempotent, and understandable when reviewed before running on a new Mac.

- `bootstrap.zsh`: minimal fresh-machine entry point; installs prerequisites,
  updates the checkout, and delegates to the installer.
- `scripts/install.zsh`: installation stages and skip-flag handling.
- `scripts/lib.zsh`: shared installer and verification helpers.
- `scripts/check.zsh`: post-install checks; not a general test suite.
- `Brewfile`: curated Homebrew formulae, casks, Mac App Store apps, and VS Code
  extensions.
- `chezmoi/`: source state for user dotfiles. `.chezmoiroot` points here.
- `system/`: system configuration installed explicitly with elevated privileges.
- `macos/`: personal macOS preferences and keyboard shortcuts.
- `README.md`: installation instructions, behavior, and manual setup steps.

## macOS preferences and shortcuts

- In `macos/`, put a descriptive comment immediately above every command,
  including each `defaults` invocation and each `set_hotkey` call. A comment for
  a group does not replace comments for its individual commands. Treat a
  multiline command as one command.
- Explain the intended behavior, including the meaning of non-obvious numeric
  values, shortcut IDs, or modifier masks. Keep comments accurate when changing
  a value.
- Keep commands grouped into clearly named comment sections, following the
  existing separator style in `macos/macos.zsh`. Add a section when a new category
  is needed rather than appending unrelated commands.
- Keep general preferences in `macos/macos.zsh` and symbolic keyboard shortcuts
  in `macos/macos_hotkeys.zsh`.
- Preserve explicit preference types (`-bool`, `-int`, `-float`, `-string`, etc.)
  and version guards for settings restricted to particular macOS releases.
- Preserve the hotkey script's export/edit/import workflow, temporary-file
  cleanup, and shortcuts outside the IDs it manages.
- Keep process restarts at the end of the preferences script. Document settings
  that need logout or restart; do not claim syntax checks verify their effect.

## Brewfile conventions

- Every active `brew` formula and `cask` entry must have its own concise
  description comment immediately above it. Inline comments or section headings
  do not satisfy this rule.
- Keep all entries grouped by purpose under named comment sections, including
  `mas` and `vscode` entries. Follow the existing `# ===...` major headings and
  `# ---...` subsection style and spacing.
- Keep formulae, applications, and VS Code extensions in their existing major
  sections. Place new entries in the appropriate subsection; follow alphabetical
  order within formula and cask subsections.
- Use the existing double-quoted declaration style and retain App Store IDs.
  Avoid duplicate entries and unrelated package additions or removals.
- Treat the Brewfile as curated source. `brew bundle dump` and the `brew-dump`
  shell helper capture the current machine and can erase comments and sections;
  do not use their output as a replacement without restoring the layout and
  reviewing every package change.
- Keep language runtimes in `chezmoi/dot_config/mise/config.toml` rather than
  adding competing Homebrew runtime installations unless explicitly requested.

## Dotfiles and local configuration

- Edit source files under `chezmoi/`, not the corresponding installed home files.
  Preserve chezmoi naming and permission attributes such as `dot_` and `private_`.
- Keep system files outside chezmoi's user source state; install them through
  `scripts/install.zsh`.
- Preserve the XDG layout and `ZDOTDIR` startup chain from `system/zshenv` to
  `chezmoi/dot_config/zsh/dot_zshenv` and `dot_zshrc`.
- Keep Zsh configuration modular and preserve dependency-sensitive loading order.
  Guard optional tool integrations so a missing tool does not break startup.
- Keep credentials, SSH private keys, tokens, and machine-specific identity out
  of tracked files. Git identity belongs in `~/.gitconfig.local`; shell secrets
  belong in `~/.config/zsh/secrets.zsh`. Preserve their contents and private
  permissions when changing installation logic.

## Script maintenance

- Use Zsh syntax and the existing two-space indentation. Quote paths and variable
  expansions where appropriate, and resolve repository paths relative to scripts
  rather than assuming the current working directory.
- Follow existing strict-mode conventions for executable setup scripts; do not
  impose installer error handling on interactive shell configuration.
- Reuse `scripts/lib.zsh` helpers where appropriate. Keep the downloaded
  `bootstrap.zsh` usable before repository helpers and packages are available.
- Preserve Apple Silicon and Intel Homebrew discovery, macOS platform checks,
  and fast-forward-only repository updates. Never discard local changes to make
  bootstrap succeed.
- Preserve installation order and the meaning of skip flags. In particular,
  `--skip-dotfiles` does not skip system bootstrap configuration.
- Keep changes focused. Update `README.md` when installation behavior, flags,
  managed preferences, dependencies, or manual steps change.

## Validation

- Review `git diff` and run `git diff --check` before finishing.
- For changed Zsh files, run `zsh -n path/to/file`, including startup files without
  a `.zsh` extension and `system/zshenv` when applicable.
- For Brewfile edits, run `ruby -c Brewfile` if Ruby is available; this checks
  syntax, not package availability or Homebrew Bundle behavior.
- Validate changed JSON or TOML with an available parser. Prefer focused checks;
  there is no repository-wide automated test suite configured.
- Use `chezmoi diff` to review proposed dotfile changes when relevant, taking care
  not to expose private local values in output shared with others.
- Run `scripts/check.zsh` for post-install verification on a configured Mac. It
  checks core tools and managed-file drift, warns about empty local configuration,
  and does not verify macOS defaults or shortcuts.
- Do not run bootstrap, the installer, `brew bundle`, `chezmoi apply`, or the macOS
  scripts merely to validate an edit: they change the host. Run them when applying
  those changes is part of the user's request. Report what was actually checked
  and any validation that could not be performed.
