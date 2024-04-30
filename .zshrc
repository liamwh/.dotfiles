#############################################
# Section for declaring path related env variables
#############################################

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

# Go vars
export GOPATH="$HOME/go"
export GOBIN="$HOME/go/bin"
export GOPRIVATE=”dev.azure.com”

# Wasmer
export WASMER_DIR="$HOME/.wasmer"

# OpenSSL (for MacOS)
export OPENSSL_DIR="/opt/homebrew/opt/openssl@3"

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

[ -n "$ZSH" ] && [ -r $ZSH/oh-my-zsh.sh ]

#  Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source wasmer.sh if it exists
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# Set up NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#############################################
# End additional sourcing section
#############################################

#############################################
# Oh my zsh plugins
#############################################
plugins=(
    git
    macos
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-vi-mode
)
#############################################
# End of oh my zsh plugins section
#############################################

# Always run compinit immediately after making modifications to PATH
autoload -Uz compinit
compinit

# Source oh my ZSH
source $ZSH/oh-my-zsh.sh

# Source other zsh files
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"


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
alias ll="eza -la"
alias vim="nvim"
alias cat="bat -p"
alias t="terraform"

#############################################
# End of Aliases section
#############################################
