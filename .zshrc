export PATH=$HOME/.cargo/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/libpq/bin:$PATH"
path+=('/opt/homebrew/bin/')
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"

plugins=(
    git
    macos
    docker
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Source oh my ZSH
source $ZSH/oh-my-zsh.sh

# Git aliases
alias gpod="git pull origin development"
alias gp="git pull"
alias gpo="git push origin"
alias gcm="git checkout main"

# Npm aliases
alias npm="pnpm"
alias npx="pnpx"


# Misc aliases
alias lg="lazygit"
alias j="just"
alias k="kubectl"
alias ka="kubectl apply -k ."
alias ll="exa -la"
alias vim="nvim"

# Tmux aliases
alias tm="tmux"
alias tml="tmux list-sessions"
alias tma="tmux attach-session"
alias tmat="tmux attach-session -t"
alias tmks="tmux kill-session -t"
alias tmn="tmux new-session"

#  Source fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"

# Go vars
export GOPATH="$HOME/go"
path+=("$GOPATH/bin")
export GOBIN="$HOME/go/bin"
export GOPRIVATE=”dev.azure.com”
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export OPENSSL_DIR="/opt/homebrew/opt/openssl@3"

# >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "$HOME/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="$HOME/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
