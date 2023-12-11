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

# Install or upgrade the specified formulae
install_or_upgrade "formula" "${formulae[@]}"

echo "Installations are complete, please reopen your shell"

kill %1
