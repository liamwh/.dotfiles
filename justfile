#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

# Show available commands
default:
    @just --list --justfile {{justfile()}}

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Symlink all the dotfiles to your home directory
stow: && dump
    stow .

dump:
    brew bundle dump --file=./Brewfile --force

clean-targets:
    find ~/git -name target -exec rm -rf {} \;

# Fixes the issue if my bluetooth headphones aren't playing the music but are connected to my computer.
restart-pulseaudio:
    systemctl --user restart pipewire pipewire-pulse

# Syncs the cursor settings to my home directory, run on MacOS after updating Cursor.
sync-cursor:
    #!/bin/bash
    if [ ! -L "~/Library/Application Support/Cursor/User" ]; then
        echo "Cursor symlink broken, fixing..."
        rm -rf ~/Library/Application\ Support/Cursor/User
        ln -s ~/.config/Cursor/User ~/Library/Application\ Support/Cursor/User
    fi
