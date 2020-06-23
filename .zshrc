HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd nomatch
unsetopt beep
bindkey -v

# ==============================================================================
# External Files
# ==============================================================================
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/functions.zsh
source ~/.config/zsh/highlight.zsh
source ~/.config/zsh/prog_env.zsh
source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/alias.zsh
source ~/.config/zsh/dev.zsh

# ==============================================================================
# Startup Commands
# ==============================================================================
if [ $COLUMNS -ge 90 ]; then
	archey3 -c cyan
fi

# Call "RUN='command vargs...' zsh" to run a command on zsh start
eval $RUN
