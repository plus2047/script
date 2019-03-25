#!/usr/bin/env bash

echo "need sodo permission for apt."
sudo echo "sudo ready"

# ===== installation functions =====
function install_mac_app {
    [ ! -x `command -v brew` ] && return
    echo "install mac app..."
    brew install coreutils git zsh python3
    brew cask install dozer
    brew cask install karabiner-elements
    brew cask install hammerspoon
}

function install_linux_app {
    [ ! `uname` = "Linux" ] && return
    [ ! -x `command -v apt` ] && return
    echo "install linux app..."
    sudo apt install zsh python3 git
}

function install_brew {
    [ ! `uname` = "Darwin" ] && return
    [ -x `command -v brew` ] && return
    echo "install homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    hash -r
}

function install_myzsh {
    [ -d "$HOME/.oh-my-zsh" ] && return
    echo "install oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

function backup_and_rm {
    _TS=`date +"_%y%m%d"`
    [ ! -e $1$_TS ] && mv $1 $1$_TS &> /dev/null
    rm $1 &> /dev/null
}

function link_to {
    backup_and_rm $2
    ln -Fs $1 $2
}

function copy_to {
    backup_and_rm $2
    cp $1 $2
}

function append_to_file {
    touch $2
    TAIL=`tail -1 $2`
    [ ! "$TAIL" == "$1" ] && echo $1 >> $2
}

# ===== install all =====
install_brew
install_mac_app
install_linux_app
install_myzsh

script_dir=$(dirname $0)
script_dir=$(realpath $script_dir)

link_to $script_dir/config/screenrc $HOME/.screenrc
link_to $script_dir/config/vimrc $HOME/.vimrc

append_to_file "source $script_dir/config/anyshrc" $HOME/.zshrc
append_to_file "source $script_dir/config/anyshrc" $HOME/.bashrc

