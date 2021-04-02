# Edit the command line in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd f edit-command-line
