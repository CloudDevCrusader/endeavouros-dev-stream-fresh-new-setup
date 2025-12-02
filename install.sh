#!/bin/bash
echo "Howdy Partner! Ready for a lovely setup for Cinnamon? Currently Tested on: Manjaro, Garuda, EndeavourOS"
$GROUP = "cloudcrusader"

mkdir -p $HOME/projects
git config --global core.autocrlf input

# Install needed libs

yay -S --needed base-devel openssl zlib xz tk zstd cmake make 

yay -Syu flatpak snapd bauh discover bauh pamac-all jdownloader2 \
         ulauncher albert appimagepool-bin gearlever ocs-url \
         pyenv nvm oh-my-posh oh-my-posh zsh-command-not-found-git \
         zsh-autoswitch-virtualenv-git zsh-sudo fzf floorp cursor-bin \
         cursor-cli docker-desktop perplexity raidrivecli thefuck tfenv \
         spotify spicetify-cli spicetify-theme-dracula-git \
         jetbrains-toolbox jq guake raindrop github-desktop tfenv

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
    