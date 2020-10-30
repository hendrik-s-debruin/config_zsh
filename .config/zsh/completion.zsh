# This file configures the tab completion of the zsh shell

# plugin to add predictive suggestions
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Fzf completions
source ~/.config/zsh/fzf-completion/completion.zsh

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
