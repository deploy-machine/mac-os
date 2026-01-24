# Zsh configuration
# Place file contents in ~/.config/zsh/.zshrc

# Path
if [[ $(uname -m) == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-fast-syntax-highlighting zoxide)

# Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# Aliases
alias ll="ls -la"
alias la="ls -a"
alias l="ls -l"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias grep="grep --color=auto"
alias vi="nvim"
alias vim="nvim"

# Environment variables
export EDITOR="nvim"
export BROWSER="open"

# Load zoxide
eval "$(zoxide init zsh)"

# Load mise
eval "$(mise activate zsh)"

# Enhanced completion
autoload -U compinit
compinit

# History settings
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY