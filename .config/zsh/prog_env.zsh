# This file sets any preferred environment variables for specific programs
RANGER_LOAD_DEFAULT_RC=false

# gpg-agent
GPG_TTY=$(tty)
export GPG_TTY

# Remote storage
export RCLONE_PASSWORD_COMMAND="pass rclone/config"

# how long pass should keep a password on the clipboard, seconds
export PASSWORD_STORE_CLIP_TIME=10
