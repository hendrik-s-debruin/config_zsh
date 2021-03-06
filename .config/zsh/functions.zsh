# ==============================================================================
# Startup and Shutdown
# ==============================================================================
function shutdown() {
	# Make sure TMUX isn't running in the background somewhere
	tmux ls 2>> /dev/null 1>>/dev/null
	local tmux_ret=$?
	if (( $tmux_ret == 0  )); then
		echo tmux is running, not shutting down
		return -1
	fi

	# Play Shutdown sound
	if [ $TERM != "linux" ]; then # If I'm running inside x
			sleep 1
			mplayer $HOME/.config/i3/shutdown.mp3 2> /dev/null 1> /dev/null
			sleep 0.5
	fi

	/usr/sbin/shutdown now
}

function reboot() {
	if [ $TERM != "linux" ]; then # If I'm running inside x
			mplayer $HOME/.config/i3/shutdown.mp3 > /dev/null
	fi

	reboot
}

# ==============================================================================
# Sudo previous command
# ==============================================================================
function please() {
	cmd=$(fc -ln -1)
	cmd="sudo "$cmd
	echo -n "execute '$cmd'? "
	read response
	if [[ $response =~ ^[Yy]$ ]]; then
		eval $cmd
	fi
}

# ==============================================================================
# File Manager
# ==============================================================================
function ranger() {
	/usr/bin/ranger --choosedir=/tmp/RANGERDIR
	cd $(cat /tmp/RANGERDIR)
}

# ==============================================================================
# Project Tree
# ==============================================================================
function treeproj {
	if ! proj_dir=$(git rev-parse --show-toplevel 2> /dev/null); then
		echo not a project directory
		return
	fi
	local ignore=$(cat $proj_dir"/.gitignore" | tr '\n' '|' | sed 's_/|_|_g' | sed 's/|$//')
	tree -C -I $ignore
}

# ==============================================================================
# Make directory and change to it
# ==============================================================================
function chmk {
	mkdir -p $1 && cd $1
}

# ==============================================================================
# Change to ranger bookmarks
# ==============================================================================
function c {

	local ranger_bookmarks="$HOME/.config/ranger/bookmarks"
	local zsh_bookmarks="$HOME/.config/zsh/bookmarks"

	[ -f $ranger_bookmarks ] || touch "$ranger_bookmarks"
	[ -f $zsh_bookmarks ]    || touch "$zsh_bookmarks"

	function print_bookmarks {
		echo "=================="
		echo Ranger Bookmarks
		echo "=================="
		cat $ranger_bookmarks
		echo "=================="
		echo Zsh Bookmarks
		echo "=================="
		cat $zsh_bookmarks
		echo "=================="
	}

	if [[ $@ == "" ]]; then
		print_bookmarks
		return
	fi

	local bookmark=$(grep "^$1" <$ranger_bookmarks)
	if [[ $bookmark == "" ]]; then
		local bookmark=$(grep "^$1:" <$zsh_bookmarks)
		if [[ $bookmark == "" ]]; then
			echo Bookmark not found
			print_bookmarks
			return 1
		fi
	fi

	cd $(echo $bookmark | awk -F ':' '{print $2}')
}

function _c() {
	function _commands {
		local -a commands
		commands=(
			$(cat $HOME/.config/ranger/bookmarks)
			$(cat $HOME/.config/zsh/bookmarks)
		)

		_describe 'command' commands
	}

	_arguments -C \
		"1: :_commands" \
		"*::arg:->args"
}

compdef _c c

_fzf_complete_c() {
	_fzf_complete  --prompt="Bookmark> " "c " "$@" < <(
		cat $HOME/.config/ranger/bookmarks | awk -F ':' '{print $1}'
		cat $HOME/.config/zsh/bookmarks | awk -F ':' '{print $1}'
	)
}

# ==============================================================================
# Create Bookmark
# ==============================================================================
function m {

	if [[ $@ == "" ]]; then
		echo no mark to set
		return
	fi

	local ranger_bookmarks="$HOME/.config/ranger/bookmarks"
	local zsh_bookmarks="$HOME/.config/zsh/bookmarks"

	[ -f $ranger_bookmarks ] || touch "$ranger_bookmarks"
	[ -f $zsh_bookmarks ]    || touch "$zsh_bookmarks"

	if [[ ${#1} == 1 ]]; then # length of argument = 1
		local bookmarks_file=$ranger_bookmarks
	else
		local bookmarks_file=$zsh_bookmarks
	fi

	sed -i "s?$1:.*\$?$1:$(pwd)?" $bookmarks_file

	if ! grep "^$1:*" $bookmarks_file > /dev/null; then
		echo "$1:$(pwd)" >> $bookmarks_file
	fi
}

# ==============================================================================
# Manpage Width
# ==============================================================================
function man {
	if [ $COLUMNS -gt 80 ]; then
		COLUMNS=80 /usr/bin/man $@
	else
		/usr/bin/man $@
	fi
}

# ==============================================================================
# Sorting by length
# ==============================================================================
function lensort() {
	if (( $# > 0 )) && [ $1 == "-r" ]
	then
		awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }'
	else
		awk '{ print length(), $0 | "sort -n -r | cut -d\\  -f2-" }'
	fi
}

# ==============================================================================
# Find Symbols in Libraries
# ==============================================================================
function findsym() {
	if [[ $# -ne 1 ]]; then
		echo "usage: findsym <sym>"
		return -1
	fi
	for i in $(find . -name "*.so" -o -name "*.a")
	do
		nm $i 2>/dev/null | awk '{print "'$i' --- " $0}' | grep $1
	done
}

# ==============================================================================
# Strip Comments from C/C++ files
# ==============================================================================
function cstrip() {
	gcc -fpreprocessed -dD -E -P $1 | clang-format -style=file -fallback-style=LLVM
}

# ==============================================================================
# Execute command on file change
# ==============================================================================
function onchange() {
	if [[ $# -eq 0 ]]; then
		echo "Usage: onchange <filename> <command> [args ... ]"
		return -1
	fi
	while ! inotifywait -e modify $1; do
		${@: 2}
	done
}

# ==============================================================================
# Passwords
# ==============================================================================
function passstore_encrypt() {
	if [[ ! $# -eq 1 ]]; then
		echo "Usage: passstore_encrypt <hash>"
		return -1
	fi
	HASH=$1

	tar -cz ~/.password-store | \
		gpg --sign --encrypt -r $HASH \
		> pwd.tar.gz.gpg
}

# -=============================================================================
# Disk Usage
# ==============================================================================
# Find high disk usage
function duh() {
	if [ $# -eq 0 ]; then
		let items=5
	else
		let items=$1
	fi

	du -a . 2> /dev/null | \
		sort -n -r |       \
		head -n $items |   \
		awk '{print $2}'
}

# ==============================================================================
# Update System
# ==============================================================================
function update() {
	# Check to see if there is any news
	news=$(yay --show --news)

	# If there is news, return early unless specified '-f'
	if [[ $news ]]; then
		echo $news
		if [[ $# -eq 0 || $1 -ne "-f" ]]; then
			return
		fi
	fi

	# Run the update command
	yay -Syu --sudoloop
}
