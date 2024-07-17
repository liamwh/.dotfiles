#############################################
# Section for declaring path related env variables
#############################################

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"
export XDG_CONFIG_HOME="$HOME/.config"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light jeffreytse/zsh-vi-mode
zinit light Aloxaf/fzf-tab
zinit light djui/alias-tips

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker-compose
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Go vars
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export GOPRIVATE=”dev.azure.com”

# Wasmer
export WASMER_DIR="$HOME/.wasmer"

# OpenSSL
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS system detected
    export OPENSSL_DIR="/opt/homebrew/opt/openssl@3"
elif [[ -f "/etc/arch-release" ]]; then
    # Arch Linux system detected
    export OPENSSL_DIR="/usr"
    zinit snippet OMZP::archlinux
fi

# Node Version Manager
export NVM_DIR="$HOME/.nvm"

# Ripgrep Config
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Set up zsh configuration file location
zstyle :compinstall filename "$HOME/.zshrc"

# Electron hint for Linux
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export ELECTRON_OZONE_PLATFORM_HINT="wayland"
fi

# Exclude alias reminder for nvim
export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="vim"

#############################################
# End of section for declaring path related env variables
#############################################

#############################################
# Add directories to PATH
#############################################

# Function to add a directory to PATH if it's not already in PATH
add_to_path_if_not_exists() {
    if [[ ":$PATH:" != *":$1:"* ]]; then
        path+=("$1")
    fi
}

add_to_path_if_not_exists "/usr/local/opt/libpq/bin"
add_to_path_if_not_exists "/usr/local/bin"
add_to_path_if_not_exists "/opt/homebrew/bin/"
add_to_path_if_not_exists "/home/linuxbrew/.linuxbrew/bin"
add_to_path_if_not_exists "$HOME/.local/bin"
add_to_path_if_not_exists "$HOME/go/bin"
add_to_path_if_not_exists "$HOME/.cargo/bin"
add_to_path_if_not_exists "$HOME/.fly/bin"
add_to_path_if_not_exists "/home/linuxbrew/.linuxbrew/Cellar/surreal/1.1.1/bin"
add_to_path_if_not_exists "/var/lib/snapd/snap/bin"
add_to_path_if_not_exists "$GOPATH/bin"
add_to_path_if_not_exists "/opt/homebrew/opt/mysql-client/bin"
add_to_path_if_not_exists "~/.nix-profile/bin"

#############################################
# End of add directories to PATH section
#############################################

#############################################
# Additional sourcing
#############################################

# Set up brew
# OS Agnostic brew setup
if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "$HOME/.linuxbrew/bin/brew" ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
elif [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x "$(command -v brew)" ]; then
    eval "$(brew shellenv)"
fi

# wash (wasmCloud shell) completions
# To generate completions for zsh, run the following command:
# $HOME/.cargo/bin/wash completions -d $HOME/.wash zsh
fpath=( $HOME/.wash "${fpath[@]}" )

# Source wasmer.sh if it exists
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Set up NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#############################################
# End additional sourcing section
#############################################

# Always run compinit immediately after making modifications to PATH
autoload -Uz compinit && compinit

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Source other zsh files
source <(fzf --zsh)
source <(zoxide init zsh)
source <(direnv hook zsh)
source <(atuin init zsh)
source <(starship init zsh)

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#############################################
# Aliases
#############################################

# Git aliases
alias gpod="git pull origin development"
alias gp="git pull"
alias gpo="git push origin"
alias gcm="git checkout main"

# Npm aliases
alias npx="pnpx"

# Tmux aliases
alias tm="tmux"
alias tml="tmux list-sessions"
alias tma="tmux attach-session"
alias tmat="tmux attach-session -t"
alias tmks="tmux kill-session -t"
alias tmka="tmux kill-session -a"
alias tmn="tmux new-session"

# Misc aliases
alias lg="lazygit"
alias j="just"
alias k="kubectl"
alias ka="kubectl apply -k ."
alias ls="eza"
alias l="eza -la --icons --git"
alias lt="eza --tree --level=2 --long --icons --git"
alias vim="nvim"
alias v="nvim"
alias cat="bat -p"
alias t="terraform"

# Wasm Component Artifact Quick Sharing
alias uuid="uuid=$(uuidgen | tr '[:upper:][:lower:]' '[:lower:][:upper:]' | tr -d '\n')"
alias wpttl="wash push ttl.sh/${uuid}:1h"

#############################################
# End of Aliases section
#############################################

#############################################
# Functions
#############################################
# Yazi function to change cwd when exiting yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
