# This file contains all the aliases for the zsh shell

# ==============================================================================
# Reload Config
# ==============================================================================
alias rebash='source ~/.zshrc'

# ==============================================================================
# Mimic commands from other command line applications
# ==============================================================================
alias quit="exit"
alias :q="exit"
alias :q!="exit"
alias q="exit"
alias clc="clear"

# ==============================================================================
# Edit specific files
# ==============================================================================
alias vimrc="vim ~/.vimrc"
alias i3rc='vim ~/.config/i3/config'
alias rc="vim ~/.zshrc"
alias zshrc="vim ~/.zshrc"
alias gitrc="vim ~/.gitconfig"
alias gdbrc="vim ~/.gdbinit"

# ==============================================================================
# Prettify standard commands
# ==============================================================================
alias grep='grep --colour'
alias ls="ls --color"
alias ccat='cat | highlight -O ansi'
alias tree="tree -C"
alias treeless="/usr/bin/tree | less"

# ==============================================================================
# Tools
# ==============================================================================
alias calculator='octave-cli'
alias calc='octave-cli'
alias texlive="tllocalmgr"
alias cmatlab="rlwrap -a matlab -nodesktop -nosplash"
alias top="htop"
alias ast="clang -Xclang -ast-dump -fsyntax-only"
alias gitgrs="git log --graph --oneline --branches --color | head -n 50"
alias glog="git log | vim -"
alias g="git"
alias r="ranger"
alias v="vim"

# ==============================================================================
# Convenience
# ==============================================================================
alias gping="ping www.google.com"
alias pull="git pull"
alias count="wc -l"
alias cnt="wc -l"
alias cclear="clear && archey3 -c cyan"
alias less=vimpager
alias cd..='cd ..'
alias copy='xclip -selection clipboard'
alias xmod='xmodmap ~/.Xmodmap'
alias CAPS='xdotool key Caps_Lock'
alias caps='CAPS'
alias k='figlet k'
alias grsr='git log --oneline --graph --decorate --branches --remotes'

# ==============================================================================
# System
# ==============================================================================
alias reboot="~/bin/reboot"
alias hidemouse="unclutter -grab -idle 1 &"
alias unhidemouse="killall unclutter"
alias make!="make -j$(nproc)"
alias startx="ssh-agent startx"

# ==============================================================================
# ssh
# ==============================================================================
alias ssh-keygen-comment="ssh-keygen -C $(whoami)@$(hostname)-$(date -I)"
