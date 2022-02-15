# This file configures the prompt of the zsh shell

autoload -U colors && colors
setopt PROMPT_SUBST
PS1='$(prompt_whoami) '
PS1+='@'
PS1+=' $(hostname)'
PS1+=' $(prompt_pwd) '
PS1+='$(prompt_git)'
PS1+='$(prompt_job_count)'
PS1+='$(prompt_python_venv)'
PS1+='$(prompt_emoji)'
PS1+=' $(prompt_char) '

# ==============================================================================
# Build Prompt
# ==============================================================================
# TODO do not hard code colours, read from Xresources
precmd () {
	exit_status=$?
}

# ------------------------------------------------------------------------------
# git
# ------------------------------------------------------------------------------
function prompt_git {

	# Git Stuff
	local output=`git branch 2>/dev/null`
	if [[ $output != "" ]]; then
		local branch_name=`echo $output | grep '*' | awk '{ print $2}'`
		if [[ `git status --porcelain` ]]; then
			# There are changes on the branch
			# echo `color_string "[$branch_name]" bf616a`
			echo "%{$fg[yellow]%}  $branch_name "
		else
			# echo `color_string "[$branch_name]" a3be8c`
			echo "%{$fg[green]%}  $branch_name "
		fi
	else
		#echo not on branch
	fi
}

# ------------------------------------------------------------------------------
# pwd
# ------------------------------------------------------------------------------
function prompt_pwd {
	# echo $(color_string "%2~" ebcb8b)
	echo "%{$fg[yellow]%} %2~"
}

# ------------------------------------------------------------------------------
# whoami
# ------------------------------------------------------------------------------
function prompt_whoami {
	if [[ $exit_status == 0 ]]; then
		echo $(bold_string "$(whoami) ")
	else
		# echo $(bold_string $(color_string "$(whoami)" bf616a))" "
		echo "%{$fg[red]%}$(whoami)"
	fi
}

# ------------------------------------------------------------------------------
# jobcount
# ------------------------------------------------------------------------------
function prompt_job_count {
	local cnt=$(jobs | wc -l)
	if [[ $cnt != 0 ]]; then
		# echo $(color_string "[$cnt]" ebcb8b)
		echo "%{$fg[yellow]%}[$cnt]"
	fi
}

# ------------------------------------------------------------------------------
# prompt char
# ------------------------------------------------------------------------------
function prompt_char {
	if [[ $exit_status == 0 ]]; then
		# success
		# echo $(bold_string $(color_string '> ' a3be8c))
		echo "%{$fg[green]%}λ"
	else
		# failure
		# echo $(bold_string $(color_string "[$exit_status]>" bf616a))
		echo "%{$fg[red]%}[$exit_status]λ"
	fi
}

# ------------------------------------------------------------------------------
# Smiley Prompt
# ------------------------------------------------------------------------------
function prompt_emoji {
	if [[ $exit_status != 0 ]]; then
		smileys=(
			$(cat ~/.config/zsh/prompt_on_error)
		)

		index=$(head -200 /dev/urandom | cksum | awk '{print $1}')
		index=$((1 + $index % ${#smileys[@]}))
		# echo $(color_string ${smileys[$index]} bf616a)" "
		echo "%{$fg[red]%}${smileys[$index]}"

	fi
}
function bold_string {
	#echo -e "\033[1m$1\033[0m"
	echo $1
}

# ------------------------------------------------------------------------------
# Python Virtual Environment
# ------------------------------------------------------------------------------
function prompt_python_venv {
	if [[ "$VIRTUAL_ENV" != "" ]]; then
		venv_name=$(basename $VIRTUAL_ENV)
		echo "%{$fg[white]%} $venv_name"
	fi
}
