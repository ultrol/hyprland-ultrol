#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Рип-скрипты (rice, vol, powermenu, screenshot …)
export PATH="$HOME/.local/bin:$PATH"
