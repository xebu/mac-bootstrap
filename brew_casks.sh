#!/bin/bash

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

# Install Homebrew (if not installed)
if ! command -v brew &>/dev/null; then
    echo "Home brew not installed, being installation"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Homebrew is installed ... continue"
fi

# Install each Homebrew Cask
for cask in "${casks[@]}"; do
    brew install --cask "$cask"
done

# Display installation status
echo "Homebrew Casks are installed."

# Clean up
brew cleanup
