# ======================
#  Environment Variables
# ======================

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm completions

# Go Path Configuration
export PATH=$PATH:$(go env GOPATH)/bin

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

# ======================
#  Aliases
# ======================

# Git
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"

# System
alias ll="ls -la"
alias cl="clear"

# Tmux
alias ta="tmux attach"

# ======================
#  Initialization
# ======================

# Load Oh My Zsh core
source $ZSH/oh-my-zsh.sh

# Angular CLI Completion
source <(ng completion script)
