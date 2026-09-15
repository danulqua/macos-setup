#!/bin/zsh

emulate -LR zsh
set -u

readonly SCRIPT_DIR="${0:A:h}"
source "${SCRIPT_DIR}/lib.zsh"

failures=0

check_command() {
  local command_name="$1"

  if command -v "${command_name}" >/dev/null 2>&1; then
    success "${command_name} is available"
  else
    warning "${command_name} is not available"
    (( failures += 1 ))
  fi
}

heading "Checking core tools"
for command_name in brew chezmoi git mise node pnpm java mvn; do
  check_command "${command_name}"
done

heading "Checking managed files"
if chezmoi verify >/dev/null 2>&1; then
  success "Managed dotfiles match the source state"
else
  warning "Managed dotfiles differ; inspect them with: chezmoi diff"
  (( failures += 1 ))
fi

heading "Checking local configuration"
for file_path in "${HOME}/.gitconfig.local" "${HOME}/.config/zsh/secrets.zsh"; do
  if [[ -s "${file_path}" ]]; then
    success "${file_path} is configured"
  else
    warning "${file_path} is empty"
  fi
done

if (( failures > 0 )); then
  print -u2 -- "\n${failures} check(s) failed."
  exit 1
fi

print -- "\n${GREEN}Everything looks good.${RESET}"
