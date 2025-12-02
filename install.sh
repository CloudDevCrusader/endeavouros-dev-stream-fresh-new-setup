#!/bin/bash

# EndeavourOS/Arch Cinnamon Desktop Setup Script
# Tested on: Manjaro, Garuda, EndeavourOS
# Description: Automated setup for development environment with Python, Node.js, and various tools

set -e  # Exit on error
set -u  # Exit on undefined variable

# Configuration
GROUP="${USER}"
LOGFILE="${PWD}/install.log"
PYTHON_VERSION="3.11.4"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $*" | tee -a "$LOGFILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" | tee -a "$LOGFILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" | tee -a "$LOGFILE"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup
log "Howdy Partner! Ready for a lovely setup for Cinnamon?"
log "Currently Tested on: Manjaro, Garuda, EndeavourOS"
log "User: ${USER}, Group: ${GROUP}"

# Create project directory
log "Creating projects directory..."
mkdir -p "$HOME/projects"

# Configure git
log "Configuring git..."
git config --global core.autocrlf input

# Install base development tools
log "Installing base development tools..."
yay -S --needed --noconfirm base-devel openssl zlib xz tk zstd cmake make

# Install main packages
log "Installing main packages..."
yay -Syu --noconfirm flatpak snapd bauh discover pamac-all jdownloader2 \
         ulauncher albert appimagepool-bin gearlever ocs-url \
         pyenv nvm oh-my-posh zsh-command-not-found-git \
         zsh-autoswitch-virtualenv-git zsh-sudo fzf floorp cursor-bin \
         cursor-cli docker-desktop perplexity raidrivecli thefuck tfenv \
         spotify spicetify-cli spicetify-theme-dracula-git \
         jetbrains-toolbox jq guake raindrop github-desktop

# flathub.org
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

## tooling 
flatpak install flathub ai.jan.Jan
sudo snap install snap-store

# ohmyzsh  https://ohmyz.sh/#install        
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
omz plugin enable zsh-interactive-cd autoenv dotenv vscode node torrent thefuck npm nvm fzf git github 

# oh-my-posh https://ohmyposh.dev
oh-my-posh font install Hack
oh-my-posh font install Meslo

# tfenv https://ohmyz.sh/#install
echo 'export PATH="$HOME/.tfenv/bin:$PATH"' >> ~/.zprofile
tfenv install latest

# brew https://brew.sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc

# pyenv + virtualenv install https://github.com/pyenv/pyenv / https://github.com/pyenv/pyenv-virtualenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init - zsh)"' >> ~/.zshrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc

# uv as 2nd python management https://astral.sh
curl -LsSf https://astral.sh/uv/install.sh | sh 

# sdkman https://sdkman.io
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java

## spicetify-cli + marketplace https://spicetify.app
sudo chgrp $GROUP /opt/spotify
sudo chgrp -R $GROUP /opt/spotify/Apps
sudo chmod 775 /opt/spotify
sudo chmod 775 -R /opt/spotify/Apps

spicetify backup apply
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh

git clone https://github.com/catppuccin/spicetify.git
cp -r catppuccin ~/.config/spicetify/Themes/
rm -rf catppuccin
spicetify apply

# Install and configure Python with pyenv
exec "$SHELL"
pyenv install 3.11.4
pyenv global 3.11.4
pyenv local 3.11.4
pyenv shell 3.11.4

# Node.js LTS + NPM Packages (Incl. Claude Code: https://github.com/anthropics/claude-code)
# https://github.com/nvm-sh/nvm
nvm install --lts
npm install -g eslint prettier @anthropic-ai/claude-code
npm install -g @dwmkerr/terminal-ai