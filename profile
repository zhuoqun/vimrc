#!/bin/bash

# if not running interactively, don't do anything
[ -z "$PS1" ] && return

export PS1="\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] "

alias ll='ls -lahF'
alias l='ll'
alias grep='grep --color'
alias egrep='egrep --color'
alias less='less -R'

export EDITOR=vim
export PAGER=less
