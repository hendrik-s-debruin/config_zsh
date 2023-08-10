ZSH_COMMAND_NOTIFY__THRESHOLD_TIME=60
ZSH_COMMAND_NOTIFY__FAIL_CATEGORY="notify-this-failure"
ZSH_COMMAND_NOTIFY__SUCCESS_CATEGORY="notify-this-success"
ZSH_COMMAND_NOTIFY__IGNORE_COMMANDS=(
	ranger
	ssh
	vim
	c
	tmux
	notify-this
	git
)

function _enable() {
	autoload -Uz add-zsh-hook

	add-zsh-hook preexec _track_command
	add-zsh-hook precmd  _report_command_completed

	# when the terminal is started, zsh runs precmd. This leads to an error
	# message since we have not yet run track_command. Manually run this. It'll
	# get ignored, since this will be faster than the threshold time.
	_track_command
}

function _track_command() {
	# Parameter $1 is the command the user typed, but may be empty if history is
	# disabled
	#
	# Paramter $2 is always available. It is the command with all aliases
	# expanded (function bodies are elided)
	#
	# Parameter $3 contains the full text of the command to be executed
	#
	# We care about parmater $1, but substitute $2 if it is not available
	export ZSH_COMMAND_NOTIFY__START_TIME_SECONDS="$(date "+%s")"
	export ZSH_COMMAND_NOTIFY__COMMAND=${1:-$2}
	export ZSH_COMMAND_NOTIFY__COMMAND_EXPANDED=$2
	export ZSH_COMMAND_NOTIFY__COMMAND_FULL=$3
}

function _end_tracking() {
	unset ZSH_COMMAND_NOTIFY__START_TIME_SECONDS
	unset ZSH_COMMAND_NOTIFY__COMMAND
	unset ZSH_COMMAND_NOTIFY__COMMAND_EXPANDED
	unset ZSH_COMMAND_NOTIFY__COMMAND_FULL
}

function _report_command_completed() {
	local exit_code="$?"
	local END_SECONDS="$(date "+%s")"
	local duration=$(( $END_SECONDS - $ZSH_COMMAND_NOTIFY__START_TIME_SECONDS ))

	if $(_should_print_command "$ZSH_COMMAND_NOTIFY__COMMAND_EXPANDED"); then
		if (( duration >= $ZSH_COMMAND_NOTIFY__THRESHOLD_TIME )); then
			if (( exit_code == 0 )); then
				notify-send                                          \
					--category=$ZSH_COMMAND_NOTIFY__SUCCESS_CATEGORY \
					--app-name=$ZSH_COMMAND_NOTIFY__COMMAND_EXPANDED \
					success
			else
				notify-send                                          \
					--category=$ZSH_COMMAND_NOTIFY__FAIL_CATEGORY    \
					--app-name=$ZSH_COMMAND_NOTIFY__COMMAND_EXPANDED \
					fail
			fi
		fi
	fi

	_end_tracking
}

function _should_print_command() {
	# iterate over each word in the string
	for word in ${=1}; do
		if ! $(_expression_sets_environment_variable $word); then

			if $(_command_in_ignore_list $word); then
				return 1
			else
				return 0
			fi

		fi
	done

	# if we get here, we should not print the command
	return 1
}

function _expression_sets_environment_variable() {
	# if we have the pattern FOO=BAR, then we are setting an environment
	# variable
	if [[ $1 =~ '[^\s]+=[^\s]+' ]]; then
		return 0
	else
		return 1
	fi
}

function _command_in_ignore_list() {
	# very terrible syntax to determine if an element is in an array
	#
	# shell scripting is ... really fun ... isn't it?
	if [[ ${ZSH_COMMAND_NOTIFY__IGNORE_COMMANDS[(ie)$1]} -le ${#ZSH_COMMAND_NOTIFY__IGNORE_COMMANDS} ]]; then
		return 0
	else
		return 1
	fi
}

_enable
