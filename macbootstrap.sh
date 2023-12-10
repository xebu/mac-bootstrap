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

# List of additional Homebrew Casks
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

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
fi

# Install Python 3 and set it as default
brew install python@3
echo 'export PATH="/usr/local/opt/python@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Install Wget and Git
brew install wget git

# Install additional Homebrew formulae
for formula in "${formulae[@]}"; do
    brew install "$formula"
done

# Install Homebrew Casks
for cask in "${casks[@]}"; do
    brew install --cask "$cask"
done

# Display installation status
echo "Homebrew, Oh My Zsh, SDKMAN, Python 3 (default), Wget, Git, and additional formulae and Casks are installed."

# Optionally, change the default shell to Zsh
chsh -s /bin/zsh

# Clean up
brew cleanup
