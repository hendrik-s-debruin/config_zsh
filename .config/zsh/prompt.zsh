# This file configures the prompt of the zsh shell

setopt PROMPT_SUBST

PS1='$(/sbin/python3 ~/.config/zsh/prompt.py $COLUMNS $?)'

# TODO port this
# function prompt_job_count {
# 	local cnt=$(jobs | wc -l)
# 	if [[ $cnt != 0 ]]; then
# 		# echo $(color_string "[$cnt]" ebcb8b)
# 		echo "%{$fg[yellow]%}[$cnt]"
# 	fi
# }

# TODO port this
# function prompt_emoji {
# 	if [[ $exit_status != 0 ]]; then
# 		smileys=(
# 			$(cat ~/.config/zsh/prompt_on_error)
# 		)

# 		index=$(head -200 /dev/urandom | cksum | awk '{print $1}')
# 		index=$((1 + $index % ${#smileys[@]}))
# 		# echo $(color_string ${smileys[$index]} bf616a)" "
# 		echo "%{$fg[red]%}${smileys[$index]}"

# 	fi
# }
