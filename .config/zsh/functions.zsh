# ==============================================================================
# Startup and Shutdown
# ==============================================================================
function shutdown() {
	# Make sure TMUX isn't running in the background somewhere
	tmux ls 2>> /dev/null 1>>/dev/null
	tmux_n_running=$?
	if [ $tmux_n_running == 0  ]; then
		echo tmux is running, not shutting down
		exit -1
	fi

	# Play Shutdown sound
	if [ $TERM != "linux" ]; then # If I'm running inside x
			sleep 1
			mplayer $HOME/.config/i3/shutdown.mp3 2> /dev/null 1> /dev/null
			sleep 0.5
	fi

	shutdown now
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
		local bookmark=$(grep "^$1" <$zsh_bookmarks)
		if [[ $bookmark == "" ]]; then
			echo Bookmark not found
			print_bookmarks
			return
		fi
	fi

	cd $(echo $bookmark | awk -F ':' '{print $2}')
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
# Launch a new shell
# ==============================================================================
function newsh() {
	# usage: newsh [number of shells] [startup commands]

	let MAX=1
	re='^[0-9]+$'
	if [[ $1 =~ $re ]]; then
		MAX=$1
		if [ $# -eq 2 ]; then
			startup_command=$2
		fi
	else
		startup_command=$1
	fi

	# Launch the terminals
	let INDEX=0
	while [ $INDEX -lt $MAX ]; do
		RUN=$startup_command i3-sensible-terminal >/dev/null 2>&1 &
		disown
		let INDEX=$INDEX+1
	done
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
