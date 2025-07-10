#!/bin/bash

# set -e: exit the script if any command fails
# set -u: exit the script if any variable is used but not defined
# set -o pipefail: Make a pipeline fail if any of its commands fails (not just the last one).

set -euo pipefail

# ─── Dock ─────────────────────────────────────────────────────────────────────
# Set the dock to autohide
defaults write com.apple.dock autohide -bool true

defaults write com.apple.dock autohide-delay -float 0

# Set the dock to autohide delay
defaults write com.apple.dock autohide-time-modifier -float 0.1

# ─── Keyboard ──────────────────────────────────────────────────────────────────

# disable the press-and-hold accent menu so you get repeats instead
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set the key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# short initial delay before repeat kicks in (15 is very short, default is ~68)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# ─── Accent Colour ────────────────────────────────────────────────────────────

# Mapping of –int values for `AppleAccentColor`:
# colourMap = [
#   ("red",       0),
#   ("orange",    1),
#   ("yellow",    2),
#   ("green",     3),
#   ("blue",      4),
#   ("purple",    5),
#   ("pink",      6),
#   ("graphite", -1),
# ]
# Deleting the key restores “Multicolour” (the rainbow dot).

# Set accent to Orange
defaults write NSGlobalDomain AppleAccentColor -int 1

# Example: deleting sets back to Multicolour
# defaults delete NSGlobalDomain AppleAccentColor

# ─── Highlight Colour ──────────────────────────────────────────────────────

# Highlight uses an RGB triplet string. Common presets:
#   Graphite:  "0.847059 0.847059 0.862745"
#   Red:       "1.000000 0.776471 0.698039"
#   Orange:    "1.000000 0.874510 0.701961"
#   Yellow:    "1.000000 0.933333 0.690196"
#   Green:     "0.752941 0.964706 0.678431"
#   Blue:      "0.717647 0.862745 0.988235"
#   Purple:    "0.866667 0.780392 0.933333"
#   Pink:      "0.984314 0.737255 0.850980"

# Set highlight to Green
defaults write NSGlobalDomain AppleHighlightColor -string "0.752941 0.964706 0.678431"

# ─── Dark mode ───────────────────────────────────────────────────────────────

osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# ─── Screenshots ─────────────────────────────────────────────────────────────

# Create Screenshots directory if it doesn't exist
mkdir -p ~/Screenshots

# Set the default screenshot location to ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# ─── Apply settings ────────────────────────────────────────────────────────────

# apply immediately
killall SystemUIServer
killall cfprefsd

echo "Set macOS settings successfully ✅"