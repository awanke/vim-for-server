#!/bin/bash

# refer  spf13-vim bootstrap.sh`
BASEDIR=$(dirname $0)
cd $BASEDIR
CURRENT_DIR=`pwd`

for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles; do [ -L $i ] && unlink $i ; done

rm -rf ~/.vimrc
cp -f vimrc-7.0 $HOME/.vimrc

#rm -rf ~/.vim/bundle/Vundle.vim
#git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
rm -rf ~/.vim/bundle
mkdir -p ~/.vim/autoload ~/.vim/bundle 
cp -r nerdtree-4* ~/.vim/bundle/
rm -rf pathogen.vim
git clone https://github.com/tpope/vim-pathogen.git pathogen.vim
cp -r pathogen.vim/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
rm -rf pathogen.vim
cd ~/.vim/bundle && \
git clone git://github.com/tpope/vim-sensible.git
cp -r nerdtree-4* ~/.vim/bundle/
cp -r nerdtree-4* ~/.vim/bundle/nerdtree
# git clone https://github.com/scrooloose/nerdtree.git
#apt-vim
# apt-vim install -y https://github.com/scrooloose/nerdtree.git
#Then reload vim, run :Helptags, and check out :help NERD_tree.txt.

echo "Install Done!"=
