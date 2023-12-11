#!/bin/bash

# List of additional Homebrew formulae
formulae=(
    autoconf
    ffmpeg
    gettext
    git
    neovim
    nvm
    openssl@1.1
    openssl@3
    pyenv
    readline
    ruby
    tree
    tree-sitter
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

# Install Homebrew (if not installed)
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# install each Homebrew Formulae
for formula in "${formulae[@]}"; do
    brew install "$formula"
done

# Install each Homebrew Cask
for cask in "${casks[@]}"; do
    brew install --cask "$cask"
done

# Display installation status
echo "Homebrew Casks are installed."

# Clean up
brew cleanup
