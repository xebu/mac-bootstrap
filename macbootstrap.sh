#!/bin/bash

# Prompt for the user's password and store it securely
echo "Please enter your password (for sudo access):"
read -s password

# Define a function to execute commands with sudo using the provided password
sudo_with_password() {
    local pass="$1"
    shift
    echo "$pass" | sudo -S -p '' "$@"
}

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
    echo "$password" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sudo_with_password "$password" sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install SDKMAN
if [ ! -d "$HOME/.sdkman" ]; then
    sudo_with_password "$password" curl -s "https://get.sdkman.io" | bash
fi

# Install Python 3 and set it as default
sudo_with_password "$password" brew install python@3
echo 'export PATH="/usr/local/opt/python@3/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Install Wget and Git
sudo_with_password "$password" brew install wget git

# Install additional Homebrew formulae
for formula in "${formulae[@]}"; do
    sudo_with_password "$password" brew install "$formula"
done

# Install Homebrew Casks
for cask in "${casks[@]}"; do
    sudo_with_password "$password" brew install --cask "$cask"
done

# Display installation status
echo "Homebrew, Oh My Zsh, SDKMAN, Python 3 (default), Wget, Git, and additional formulae and Casks are installed."

# Optionally, change the default shell to Zsh
sudo_with_password "$password" chsh -s /bin/zsh

# Clean up
sudo_with_password "$password" brew cleanup

# Securely clear the stored password
unset password
