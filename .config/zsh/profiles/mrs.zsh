# ==============================================================================
# Source Ros
# ==============================================================================
source /opt/ros/noetic/setup.zsh
source ~/mrs_workspace/devel/setup.zsh
# source ~/Documents/waterbird_mrs_tracker/devel/setup.zsh
source ~/Documents/waterbird++_mrs_tracker/devel_release/setup.zsh
# source ~/Documents/waterbird_mrs/devel/setup.zsh
# source ~/Documents/waterbird++_mrs/devel/setup.zsh

#  =============================================================================
#  Convencience Aliases
#  =============================================================================
alias generate_compile_commands="jq -s 'map(.[])' build/**/compile_commands.json > compile_commands.json"
alias b="catkin build"
alias bt="catkin build --this"

function waterbird() {
	dir=$(pwd)
	cd ~/Documents/waterbird_mrs/src/
	./start.sh
	cd $dir
}

alias w=waterbird

function waterbird_tracker() {
	dir=$(pwd)
	cd ~/Documents/waterbird_mrs_tracker/src/
	./start.sh
	cd $dir
}

alias wt=waterbird_tracker

function build_waterbird() {
	dir=$(pwd)
	cd ~/Documents/waterbird_mrs/src/
	catkin build --this
	cd $dir
}

alias bw=build_waterbird

function build_waterbird_tracker() {
	dir=$(pwd)
	cd ~/Documents/waterbird_mrs_tracker/src/
	catkin build --this
	cd $dir
}

alias bwt=build_waterbird_tracker

function change_to_waterbird() {
	rosservice call /uav1/control_manager/switch_controller waterbird_mrs
}

alias cw=change_to_waterbird

function change_to_waterbird_tracker() {
	rosservice call /uav1/control_manager/switch_tracker waterbird_mrs_tracker
}

alias cwt=change_to_waterbird_tracker

# ==============================================================================
# Extracts from MRS Shell Additions
# ==============================================================================

# disable gitman caching
export GITMAN_CACHE_DISABLE=1

# =============================== MRS simulation ===============================

# smart way of creating alias for spawn_uav
spawn_uav() {
	rosrun mrs_simulation spawn $@
}

function _spawn_uav_zsh_complete()
{
	local opts
	reply=()
	opts=`rosrun mrs_simulation spawn --help | grep '  --' | awk '{print $1}'`
	reply=(${=opts})
}

compdef _spawn_uav_zsh_complete spawn_uav

# =============================== waitFor* macros ==============================

waitForRos() {
	until rostopic list > /dev/null 2>&1; do
		echo "waiting for ros"
		sleep 1;
	done
}

waitForSimulation() {
	until timeout 3s rostopic echo /gazebo/model_states -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for simulation"
		sleep 1;
	done
	sleep 1;
}

waitForSpawn() {
	until timeout 3s rostopic echo /mrs_drone_spawner/spawned -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for spawn"
		sleep 1;
	done
	sleep 1;
}

waitForOdometry() {
	until timeout 3s rostopic echo /$UAV_NAME/mavros/local_position/odom -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for odometry"
		sleep 1;
	done
}

waitForControlManager() {
	until timeout 3s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for control manager"
		sleep 1;
	done
}

waitForControl() {
	until timeout 3s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for control"
		sleep 1;
	done
	until timeout 3s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for odom_main"
		sleep 1;
	done
}

waitForMpc() {
	until timeout 3s rostopic echo /$UAV_NAME/control_manager/diagnostics -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for control"
		sleep 1;
	done
	until timeout 3s rostopic echo /$UAV_NAME/odometry/odom_main -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for odom_main"
		sleep 1;
	done
}

waitForOffboard() {
	until timeout 3s rostopic echo /$UAV_NAME/control_manager/offboard_on -n 1 --noarr > /dev/null 2>&1; do
		echo "waiting for offboard mode"
		sleep 1;
	done
}


waitForCompile() {
	while timeout 3s  ps aux | grep "catkin build" | grep -v grep > /dev/null 2>&1; do
		echo "waiting for compilation to complete"
		sleep 1;
	done
}

appendBag() {

	if [ "$#" -ne 1 ]; then
		echo ERROR: please supply one argument: the text that should be appended to the name of the folder with the latest rosbag file and logs
	else

		bag_adress=`readlink ~/bag_files/latest`

		if test -d "$bag_adress"; then

			appended_adress=$bag_adress$1
			mv $bag_adress $appended_adress
			ln -sf $appended_adress ~/bag_files/latest
			second_symlink_adress=$(sed 's|\(.*\)/.*|\1|' <<< $appended_adress)
			ln -sf $appended_adress $second_symlink_adress/latest

			echo Rosbag name appended: $appended_adress

		else
			echo ERROR: symlink ~/bag_files/latest does not point to a file! - $bag_adress
		fi
	fi
}

# ==============================================================================
# Variables
# ==============================================================================
export UAV_NAME="uav1"
export NATO_NAME=""                # lower-case name of the UAV frame {alpha, bravo, charlie, ...}
export UAV_MASS="3.0"              # [kg], used only with real UAV
export RUN_TYPE="simulation"       # {simulation, uav}
export UAV_TYPE="f550"             # {f550, f450, t650, eagle, naki}
export PROPULSION_TYPE="default"   # {default, new_esc, ...}
export ODOMETRY_TYPE="gps"         # {gps, optflow, hector, vio, ...}
export INITIAL_DISTURBANCE_X="0.0" # [N], external disturbance in the body frame
export INITIAL_DISTURBANCE_Y="0.0" # [N], external disturbance in the body frame
export STANDALONE="false"          # disables the core nodelete manager
export SWAP_GARMINS="false"        # swap up/down garmins
export PIXGARM="false"             # true if Garmin lidar is connected throught Pixhawk
export SENSORS=""                  # {garmin_down, garmin_up, rplidar, realsense_front, teraranger, bluefox_optflow, realsense_brick, bluefox_brick}
export WORLD_NAME="simulation"     # e.g.: "simulation" <= mrs_general/config/world_simulation.yaml
export MRS_STATUS="readme"         # {readme, dynamics, balloon, avoidance, control_error, gripper}
export LOGGER_DEBUG="false"        # sets the ros console output level to debug
