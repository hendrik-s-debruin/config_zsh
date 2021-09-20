# This file configures the tab completion of the zsh shell

# plugin to add predictive suggestions
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Fzf completions
[ -f /usr/share/fzf/completion.zsh              ] && source /usr/share/fzf/completion.zsh              # arch install path
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh # ubuntu install path

# Search history
search_history() {
	BUFFER=$(history -t '%Y-%m-%d %H:%M:%S' 0 | grep -v 1969 | fzf +s +m -x --tac -q "$BUFFER" | awk '{print substr($0, index($0, $4))}')

	zle end-of-line
}
autoload search_history
zle -N search_history
bindkey '^r' search_history

autoload -Uz compinit
compinit

zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' auto-description 'specyify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
