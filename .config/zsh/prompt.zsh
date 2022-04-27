setopt PROMPT_SUBST

PS1='$(/sbin/python3 ~/.config/zsh/prompt.py --cols $COLUMNS --success_code $? --jobs $(jobs | wc -l))'
