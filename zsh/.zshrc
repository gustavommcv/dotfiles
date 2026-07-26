DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ======================
#  Environment Variables
# ======================

# NVM Configuration
export NVM_DIR="$HOME/.nvm"

# Lazy load NVM - only loads when you type node, npm, npx, nvm, etc.
lazy_load_nvm() {
  unset -f node npm npx nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

node() { lazy_load_nvm && node "$@"; }
npm() { lazy_load_nvm && npm "$@"; }
npx() { lazy_load_nvm && npx "$@"; }
nvm() { lazy_load_nvm && nvm "$@"; }

# Go Path Configuration
export PATH=$PATH:$HOME/go/bin

# Oh My Zsh Installation Path
export ZSH="$HOME/.oh-my-zsh"

# Bun path
export PATH="/home/gustavo/.cache/.bun/bin:$PATH"

# ======================
#  ZSH Configuration
# ======================

# Theme Selection
ZSH_THEME="robbyrussell"

# Plugin Management
plugins=(
  git 
  zsh-autosuggestions 
  zsh-syntax-highlighting
)

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ======================
#  Aliases
# ======================

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"

# Tmux
alias ta="tmux attach"

# Arduino-cli
alias ac="arduino-cli"

# System
alias ll="ls -la"
alias cl="clear"

# ======================
#  Initialization
# ======================

autoload -Uz compinit

ZCOMPDUMP=$HOME/.cache/.zcompdump

if [[ ! -f $ZCOMPDUMP ]]; then
    compinit -d "$ZCOMPDUMP"
else
    compinit -C -d "$ZCOMPDUMP"
fi

# Load Oh My Zsh core
source $ZSH/oh-my-zsh.sh


# Load Angular CLI autocompletion.
# source <(ng completion script)
