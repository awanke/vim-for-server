#!/bin/bash
BASEDIR=$(dirname $0)
cd $BASEDIR
echo crrrent_pwd=$BASEDIR
CURRENT_DIR=`pwd`

# curl https://raw.githubusercontent.com/wklken/vim-for-server/master/vimrc > ~/.vimrc

# unlink
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles; do [ -L $i ] && unlink $i ; done
ln -s $CURRENT_DIR/vimrc ~/.vimrc
echo install_vim-for-server_successfull!
