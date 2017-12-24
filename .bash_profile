#!/bin/bash

# add the personal /bin directory to the PATH variable
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi


# Generate a Password with easy to type Characters
# Usage: genpasswd <LENGTH>
genpasswd() {
  local l=$1
  [ "$l" == "" ] && l=16
  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

# Strip comments and empty lines from Configuration Files
# Usage: nocomment "/path/to/config.file"
nocomment() {
  [ $# -lt 1 ] && return; egrep -v "^[[:cntrl:] ]*[#;]|^$" $1;
}

# Show Numeric Permmisions of a File
# Info: https://askubuntu.com/questions/152001/how-can-i-get-octal-file-permissions-from-command-line#152003
# Usage: numperms <FILES>
numperms(){
  stat -c "%a %n" "$@"
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

### Aliases ###

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias ..="cd .."
alias ...="cd ../.."
alias cd..="cd .."

### ls customization ###

export LS_COLORS='di=34:ln=36:so=0:pi=0:ex=32:bd=0:cd=0:su=0:sg=0:tw=34:ow=34:'
alias ls="ls --color"
alias l="ls -lh"
alias ll="ls -lah"

### colorized Bash Prompt ###

export CLICOLOR=1
if [[ $EUID -eq 0 ]]; then
  # root Prompt
  export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[31m\]\u\[\033[m\]@\[\033[33m\]\h:\[\033[33;1m\]\w\[\033[m\]# "
else
  # normal user Prompt
  export PS1="\[\033[35m\]\t\[\033[m\]-\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "
fi

### grep customization ###

alias grep="GREP_COLOR='1;31' grep --color -Hn"

### History ###

export HISTCONTROL=ignoredups
export HISTFILESIZE=30000
export HISTIGNORE="ls:cd:cd..:[bf]g:exit:..:...:l:ll"
export HISTTIMEFORMAT="%d/%m/%y %T "
shopt -s histappend

### Autocompletion ###

# make Bash tab complete case insensitively
bind "set completion-ignore-case on"
