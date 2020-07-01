# This file specifies highlighting styles for commands in the zsh shell

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern line)

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[unknown]='fg=129,bold'                       # orange
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=53,bold'                  # purple4
ZSH_HIGHLIGHT_STYLES[builtin]='fg=62, bold'                       # slateblue
ZSH_HIGHLIGHT_STYLES[function]='fg=69,bold'                       # cornflowerblue
ZSH_HIGHLIGHT_STYLES[command]='fg=69,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=69,bold,underline'
ZSH_HIGHLIGHT_STYLES[path]='fg=178,bold'                          # gold
ZSH_HIGHLIGHT_STYLES[globbing]='fg=88'                            # darkred
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=15,bold'           # white
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=15,bold,underline' # white
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=88,bold'           # darkred
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=99,bold'         # SlateBlue
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=99'              # SlateBlue
ZSH_HIGHLIGHT_STYLES[assign]='fg=15,bold,underline'               # white
setopt  INTERACTIVE_COMMENTS                                      # needed for next line
ZSH_HIGHLIGHT_STYLES[comment]='fg=30'                             # Turquoise 4
ZSH_HIGHLIGHT_STYLES[redirection]='fg=88'                         # DarkRed
ZSH_HIGHLIGHT_STYLES[default]='fg=111'                            # SkyBlue2

ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_STYLES[line]='bold'

source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
