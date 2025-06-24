#!/bin/bash

# Set the dock to autohide
defaults write com.apple.dock autohide -bool true

defaults write com.apple.dock autohide-delay -float 0

# Set the dock to autohide delay
defaults write com.apple.dock autohide-time-modifier -float 0.1

# disable the press-and-hold accent menu so you get repeats instead
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set the key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# short initial delay before repeat kicks in (15 is very short, default is ~68)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# apply immediately
killall SystemUIServer