# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

getIbusDaemonPidFiles() {
  if [ ! -d ${HOME}/.config/ibus/bus ]; then
    echo ""
    return
  fi
  ls -1 ${HOME}/.config/ibus/bus/*
}

getIbusDaemonPid() {
  pidFile="${1}"
  if [ ! -f "${pidFile}" ]; then
    echo ""
    return
  fi
  cat "${pidFile}" | grep "IBUS_DAEMON_PID" | cut -d'=' -f2
}

ibusDaemonProcessExists() {
  pid="${1}"
  user=`whoami`
  processCount=`ps -ef | grep "^${user}" | grep "ibus-daemon" | wc -l`
  if [ "${processCount}" = 1 ]; then
    echo "0" # not exist
    return
  elif [ "${processCount}" = 2 ]; then
    echo "1"
    return
  fi
}

if [ "$(uname)" == 'Darwin' ]; then
    alias ls='ls -G'
    PATH=/usr/local/opt/openssl/bin:$PATH
    :
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    alias ls='ls -F --color=auto --show-control-chars'
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    export VTE_CJK_WIDTH=1
    export MANPATH
    export INFOPATH
    ibusDaemonExists=0
    for ibusDaemonPidFile in `getIbusDaemonPidFiles`; do
      ibusDaemonPid=`getIbusDaemonPid "${ibusDaemonPidFile}"`
      ibusDaemonExists=`ibusDaemonProcessExists "${ibusDaemonPid}"`
      if [ "${ibusDaemonExists}" = 1 ]; then
        break
      fi
    done
    if [ "${ibusDaemonExists}" = 0 ]; then
      exec ibus-daemon -dxr &      # ibus自動起動
    fi
    :
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW64_NT' ]; then
    alias ls='ls -F --color=auto --show-control-chars'
    alias mingw-get-search="mingw-get list | grep Package: | grep "
    export MSYSTEM=MINGW64
    # Vagrant=VirtualBoxを使った場合のホスト側DISPLAYを参照する設定
    export DISPLAY=$(netstat -rn | grep "^0.0.0.0 " | cut -d " " -f10):0.0
    export MSYS=winsymlinks:lnk
    export VTE_CJK_WIDTH=1
    :
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
IGNOREEOF=100


export PATH
export LANG
export LESSCHARSET
export TERM
export GTK_IM_MODULE
export XMODIFIERS
export QT_IM_MODULE
export IGNOREEOF

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/vagrant/.sdkman"
[[ -s "/home/vagrant/.sdkman/bin/sdkman-init.sh" ]] && source "/home/vagrant/.sdkman/bin/sdkman-init.sh"
