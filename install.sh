#!/usr/bin/env bash

SD=`dirname "$0"`
SD=`realpath $SD`
PWD=`pwd`

echo "need sodo permission for apt."
sudo echo "sudo ready"

# zsh & oh-my-zsh
if [ ! -x `command -v zsh` ]
then
    sudo apt install zsh
fi
if [ ! -d "$HOME/.oh-my-zsh" ] 
then
    sh -c $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)
fi

# install config files.
# screenrc
ln -Fs $SD/screenrc $HOME/.screenrc
ln -Fs $SD/vimrc $HOME/.vimrc
# zshrc
SHCMD="source $SD/anyshrc"
TAIL=`tail -1 $HOME/.zshrc`
if [ ! "$TAIL" == "$SHCMD" ]
then
    echo $SHCMD >> $HOME/.zshrc
fi
# ssh: install public key & config but not install private key.
mkdir $HOME/.ssh &> /dev/null
chmod 700 $HOME/.ssh
_C=$HOME/.ssh/config
_A=$HOME/.ssh/authorized_keys
_TS=`date +"_%y%m%d"`
if [ -e $_C -a ! -e $_C$_TS ]
then
    mv $_C $_C$_TS
fi
if [ -e $_A -a ! -e $_A$_TS ]
then
    mv $_A $_A$_TS
fi
cp $SD/ssh/id_rsa.pub  $_A
cp $SD/ssh/config $_C
chmod 644 $_C $_A

# return to origin dir.
cd $PWD

