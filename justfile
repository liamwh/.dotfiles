#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.

# Show available commands
default:
    @just --list --justfile {{justfile()}}

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Symlink all the dotfiles to the home directory
stow: && dump
    stow . -v

dump:
    brew bundle dump --file=./Brewfile --force

install-brew-packages:
    arch -arm64 brew bundle install --file=./Brewfile

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

# Exports all the npm global packages to a file, so we can import them later.
export-npm-global-packages:
    pnpm list -g --depth=0 --json | jq -r '.dependencies | keys | .[]' > global-packages.txt

# Installs all the npm global packages from the file
install-npm-global-packages:
    cat global-packages.txt | xargs pnpm install -g

# Create an alias for Docker Desktop
alias-docker-desktop:
    ln -s "/Applications/Docker.app/Contents/MacOS/Docker Desktop" "/Applications/Docker"

set-macos-settings:
    sh scripts/set-macos-settings.sh

export-cursor-extensions:
    cursor --list-extensions --show-versions > cursor-extensions.txt

import-cursor-extensions:
    xargs -L1 cursor --install-extension < cursor-extensions.txt

setup-neovim-repo:
    git clone https://github.com/liamwh/init.lua.git ~/.config/nvim
