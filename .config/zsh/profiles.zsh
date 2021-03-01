function profile() {
	# ============================= Module Globals =============================
	# File where loaded profiles are listed
	PROFILES_DIR=/tmp/$(whoami)_profiles
	PROFILES_FILE=$PROFILES_DIR/profiles

	# Directory where profiles can be saved for later loading
	LOCAL_PROFILES_DIR=~/.config/zsh/profiles

	# All subcommands in this module
	subcomands=( )

	# All subcommands that the user will see through tab completion
	user_subcommands=( )

	# =============================== Subcommands ==============================
	function __register_subcommand() {
		# Store all commands in this array
		subcommands=( ${subcommands[@]} $1)

		# User-visible commands do not start with two underscores
		if [[ ! $1 =~ "^__" ]]; then
			user_subcommands=( ${user_subcommands[@]} $1 )
		fi
	}
	# ------------------------ Start the Profile System ------------------------
	function __init() {
		# If the loaded profiles file does not exist, create it
		if [ ! -d $PROFILES_DIR ]; then
			mkdir -p $PROFILES_DIR
		fi
		if [ ! -f $PROFILES_FILE ]; then
			touch $PROFILES_FILE
		fi
	}
	__register_subcommand "__init"

	# ---------- Test whether the profile system has been initialised ----------
	function __is_initialised() {
		if [ -f $PROFILES_FILE ]; then
			# 0 means true and 1 means false because shells are weird magical
			# obscure beasts
			return 0
		else
			return 1
		fi
	}
	__register_subcommand "__is_initialised"

	# ----------------------- Source All Active Profiles -----------------------
	function __load() {
		for profile in `cat $PROFILES_FILE`
		do
			source $LOCAL_PROFILES_DIR/$profile.zsh
		done
	}
	__register_subcommand "__load"

	# --------------------------- List user commands ---------------------------
	function __list_user_commands() {
		echo $user_subcommands
	}
	__register_subcommand __list_user_commands

	# --------------------------- Activate a Profile ---------------------------
	function activate() {
		# Sanitise input
		if [ $# -eq 0 ]; then
			echo "Usage: activate <profile name> [profile name...]"
			return 1
		fi

		for profile in $@
		do
			# Check that the profile file exists
			profile_file=$LOCAL_PROFILES_DIR/$profile.zsh
			if [ ! -f $profile_file ]; then
				echo "Error: $profile_file does not exist!"
				continue
			fi

			# Check that the profile has not been loaded
			profile_loaded=$(grep <$PROFILES_FILE $profile)
			# echo "profile found: \"$profile_loaded\""
			if [ "$profile_loaded" != "" ]; then
				echo "Profile $profile already loaded"
				continue
			fi

			# Register that the profile should be loaded, and load it
			echo $profile >> $PROFILES_FILE
			source $profile_file
		done
	}
	__register_subcommand "activate"

	# ---------------------- Deactivate an active profile ----------------------
	function deactivate() {
		# Clear all profiles if nothing specifed
		if [ $# -eq  0 ]; then

			echo "Clearing all profiles"
			cat /dev/null > $PROFILES_FILE

		# Else clear all the profiles that are specified
		else

			for profile in $@
			do
				# Check that the profile was loaded
				profile_to_unload=$(grep <$PROFILES_FILE $profile)
				if [ "$profile_to_unload" = "" ]; then
					echo "profile $profile not loaded"
					continue
				fi

				# Unload the profile for future terminals
				sed --in-place "/$profile/d" $PROFILES_FILE
			done

		fi

	}
	__register_subcommand "deactivate"

	# -------------------------- List Active Profiles --------------------------
	function ls-active() {
		cat $PROFILES_FILE
	}
	__register_subcommand "ls-active"

	# ------------------------- List Installed Profiles ------------------------
	function ls-installed() {
		ls $LOCAL_PROFILES_DIR | sed 's/\.zsh$//'
	}
	__register_subcommand "ls-installed"

	# ----------------------------- Edit a Profile -----------------------------
	function edit() {
		if [ $# -ne  1 ]; then
			echo "Usage: $0 <profile name>"
			return 1
		fi

		profile=$1

		$EDITOR $LOCAL_PROFILES_DIR/$profile.zsh
	}
	__register_subcommand "edit"

	# ============================ Call Subcommands ============================
	if [ $# -ne 0 ]; then
		# If the subcommand passed to this function exists
		if (( $subcommands[(Ie)$1])); then
			# call the subcommand with all of it arguments
			$@
		else
			echo "Error: $1 is not a recognised subcommand"
			echo "Available commands: ${user_subcommands[@]}"
		fi
	else
		echo "Available commands: ${user_subcommands[@]}"
	fi
}

# =============== Initialise the Profile System for This Terminal ==============
if ( ! profile __is_initialised ); then
	profile __init
fi
profile __load

# =============================== Tab Completion ===============================
function _profile() {
	local line

	function _commands() {
		subcommands=(
			$(profile __list_user_commands)
		)

		_describe 'command' subcommands
	}

	function _installed() {
		profiles=("${(@f)$(ls $LOCAL_PROFILES_DIR | sed 's/.zsh//')}")
		_describe 'profile' profiles
	}

	function _active() {
		profiles=("${(@f)$(cat $PROFILES_FILE)}")
		_describe 'profile' profiles
	}

	_arguments -C \
		"1: :_commands" \
		"*::arg:->args"

	case $line[1] in
		activate)
			_installed
		;;
		deactivate)
			_active
		;;
		edit)
			_installed
		;;
	esac
}

compdef _profile profile
