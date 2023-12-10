#!/bin/bash

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

# Function to install Oh My Zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}

# Function to install NVM
install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
  fi
}

# Function to set Python 3 as the default Python version
set_default_python3() {
  if [ -x "$(command -v python3)" ]; then
    echo "Setting Python 3 as the default Python version..."
    sudo ln -sf /usr/local/bin/python3 /usr/local/bin/python
  else
    echo "Python 3 is not installed. Please install Python 3 first."
  fi
}

# Extend sudo timeout for the duration of the script
sudo -v

# Keep-alive: update existing sudo timestamp until script is done
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done &

# Check if Homebrew is installed, and if not, install it
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# File containing the list of formulae to install
formulae_file="formulae.txt"

# File containing the list of casks to install
casks_file="casks.txt"

# Check if the formulae file exists
if [ -f "$formulae_file" ]; then
  # Read formula names from the file and add them to the formulae array
  mapfile -t formulae < "$formulae_file"
else
  echo "Formulae file '$formulae_file' not found."
  exit 1
fi

# Check if the casks file exists
if [ -f "$casks_file" ]; then
  # Read cask names from the file and add them to the casks array
  mapfile -t casks < "$casks_file"
else
  echo "Casks file '$casks_file' not found."
  exit 1
fi

# Install or upgrade the specified formulae
install_or_upgrade "formula" "${formulae[@]}"

# Install or upgrade the specified casks
install_or_upgrade "cask" "${casks[@]}"

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
install_oh_my_zsh

# Install NVM
echo "Installing NVM..."
install_nvm

# Set Python 3 as the default Python version
set_default_python3

# Disable the sudo keep-alive loop
kill %1
