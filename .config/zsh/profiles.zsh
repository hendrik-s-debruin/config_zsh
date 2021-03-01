# ========================== Setup the profile system ==========================
# File where loaded profiles are listed
PROFILES_DIR=/tmp/$(whoami)_profiles
ZSH_PROFILES_FILE=$PROFILES_DIR/profiles

# Directory where profiles can be saved for later loading
ZSH_LOCAL_PROFILES_DIR=~/.config/zsh/profiles

# If the loaded profiles file does not exist, create it
if [ ! -d $PROFILES_DIR ]; then
	mkdir -p $PROFILES_DIR
fi
if [ ! -f $ZSH_PROFILES_FILE ]; then
	touch $ZSH_PROFILES_FILE
fi

# Source each profile that has been loaded
for profile in `cat $ZSH_PROFILES_FILE`
do
	source $ZSH_LOCAL_PROFILES_DIR/$profile.zsh
done

# ======================= Adding profiles to the session =======================
# Function to load a profile for this and all subsequent shells
# Usage: setenv <profile name>
function setenv() {
	# Sanitise input
	if [ $# -ne 1 ]; then
		echo "Usage: setenv <profile name>"
		return 1
	fi

	profile=$1

	# Check that the profile file exists
	profile_file=$ZSH_LOCAL_PROFILES_DIR/$profile.zsh
	if [ ! -f $profile_file ]; then
		echo "Error: $profile_file does not exist!"
		return 1
	fi

	# Check that the profile has not been loaded
	profile_loaded=$(grep <$ZSH_PROFILES_FILE $profile)
	# echo "profile found: \"$profile_loaded\""
	if [ "$profile_loaded" != "" ]; then
		echo "profile already loaded"
		return 1
	fi

	# Register that the profile should be loaded, and load it
	echo $profile >> $ZSH_PROFILES_FILE
	source $profile_file
}

function _setenv() {
	local -a profiles
	profiles=("${(@f)$(ls $ZSH_LOCAL_PROFILES_DIR | sed 's/.zsh//')}")
	_describe 'profile' profiles
}

compdef _setenv setenv

# ===================== Removing profiles from the session =====================
function unsetenv() {
	# Sanitise input
	if [ $# -eq  0 ]; then
		echo "Clearing all profiles"
		cat /dev/null > $ZSH_PROFILES_FILE
		return
	fi

	if [ $# -ne  1 ]; then
		echo "Usage: unsetenv [profile name]"
	fi

	profile=$1

	# Check that the profile was loaded
	profile_to_unload=$(grep <$ZSH_PROFILES_FILE $profile)
	if [ "$profile_to_unload" = "" ]; then
		echo "profile $profile not loaded"
		return 1
	fi

	# Unload the profile for future terminals
	sed --in-place "/$profile/d" $ZSH_PROFILES_FILE
}

function _unsetenv() {
	local -a profiles
	profiles=("${(@f)$(cat $ZSH_PROFILES_FILE)}")
	_describe 'profile' profiles
}

compdef _unsetenv unsetenv

# =========================== Display active profiles ==========================
function getenv() {
	cat $ZSH_PROFILES_FILE
}

# =================================== Cleanup ==================================
unset PROFILES_DIR
