#!/bin/zsh

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  print -u2 "This script supports macOS only."
  exit 1
fi

readonly PLIST_BUDDY="/usr/libexec/PlistBuddy"
readonly HOTKEY_DOMAIN="com.apple.symbolichotkeys"
readonly TEMP_DIR="$(mktemp -d -t macos-hotkeys)"
readonly TEMP_PLIST="${TEMP_DIR}/com.apple.symbolichotkeys.plist"
trap 'rm -rf "${TEMP_DIR}"' EXIT

# Work on an exported copy, then import once. This avoids repeatedly editing the
# live plist behind cfprefsd and preserves shortcuts not managed by this script.
defaults export "${HOTKEY_DOMAIN}" "${TEMP_PLIST}" >/dev/null

set_hotkey() {
  local id="$1"
  local enabled="$2"
  local character_code="$3"
  local key_code="$4"
  local modifiers="$5"

  "${PLIST_BUDDY}" -c "Delete :AppleSymbolicHotKeys:${id}" "${TEMP_PLIST}" \
    2>/dev/null || true
  "${PLIST_BUDDY}" \
    -c "Add :AppleSymbolicHotKeys:${id} dict" \
    -c "Add :AppleSymbolicHotKeys:${id}:enabled bool ${enabled}" \
    -c "Add :AppleSymbolicHotKeys:${id}:value dict" \
    -c "Add :AppleSymbolicHotKeys:${id}:value:parameters array" \
    -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${character_code}" \
    -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${key_code}" \
    -c "Add :AppleSymbolicHotKeys:${id}:value:parameters: integer ${modifiers}" \
    -c "Add :AppleSymbolicHotKeys:${id}:type string standard" \
    "${TEMP_PLIST}"
}

# Disable Launchpad/Apps, Notification Center, and left/right Space switching.
set_hotkey 160 false 65535 65535 0
set_hotkey 163 false 65535 65535 0
set_hotkey 32 false 65535 126 8650752
set_hotkey 33 false 65535 125 8650752

# Switch to Desktop 1-10 with Control+Option+Shift+Command+[1-0].
typeset -a desktop_char_codes=(49 50 51 52 53 54 55 56 57 48)
typeset -a desktop_key_codes=(18 19 20 21 23 22 26 28 25 29)

for index in {1..10}; do
  set_hotkey \
    "$((117 + index))" \
    true \
    "${desktop_char_codes[index]}" \
    "${desktop_key_codes[index]}" \
    1966080
done

# Disable input-source shortcuts; Caps Lock handles input switching.
set_hotkey 60 false 32 49 262144
set_hotkey 61 false 32 49 786432

# Disable Spotlight shortcuts.
set_hotkey 64 false 32 49 1048576
set_hotkey 65 false 65535 49 1572864

# Disable screenshot and Screenshot app shortcuts.
set_hotkey 28 false 51 20 1179648
set_hotkey 29 false 51 20 1441792
set_hotkey 30 false 52 21 1179648
set_hotkey 31 false 52 21 1441792
set_hotkey 184 false 53 23 1179648

defaults import "${HOTKEY_DOMAIN}" "${TEMP_PLIST}"

print "Keyboard shortcuts configured."
