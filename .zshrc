# Init terminal
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export EDITOR=vim
export TERM=xterm-256color

# Locale settings
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path settings
## Android SDK
export PATH="$HOME/Downloads/flutter/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/tools/cmdline-tools/bin:$PATH"

## Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# History settings
HISTSIZE=100000
HISTFILE=~/.zsh_history
SAVE_HIST=$HISTFILE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt histignorespace
setopt histignorealldups
setopt histsavenodups
setopt histignoredups
setopt histfindnodups

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git" # todo move to git submodules
if [ ! -d $ZINIT_HOME ]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Key bindings
bindkey '^a' beginning-of-line # TODO : fix this
bindkey '^e' end-of-line # TODO : fix this

bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

bindkey '^f ' autosuggest-accept

# Alias
alias ls="ls --color"

# Shell integratoins
eval "$(fzf --zsh)"

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

## Completion custom
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Other settings

# config vault laboinfra cli
export VAULT_SKIP_VERIFY=true
export VAULT_ADDR="https://vault.core.laboinfra.net:8200"

# fix ansible error
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# fix python warning
export PYTHONWARNINGS="ignore"

# allow to sing commit with gpg
export GPG_TTY=$(tty)

# alias
alias genpass="openssl rand -hex 10"
alias ssh="ssh -oStrictHostKeyChecking=no"

## LaboInfra Bastion
export BASTION_USER="gabin"
export BASTION_HOST="ovh-bastion.core.laboinfra.net"
export BASTION_PORT=22
alias laboinfra-bastion='ssh gabin@ovh-bastion.core.laboinfra.net -t -- '
alias laboinfra-bastionm='mosh --ssh="ssh -t" gabin@ovh-bastion.core.laboinfra.net -- '

# SSH Agent
if [ -f ~/.ssh/agent.env ]; then
  . ~/.ssh/agent.env > /dev/null
  if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    eval `ssh-agent > ~/.ssh/agent.env`
  fi
else
  eval `ssh-agent > ~/.ssh/agent.env`
fi

fpath+=~/.zfunc; autoload -Uz compinit; compinit
