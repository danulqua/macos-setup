#!/bin/zsh

# Stop on command failures, unset variables, or failures within pipelines.
set -euo pipefail

# Refuse to apply macOS preferences on another operating system.
if [[ "$(uname -s)" != "Darwin" ]]; then
  # Explain the unsupported platform on standard error.
  print -u2 "This script supports macOS only."
  # Report failure to the calling shell.
  exit 1
fi

# Locate the companion scripts relative to this script's directory.
readonly SCRIPT_DIR="${0:A:h}"
# Read the macOS version so version-specific settings can be applied below.
readonly MACOS_VERSION="$(sw_vers -productVersion)"

# Show which macOS version is being configured.
print "Configuring macOS ${MACOS_VERSION}..."
# Close System Settings so it does not overwrite these changes; ignore quit errors.
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# Appearance and input
###############################################################################

# Automatically switch between light and dark appearance.
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Apply the Liquid Glass preference only on macOS 27 and later.
if (( ${MACOS_VERSION%%.*} >= 27 )); then
  # Set the Liquid Glass slider to maximum tint/opacity.
  defaults write NSGlobalDomain NSGlassTintAmount -float 1.0
fi

# Let macOS choose when scroll bars appear based on the input device.
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
# Jump to the clicked position when clicking a scroll bar's track.
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# Open save dialogs expanded so the folder browser is visible.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Apply the expanded save-dialog preference used by other apps and dialog versions.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Open print dialogs expanded so printing options are visible.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Apply the expanded print-dialog preference used by other apps and dialog versions.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# Default to saving new documents locally instead of in iCloud.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Keep typed capitalization instead of automatically capitalizing words.
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# Keep typed hyphens instead of replacing them with typographic dashes.
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Do not insert a period when the space bar is pressed twice.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Keep straight quotation marks instead of substituting curly quotes.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Leave spelling unchanged instead of automatically correcting typed words.
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Use medium-sized sidebar icons in apps that honor this preference.
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
# Show title-bar document icons immediately when hovering over the title.
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0
# Open folders after hovering over them with a dragged item for half a second.
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5
# Do not play feedback sounds when changing the system volume.
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 0

# Enable tap-to-click on the trackpad.
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
# Set the trackpad pointer tracking speed to 2.5.
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5
# Use medium trackpad click pressure: 0 is light, 1 is medium, and 2 is firm.
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1

# Let Tab move keyboard focus through all supported controls.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
# Repeat held keys instead of showing the accented-character picker.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Use a fast key-repeat interval; lower values repeat faster.
defaults write NSGlobalDomain KeyRepeat -int 2
# Use a short delay before a held key starts repeating.
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Prefer US English for the interface, with Ukrainian as the fallback language.
defaults write NSGlobalDomain AppleLanguages -array "en-US" "uk-UA"
# Use English with Ukrainian regional formats for dates, numbers, and currency.
defaults write NSGlobalDomain AppleLocale -string "en_UA"

# Use Caps Lock to switch to/from the Latin input source.
defaults write NSGlobalDomain TISRomanSwitchState -int 1

# Press Globe to do nothing.
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

###############################################################################
# Menu bar and screenshots
###############################################################################

# Hide the AM/PM label in the menu bar clock.
defaults write com.apple.menuextra.clock ShowAMPM -bool false
# Hide the day of the week in the menu bar clock.
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool false
# Always show the date alongside the menu bar clock.
defaults write com.apple.menuextra.clock ShowDate -int 1
# Show the battery percentage in the menu bar on this Mac.
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

# Save screenshots to the Desktop.
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
# Save screenshots as JPEG images.
defaults write com.apple.screencapture type -string "jpg"
# Omit the drop shadow when capturing an individual window.
defaults write com.apple.screencapture disable-shadow -bool true
# Include the capture date and time in screenshot filenames.
defaults write com.apple.screencapture include-date -bool true
# Show a floating preview thumbnail after taking a screenshot.
defaults write com.apple.screencapture show-thumbnail -bool true

###############################################################################
# Finder
###############################################################################

# Disable Finder animations to make navigation feel more immediate.
defaults write com.apple.finder DisableAllAnimations -bool true
# Choose the Desktop as the starting location for new Finder windows.
defaults write com.apple.finder NewWindowTarget -string "PfDe"
# Supply the Desktop folder URL for the new-window starting location.
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show external drives on the Desktop.
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# Show internal hard drives on the Desktop.
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
# Show connected network volumes on the Desktop.
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
# Show removable media, such as USB drives, on the Desktop.
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Keep hidden files hidden; Cmd+Shift+. still toggles them temporarily.
defaults write com.apple.finder AppleShowAllFiles -bool false
# Show filename extensions so file types are visible.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Allow filename extensions to be changed without a confirmation warning.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Prefer tabs when opening documents in apps that support window tabbing.
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"
# Show Finder's status bar with item counts and available disk space.
defaults write com.apple.finder ShowStatusBar -bool true
# Show the current folder's location in Finder's path bar.
defaults write com.apple.finder ShowPathbar -bool true
# Sort folders before files when sorting Finder windows by name.
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# Sort folders before files when sorting Desktop items by name.
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
# Search the current folder by default instead of searching the whole Mac.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Open Finder folders in list view by default.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Automatically remove items that have been in the Trash for 30 days.
defaults write com.apple.finder FXRemoveOldTrashItems -bool true

# Avoid creating .DS_Store folder-view metadata files on network volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Avoid creating .DS_Store folder-view metadata files on USB volumes.
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Make the current user's Library folder visible in Finder.
chflags nohidden "${HOME}/Library"

###############################################################################
# Dock, Mission Control, and hot corners
###############################################################################

# Place the Dock at the bottom of the screen.
defaults write com.apple.dock orientation -string "bottom"
# Set Dock icons to 32 pixels.
defaults write com.apple.dock tilesize -int 32
# Use the scale effect when minimizing windows.
defaults write com.apple.dock mineffect -string "scale"
# Show indicator dots beneath running apps in the Dock.
defaults write com.apple.dock show-process-indicators -bool true
# Make Dock icons for hidden apps translucent.
defaults write com.apple.dock showhidden -bool true
# Hide the Dock section for recently used apps.
defaults write com.apple.dock show-recents -bool false
# Automatically hide the Dock when it is not in use.
defaults write com.apple.dock autohide -bool true
# Reveal the hidden Dock immediately when the pointer reaches its edge.
defaults write com.apple.dock autohide-delay -float 0
# Show and hide the Dock without an animation.
defaults write com.apple.dock autohide-time-modifier -float 0
# Highlight the item under the pointer in a Dock stack's grid view.
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Give each display its own Spaces instead of spanning Spaces across displays.
defaults write com.apple.spaces spans-displays -bool false
# Group windows by application in Mission Control.
defaults write com.apple.dock expose-group-by-app -bool true
# Keep Spaces in their existing order instead of reordering by recent use.
defaults write com.apple.dock mru-spaces -bool false
# Use a short Mission Control animation lasting one tenth of a second.
defaults write com.apple.dock expose-animation-duration -float 0.1
# Enable the trackpad gesture for showing an app's windows in App Exposé.
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
# Only reveal the Desktop on wallpaper clicks when using Stage Manager.
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Open Mission Control when the pointer enters the top-left corner.
defaults write com.apple.dock wvous-tl-corner -int 2
# Activate the top-left hot corner without holding a modifier key.
defaults write com.apple.dock wvous-tl-modifier -int 0
# Show the Desktop when the pointer enters the top-right corner.
defaults write com.apple.dock wvous-tr-corner -int 4
# Activate the top-right hot corner without holding a modifier key.
defaults write com.apple.dock wvous-tr-modifier -int 0
# Open Launchpad/Apps when the pointer enters the bottom-left corner.
defaults write com.apple.dock wvous-bl-corner -int 11
# Activate the bottom-left hot corner without holding a modifier key.
defaults write com.apple.dock wvous-bl-modifier -int 0
# Disable the bottom-right hot corner.
defaults write com.apple.dock wvous-br-corner -int 0
# Clear any modifier-key requirement for the bottom-right hot corner.
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Apps
###############################################################################

# Create plain-text documents by default in TextEdit.
defaults write com.apple.TextEdit RichText -int 0
# Use UTF-8 by default when opening plain-text files in TextEdit.
defaults write com.apple.TextEdit PlainTextEncoding -int 4
# Use UTF-8 by default when saving plain-text files in TextEdit.
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Keyboard shortcuts and reload
###############################################################################

# Apply the keyboard shortcuts defined in the companion script.
"${SCRIPT_DIR}/macos_hotkeys.zsh"

# Restart the preferences service and desktop UI processes to load the changes.
for process in cfprefsd Dock Finder SystemUIServer; do
  # Stop each process so macOS relaunches it; ignore errors if it is not running.
  killall "${process}" 2>/dev/null || true
done

# Report completion and explain how to activate settings that need a new session.
print "Done. Log out or restart if a setting has not taken effect."
