#!/usr/bin/env bash

echo "need sodo permission for apt."
sudo echo "sudo ready"

# bin needed: brew (mac), coreutils(mac), python3, zsh, git
if [ `uname` = "Darwin" ]; then
    if [ ! -x `command -v brew` ]; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        hash -r
    fi
    brew install coreutils git zsh python3
else
    sudo apt install zsh python3 git
fi
hash -r
# =====

# ===== oh-my-zsh =====
if [ ! -d "$HOME/.oh-my-zsh" ] 
then
    sh -c $(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)
fi

# ===== install config files. =====
_SD=`dirname "$0"`; SD=`realpath $_SD`; PWD=`pwd`

_TS=`date +"_%y%m%d"`
if [ ! -e $HOME/.vimrc$_TS ]; then
    mv $HOME/.screenrc $HOME/.screenrc$_TS &> /dev/null
    mv $HOME/.vimrc $HOME/.vimrc$_TS &> /dev/null
fi
rm $HOME/.screenrc &> /dev/null
rm $HOME/.vimrc &> /dev/null
ln -Fs $SD/config/screenrc $HOME/.screenrc
ln -Fs $SD/config/vimrc $HOME/.vimrc

# zshrc
SHCMD="source $SD/config/anyshrc"
TAIL=`tail -1 $HOME/.zshrc`
[ ! "$TAIL" == "$SHCMD" ] && echo $SHCMD >> $HOME/.zshrc

# # install ssh public key & config but not install private key.
# mkdir $HOME/.ssh &> /dev/null
# chmod 700 $HOME/.ssh
# _C=$HOME/.ssh/config
# _A=$HOME/.ssh/authorized_keys
# _TS=`date +"_%y%m%d"`
# [ -e $_C -a ! -e $_C$_TS ] && mv $_C $_C$_TS
# [ -e $_A -a ! -e $_A$_TS ] && mv $_A $_A$_TS
# cp $SD/ssh/id_rsa.pub $_A
# cp $SD/ssh/config $_C
# chmod 644 $_C $_A

# return to origin dir.
cd $PWD

