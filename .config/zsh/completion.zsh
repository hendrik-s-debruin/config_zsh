#  ======================== Command Line History Search ==================== {{{

search_history() {
	BUFFER=$(history -t '%Y-%m-%d %H:%M:%S' 0 | grep -v 1969 | fzf +s +m -x --tac -q "$BUFFER" | awk '{print substr($0, index($0, $4))}')

	zle end-of-line
}
autoload search_history
zle -N search_history
bindkey '^r' search_history

# }}}

#  ================================ Completions ============================ {{{

autoload -Uz compinit
compinit

# Use fzf to complete command line arguments. NOTE: this needs to be kept after
# compinit, but before other plugins are loaded
source ~/.config/zsh/fzf-tab/fzf-tab.plugin.zsh

# expand '**' to complete files
[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh

# suggestions based on command history
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# }}}
