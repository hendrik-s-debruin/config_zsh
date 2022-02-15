# This file sets any preferred environment variables for specific programs
RANGER_LOAD_DEFAULT_RC=false

# Tell FZF to ignore files in .gitignore
export FZF_DEFAULT_COMMAND='ag -p ~/.gitignore_global -g ""'

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY

# Remote storage
export RCLONE_PASSWORD_COMMAND="pass rclone/config"

# Default configuration when building with CMake
export CMAKE_BUILD_TYPE=Debug

# how long pass should keep a password on the clipboard, seconds
export PASSWORD_STORE_CLIP_TIME=10

export MANPAGER=vimpager

export VIRTUAL_ENV_DISABLE_PROMPT=1
source virtualenvwrapper.sh
