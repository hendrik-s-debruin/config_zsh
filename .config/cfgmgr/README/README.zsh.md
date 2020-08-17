zsh Configuration
================================================================================

I use `zsh` as my preferred shell (honestly, why do people stick with Bash? Bash
is to Unix as Times New Roman is to MS Word).

Feel free to copy my config and let me know if you have any cool improvements. I
try to keep it fairly neat for the most part, and separate logical units into
different files. I have some `zsh` functions in my config that I find fairly
useful:

* `c` creates a bookmark in the current directory.
* `m` changes directory to a bookmark previously created by `c` or by my
  preferred file manager [`ranger`](https://github.com/ranger/ranger).
* `newsh` creates new terminals in the current directory and optionally runs a
  command in each spawned terminal. This is very useful for working with some
  ROS tools or with Docker.
* `findsym` recursively looks for native library archives or shared objects and
  within these looks for a given symbol. This is very useful when trying to
  debug link errors in C or C++.
* `please` repeats the previous command with `sudo` prepended.

Some of these functions even have nice `zsh` autocompletion.

I use different branches of this repository to track slightly different
configurations on different machines.

Installation
--------------------------------------------------------------------------------

You are free to manually copy all the files into place. However, I prefer using
[my configuration file
manager](https://github.com/hendrik-s-debruin/ConfigManager) to manage the
repository for me. To install this configuration using my tool:

```txt
# Clone the repository
cfgmgr clone zsh https://github.com/hendrik-s-debruin/config_zsh.git

# Install its files -- This makes sure you don't accidentally overwrite something
cfgmgr manage zsh reset HEAD ~
cfgmgr manage zsh checkout ~
```
