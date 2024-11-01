#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Symlink all the dotfiles to your home directory
stow: dump
    stow .

dump:
    brew bundle dump --file=./Brewfile --force

clean-targets:
    find ~/git -name target -exec rm -rf {} \;

# Fixes the issue if my bluetooth headphones aren't playing the music but are connected to my computer.
restart-pulseaudio:
    systemctl --user restart pipewire pipewire-pulse
