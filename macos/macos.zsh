#!/bin/zsh

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  print -u2 "This script supports macOS only."
  exit 1
fi

readonly SCRIPT_DIR="${0:A:h}"
readonly MACOS_VERSION="$(sw_vers -productVersion)"

print "Configuring macOS ${MACOS_VERSION}..."
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Appearance and input
###############################################################################

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Trackpad tracking speed and click pressure: 0 light, 1 medium, 2 firm.
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1

# Keyboard navigation and repeat rate.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# English UI, Ukrainian as the second language, and Ukrainian regional formats.
defaults write NSGlobalDomain AppleLanguages -array "en-US" "uk-UA"
defaults write NSGlobalDomain AppleLocale -string "en_UA"

# Use Caps Lock to switch to/from the Latin input source.
defaults write NSGlobalDomain TISRomanSwitchState -int 1

# Press Globe to show Emoji & Symbols.
defaults write com.apple.HIToolbox AppleFNUsageType -int 2

###############################################################################
# Menu bar and screenshots
###############################################################################

# 24-hour clock with the date, matching the intent of the former DateFormat.
defaults write com.apple.menuextra.clock ShowAMPM -bool false
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false
defaults write com.apple.menuextra.clock ShowDate -int 1

defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "jpg"
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture include-date -bool true
defaults write com.apple.screencapture show-thumbnail -bool true

###############################################################################
# Finder
###############################################################################

defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Keep hidden files hidden; Cmd+Shift+. still toggles them temporarily.
defaults write com.apple.finder AppleShowAllFiles -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

chflags nohidden "${HOME}/Library"

###############################################################################
# Dock, Mission Control, and hot corners
###############################################################################

defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock tilesize -int 32
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock showhidden -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock autohide -bool false

# Use separate Spaces per display, group windows by app, and keep Spaces stable.
defaults write com.apple.spaces spans-displays -bool false
defaults write com.apple.dock expose-group-by-app -bool true
defaults write com.apple.dock mru-spaces -bool false

# Top-left: Mission Control. Top-right: Desktop. Bottom corners: disabled.
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Apps
###############################################################################

# TextEdit: plain UTF-8 text by default.
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Keyboard shortcuts and reload
###############################################################################

"${SCRIPT_DIR}/macos_hotkeys.zsh"

for process in cfprefsd Dock Finder SystemUIServer; do
  killall "${process}" 2>/dev/null || true
done

print "Done. Log out or restart if a setting has not taken effect."
