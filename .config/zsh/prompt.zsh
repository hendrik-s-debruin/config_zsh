setopt PROMPT_SUBST

# Not available for instance in docker containers, just use the default prompt
# there
if [ -f /sbin/python3 ]; then
	PS1='$(/sbin/python3 ~/.config/zsh/prompt.py --cols $COLUMNS --success_code $? --jobs $(jobs | wc -l))'
fi
