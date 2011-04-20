#!/bin/bash

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

# colours
COLOUR_WHITE='\033[1;37m'
COLOUR_LIGHTGRAY='033[0;37m'
COLOUR_GRAY='\033[1;30m'
COLOUR_BLACK='\033[0;30m'
COLOUR_RED='\033[0;31m'
COLOUR_LIGHTRED='\033[1;31m'
COLOUR_GREEN='\033[0;32m'
COLOUR_LIGHTGREEN='\033[1;32m'
COLOUR_BROWN='\033[0;33m'
COLOUR_YELLOW='\033[1;33m'
COLOUR_BLUE='\033[0;34m'
COLOUR_LIGHTBLUE='\033[1;34m'
COLOUR_PURPLE='\033[0;35m'
COLOUR_PINK='\033[1;35m'
COLOUR_CYAN='\033[0;36m'
COLOUR_LIGHTCYAN='\033[1;36m'
COLOUR_DEFAULT='\033[0m'

function prompt_command() {
  local scm=""
  local changes=$COLOUR_GREEN
  local branch=""
  # check for git
  if git status &> /dev/null; then
    branch="`git branch --no-color | sed 's/^\* //g'`"
    if git status -s | grep -q '^[[:space:]][MA] '; then
      changes=$COLOUR_RED
    fi
    scm=" ${changes}\]${branch}${COLOUR_DEFAULT}\]"
  fi
  # check for subversion
  if svn info &> /dev/null; then
    branch="`svn info | grep Revision: | awk '{ print $2; }'`"
    if svn st --ignore-externals | grep -v '^X.....' | grep -v '^....S' > /dev/null; then
      changes=$COLOUR_RED
    fi
    scm=" ${changes}\]r${branch}${COLOUR_DEFAULT}\]"
  fi

  # export PS1
  PS1="${HOST_COLOUR}"'\]\u@\h'"${COLOUR_DEFAULT}"'\]:'"${COLOUR_RED}"'\]\w'"${COLOUR_DEFAULT}"'\]$ '

  # set the title
  case "$TERM" in
  xterm*|rxvt*)
    echo -ne "\033]0;${USER}@$(hostname -s): ${PWD/$HOME/~}\007" ;;
  esac
}

# colour of prompt per hostname
case "`hostname -s`" in
pc-4e43-0) HOST_COLOUR=$COLOUR_LIGHTBLUE ;;
ch*) HOST_COLOUR=$COLOUR_YELLOW ;;
schwa*) HOST_COLOUR=$COLOUR_WHITE ;;
tim-macbook|wifi-tdaw3088|laptop-tdaw3088) HOST_COLOUR=$COLOUR_GREEN ;;
tim-imac) HOST_COLOUR=$COLOUR_PURPLE ;;
*) HOST_COLOUR=$COLOUR_CYAN ;;
esac

PROMPT_COMMAND=prompt_command

# OS specific settings
case "`uname`" in
Darwin)
  alias ls='ls -G' 
  alias top='top -ocpu -Otime'
  export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home"
  export MACOSX_DEPLOYMENT_TARGET=10.6
  export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/opt/local/bin:/opt/local/sbin:/opt/local/lib/postgresql84/bin:${PATH}"
  ;;
*)
  alias ls='ls --color' 
  ;;
esac

alias ll='ls -lahF'
alias l='ll'
alias grep='grep --color'
alias egrep='egrep --color'
alias less='less -R'

export EDITOR=vim
export PAGER=less

export PATH="$HOME/bin:${PATH}"
