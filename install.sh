#!/bin/bash
sudo apt update && sudo apt upgrade && sudo pacman -Syyu
sudo apt install build-essential tmux cmake git xclip npm python3-pip curl gedit smplayer  && sudo pacman -S base-devel smplayer tmux cmake neovim gedit python-pip npm  git xclip 
git clone https://github.com/jimeh/tmuxifier.git ~/.tmuxifier
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
mkdir -p ~/.local/share/fonts
# cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
# fc-cache -f -v
sudo npm i -g n
mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"
npm install -g @anshik/gfile   
curl -fsSL https://bun.sh/install | bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo rm /usr/lib/python3.11/EXTERNALLY-MANAGED
rm ~/.zshrc
ln -p ./.zshrc ~/.zshrc
LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
cat ./setupCommands.txt
