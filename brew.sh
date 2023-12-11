#!/bin/bash

# Extend sudo timeout for the duration of the script
sudo -v

# Keep-alive: update existing sudo timestamp until script is done
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done &

# List of additional Homebrew formulae
formulae=(
  autoconf
  ffmpeg
  gettext
  git
  neovim
  openssl@1.1
  openssl@3
  pyenv
  readline
  ruby
  shfmt
  tree
  wget
)

# List of Homebrew Casks to install
casks=(
  alfred
  arc
  caffeine
  discord
  docker
  dynobase
  firefox
  firefox-developer-edition
  github
  google-chrome
  iterm2
  nordvpn
  obsidian
  postman
  postman-cli
  signal
  slack
  spotify
  visual-studio-code
  vlc
  whatsapp
)

# Function to install or upgrade packages using Homebrew or Homebrew Cask
install_or_upgrade() {
  local package_type=$1
  shift

  for package in "$@"; do
    if [ "$package_type" == "cask" ]; then
      if brew list --cask "$package" &>/dev/null; then
        brew upgrade --cask "$package"
      else
        brew install --cask "$package"
      fi
    else
      if brew list "$package" &>/dev/null; then
        brew upgrade "$package"
      else
        brew install "$package"
      fi
    fi
  done
}

install_homebrew() {
  # Check if Homebrew is installed, and if not, install it
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    (
      echo
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
    ) >>"$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    echo "Homebrew setup added to $HOME/.zprofile"
  else
    echo "Homebrew already installed"
  fi
}

install_homebrew

# Install or upgrade the specified formulae
install_or_upgrade "formula" "${formulae[@]}"

# Install or upgrade the specified casks
install_or_upgrade "cask" "${casks[@]}"

echo "Installations are complete, please reopen your shell"

kill %1