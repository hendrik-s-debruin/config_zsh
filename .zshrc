# =================================== General ============================== {{{
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory autocd nomatch
unsetopt beep
bindkey -v
export EDITOR=vim

# }}}
# =============================== External Files =========================== {{{
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/alias.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/highlight.zsh
source ~/.config/zsh/prog_env.zsh
source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/dev.zsh
source ~/.config/zsh/bindings.zsh
source ~/.config/zsh/zsh_profiles/profiles.zsh
# }}}
#  ================================= Bookmarks ============================= {{{
# ~/.config/zsh/profiles
# ~/.zprofile
# }}}
# ============================== Startup Commands ========================== {{{
if [ $COLUMNS -ge 90 ] && [  $(tput lines) -ge 19 ]; then
	archey3 -c cyan
fi

activate_virtual_env

# Call "RUN='command vargs...' zsh" to run a command on zsh start
eval $RUN
# }}}
