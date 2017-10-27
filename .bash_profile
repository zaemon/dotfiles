# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        source "$HOME/.bashrc"
    fi
fi

if [ "$(uname)" == 'Darwin' ]; then
    alias ls='ls -G'
    :
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    alias ls='ls -F --color=auto --show-control-chars'
    :
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW64_NT' ]; then
    alias ls='ls -F --color=auto --show-control-chars'
    alias mingw-get-search="mingw-get list | grep Package: | grep "
    MSYSTEM=MINGW64
    export MSYSTEM
else
    :
fi

# set PATH so it includes user's private bin directories
PATH="${HOME}/bin:${HOME}/local/bin:/usr/bin:/usr/local/bin:${PATH}"
LANG=ja_JP.UTF-8
LESSCHARSET=utf-8
TERM=xterm-256color
GTK_IM_MODULE=ibus
XMODIFIERS=@im=ibux
QT_IM_MODULE=ibus
# Vagrant=VirtualBoxを使った場合のホスト側DISPLAYを参照する設定
DISPLAY=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10):0.0


export PATH
export LANG
export LESSCHARSET
export TERM
export GTK_IM_MODULE
export XMODIFIERS
export QT_IM_MODULE
export DISPLAY
