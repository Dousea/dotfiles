eval "$(oh-my-posh init zsh --config "$HOME/.local/share/oh-my-posh/theme.omp.json")"

bindkey -v

autoload -Uz colors && colors
autoload -Uz compinit && compinit
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
_comp_options+=(globdots) # Include hidden files

source "$HOME/.local/share/antigen/antigen.zsh"
antigen bundle zsh-users/zsh-completions
ZSH_AUTOSUGGEST_STRATEGY=completion
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle akash329d/zsh-alias-finder
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

function _wrapped_tmux() {
  if [[ -n "$@" ]]; then
    command tmux "$@"
    return $?
  fi

  local -a tmux_cmd
  tmux_cmd=(command tmux)
  tmux_cmd+=(-u)

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

# Autostart if not already in tmux and enabled.
if [[ -z "$TMUX" ]]; then
  # Actually don't autostart if we already did and multiple autostarts are disabled.
  if [[ "$ZSH_TMUX_AUTOSTARTED" != "true" ]]; then
    export ZSH_TMUX_AUTOSTARTED=true
    _wrapped_tmux
  fi
fi

