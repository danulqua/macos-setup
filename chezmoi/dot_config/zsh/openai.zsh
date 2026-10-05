# Portable OpenAI/ChatGPT/Codex profile integration.
# Credentials and mutable profile state intentionally remain outside chezmoi.

_openai_profile_apply_shell() {
  unset LUMI_API_KEY LUMI_AUTH_TOKEN LUMI_BASE_URL
  unset OPENAI_API_KEY OPENAI_BASE_URL OPENAI_ORGANIZATION OPENAI_PROJECT

  local profile_file="${XDG_CONFIG_HOME:-$HOME/.config}/openai-environments/current"
  local profile="personal"
  [[ -r "$profile_file" ]] && profile="$(<"$profile_file")"

  if [[ "$profile" == "work" ]]; then
    local work_env="${XDG_CONFIG_HOME:-$HOME/.config}/openai-environments/work.zsh"
    [[ -r "$work_env" ]] && source "$work_env"
  else
    local personal_env="${XDG_CONFIG_HOME:-$HOME/.config}/openai-environments/personal.zsh"
    [[ -r "$personal_env" ]] && source "$personal_env"
  fi
}

openai-work() {
  command openai-env work "$@" && _openai_profile_apply_shell
}

openai-personal() {
  command openai-env personal "$@" && _openai_profile_apply_shell
}

openai-status() {
  command openai-env status "$@"
}

_openai_profile_apply_shell
