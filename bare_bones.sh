#!/bin/bash

# Extend sudo timeout for the duration of the script
sudo -v

# Keep-alive: update existing sudo timestamp until script is done
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done &


# Function to install Oh My Zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  fi
}


# Function to install NVM
install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
    # export NVM_DIR="$HOME/.nvm"
    
    # Define the lines to add to the ~/.zshrc file
    add_to_profile='
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    '

    # Append the lines to ~/.zshrc
    echo "$add_to_profile" >> ~/.zshrc

# Source ~/.zshrc to apply the changes immediately
source ~/.zshrc

echo "NVM configuration added to ~/.zshrc."

    nvm install --lts


    echo "nvm and node --lts installation complete"
  fi
}

install_sdkman() {
    # Install SDKMAN
    echo "Installing sdkman..."
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash

        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
    sdk version
}

install_homebrew() {
  # Check if Homebrew is installed, and if not, install it
  if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  echo "Homebrew setup added to $HOME/.zprofile"
fi
}

install_homebrew

install_oh_my_zsh

install_nvm

install_sdkman

echo "Installations are complete, please reopen your shell"

# Disable the sudo keep-alive loop
kill %1