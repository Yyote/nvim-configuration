#!/usr/bin/env bash

sudo apt-get update -y

echo "Install silversearcher-ag"
sudo apt install -y silversearcher-ag

echo "Installing nodejs"
sudo apt-get install -y ca-certificates curl gnupg

cd ~
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install 20
nvm use 20
nvm alias default 20

echo "Nodejs installation check:"
node -v
npm -v

echo "Installing bash-language-server"
npm install -g bash-language-server

echo "Check the nerd font installation:"
ls ~/.fonts

echo "Installing exuberant-ctags"
sudo apt-get install exuberant-ctags

echo "Installing lua-language-server"
sudo apt update
sudo apt install -y git build-essential ninja-build luarocks
cd ~
git clone https://github.com/LuaLS/lua-language-server.git
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
cd ~
echo 'export PATH=$PATH:/home/leev/lua-language-server/bin/' >> ~/.bashrc
source ~/.bashrc

echo "Check installation:"
alias luamake="/home/leev/lua-language-server/3rd/luamake/luamake"
export PATH=$PATH:/home/leev/lua-language-server/bin/
lua-language-server --version
