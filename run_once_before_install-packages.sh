#!/usr/bin/env bash
set -euo pipefail

# System prerequisites (compilers for Homebrew, cmake for tmux-mem-cpu-load)
case "$(uname -s)" in
  Linux)
    . /etc/os-release
    case " ${ID} ${ID_LIKE:-} " in
      *" fedora "* | *" rhel "*)
        sudo dnf install -y @development-tools procps-ng curl file git zsh cmake
        ;;
      *" debian "* | *" ubuntu "*)
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git zsh cmake
        ;;
      *)
        echo "Unsupported Linux distribution: ${ID}" >&2
        exit 1
        ;;
    esac
    ;;
  Darwin)
    # The Homebrew installer takes care of the Xcode Command Line Tools.
    ;;
  *)
    echo "Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

find_brew() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
      echo "$brew_bin"
      return 0
    fi
  done
  return 1
}

if ! brew_bin="$(find_brew)"; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew_bin="$(find_brew)"
fi
eval "$("$brew_bin" shellenv)"

# Install shared packages via Homebrew
brew bundle --file=/dev/stdin <<BREWFILE
brew "oh-my-posh"
brew "tmux"
brew "neovim"
brew "lazygit"
brew "eza"
brew "zoxide"
brew "mise"
$([[ "$(uname -s)" == Darwin ]] && echo 'brew "cmake"')
BREWFILE
