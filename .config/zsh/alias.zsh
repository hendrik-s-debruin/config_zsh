#  =============================== Reload Config =========================== {{{
alias rebash='clear && source ~/.zshrc'
alias rb="rebash"
# }}}
#  ============ Mimic commands from other command line applications ======== {{{
alias quit="exit"
alias :q="exit"
alias :q!="exit"
alias q="exit"
alias clc="clear"
# }}}
#  ============================ Edit specific files ======================== {{{
alias vimrc="vim ~/.vimrc"
alias i3rc='vim ~/.config/i3/config'
alias i3conf='i3rc'
alias rc="vim ~/.zshrc"
alias zshrc="vim ~/.zshrc"
alias gitrc="vim ~/.gitconfig"
alias gdbrc="vim ~/.gdbinit"
alias muttrc="vim ~/.config/mutt/neomuttrc"
alias quterc="vim ~/.config/qutebrowser/config.py"
alias alacrittyrc="vim ~/.config/alacritty/alacritty.yml"
alias qtilerc="vim ~/.config/qtile/config.py"
alias dunstrc="vim ~/.config/dunst/dunstrc"
# }}}
#  ======================== Prettify standard commands ===================== {{{
alias grep='grep --colour'
alias ls="exa --icons --git"
alias lsi="exa --icons --git-ignore"
alias ccat='cat | highlight -O ansi'
alias tree="exa --tree --icons --git-ignore"
alias treeless="/usr/bin/tree | less"
# }}}
#  =================================== Tools =============================== {{{
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
alias mutt="neomutt"
alias t="taskwarrior-tui"
alias d="vimdiff"
alias h="htop"
alias wl="~/.config/wacom/setup left"
alias wr="~/.config/wacom/setup right"
# }}}
#  ================================ Convenience ============================ {{{
alias rdoc="rustup doc --book </dev/null &>/dev/null &; disown"
alias rstd="rustup doc --std </dev/null &>/dev/null &; disown"
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
alias lines="wc -l"
alias news="yay --show --news"
alias news!="yay --show --news --news"
alias cbase="git clone https://github.com/hendrik-s-debruin/cmake_base.git"
alias s="profile activate"
alias u="profile deactivate"
alias pe="profile edit"
alias p="profile"
alias ta="tmux attach -t"
alias tta="tmux attach -rt"
alias cryptopen="sudo cryptsetup luksOpen /dev/sda1 secret && sudo mount /dev/mapper/secret /mnt/secret"
alias cryptclose="sudo umount /mnt/secret && sudo cryptsetup luksClose secret"
alias python="bpython"
alias pi="bpython --interactive"
alias pt="pytest --verbose"
alias venv="mkvirtualenv -p /usr/bin/python3.7"
# }}}
#  ================================== System =============================== {{{
alias reboot="~/bin/reboot"
alias hidemouse="unclutter -grab -idle 1 &"
alias unhidemouse="killall unclutter"
alias make!="make -j$(nproc)"
# alias startx="ssh-agent startx"
alias suspend="systemctl suspend"
# }}}
#  ==================================== SSH ================================ {{{
alias ssh-keygen-comment="ssh-keygen -C $(whoami)@$(hostname)-$(date -I)"
# }}}
