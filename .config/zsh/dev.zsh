# This file sets variables for the development environment of various languages

export RUST_BACKTRACE=1
export PATH=$PATH:~/.cargo/bin

export CMAKE_EXPORT_COMPILE_COMMANDS=ON
CONAN_ERROR_ON_OVERRIDE=True
source ~/programming/sdk/emscripten/emsdk/emsdk_env.sh 2> /dev/null

source /opt/ros/noetic/setup.zsh
