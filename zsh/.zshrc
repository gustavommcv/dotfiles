DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# ======================
#  Environment Variables
# ======================

# Go Path Configuration (go install puts binaries here)
export PATH=$PATH:$HOME/go/bin

# Oh My Zsh Installation Path
export ZSH="$HOME/.oh-my-zsh"

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
