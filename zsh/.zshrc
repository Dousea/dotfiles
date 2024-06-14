source "$HOME/.local/share/antigen/antigen.zsh"
antigen bundle zsh-users/zsh-completions
ZSH_AUTOSUGGEST_STRATEGY=completion
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle akash329d/zsh-alias-finder
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

bindkey -v

autoload -Uz colors && colors
alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

autoload -Uz compinit && compinit
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
_comp_options+=(globdots) # Include hidden files

autoload -U add-zsh-hook

function _lazyload_nvm_node() {
  if ! [ -x "$(command -v nvm)" ]; then
    return
  fi

  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version..."
    nvm use default
  fi
}
add-zsh-hook chpwd _lazyload_nvm_node
_lazyload_nvm_node

function _wrapped_tmux() {
  local -a tmux_cmd
  tmux_cmd=(command tmux)
  tmux_cmd+=(-u)

  if [[ -n "$@" ]]; then
    $tmux_cmd "$@"
    return $?
  fi

  # Try to connect to an existing session.
  $tmux_cmd attach -t my-session

  # If failed, just run tmux.
  if [[ $? -ne 0 ]]; then
    tmux_cmd+=(-f "$HOME/.tmux.conf")
    $tmux_cmd new-session -s my-session
  fi

  exit
}

# Use the completions for tmux for our function
compdef _tmux _wrapped_tmux
# Alias tmux to our wrapper function.
alias tmux=_wrapped_tmux

# Add our aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -x "$(command -v lazygit)" ]; then
  alias lzg='lazygit'
fi

if [ -x "$(command -v lazydocker)" ]; then
  alias lzd='lazydocker'
fi

[[ -f ~/.aliasrc ]] && source ~/.aliasrc

# Rust?
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Loads NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Loads RVM
[[ -f ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm
source $(rvm env --path)

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
    export ZSH_TMUX_AUTOSTARTED=true
    _wrapped_tmux
  fi
fi

eval "$(oh-my-posh init zsh --config "$HOME/.local/share/oh-my-posh/theme.omp.json")"
