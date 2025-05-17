# Custom variables
export MOPED_REPO_NAME="kit22d"
export MOPED_REPO_PATH="/root/kit22d/moped_ws"
export DOCKER_CONTAINER_NAME="kit22d_devcontainer-ros-docker-1"

# Aliases
alias setURI="ROS_MASTER_URI=http://192.168.19.19:11311"
alias unsetURI="unset ROS_MASTER_URI"
alias carpc="ssh as@192.168.19.19"
alias copy_bags="scp -r as@192.168.19.19/home/as/bags/$(date +%Y-%m-%d) /media/${USER}/T7/bags"

alias dv="source devel/setup.bash"
alias ..="cd .."
alias ...="cd ../.."
alias as="cd ~/${MOPED_REPO_NAME}"
alias moped="cd ~/${MOPED_REPO_NAME}/moped_ws; dv"
alias bags="cd ~/bags"
alias ssd="cd /root/ssd/bags"
alias shared="cd ~/${MOPED_REPO_NAME}/moped_ws/src/shared_ws"
alias slam="cd ~/${MOPED_REPO_NAME}/moped_ws/src/slam_ws"
alias trajectory="cd ~/${MOPED_REPO_NAME}/moped_ws/src/trajectory_ws"

alias srm="source /opt/ros/${ROS_DISTRO}/etc/catkin/profile.d/50-rosmon.bash"
alias cm="moped; catkin_make"
alias cmj="moped; catkin_make --use-ninja"
alias cmc="moped; catkin_make -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++"
alias cmcj="cmc --use-ninja"

alias lgraphslam="moped; roslaunch slam_pkg graph_slam_node.launch"
alias lekfslam="moped; roslaunch slam_pkg ekf_slam_node.launch"
alias lgrass="moped; roslaunch slam_pkg grass_slam_node.launch rviz:=true"
alias lml='moped; roslaunch trajectory_pkg middleline_node.launch'
alias lskidpad='moped; roslaunch simulation skidpad.launch'

alias rviz-slam='moped; rviz -d ~/${MOPED_REPO_NAME}/moped_ws/src/slam_ws/src/slam_pkg/rviz/slam.rviz'
alias rviz-ml='moped; rviz -d src/trajectory_ws/src/trajectory_pkg/rviz/middleline.rviz'
alias rviz-vel='moped; rviz -d src/trajectory_ws/src/trajectory/rviz/velocity.rviz'
alias rviz-transitionspline='moped; rviz -d src/trajectory_ws/src/trajectory_pkg/rviz/transition_spline_debug.rviz'
alias rviz-lidar='moped; rviz -d src/lidar_ws/src/lidar_pkg/rviz/lidar.rviz'

alias startcar='moped; rostopic pub supervisor/actuation_allowed std_msgs/Bool "data: true"'

alias g="git status"

alias publishExplatzMap='~/${MOPED_REPO_NAME}/moped_ws/src/slam_ws/src/slam_pkg/scripts/publishMap.sh ~/${MOPED_REPO_NAME}/moped_ws/src/slam_ws/src/slam_pkg/maps/explatz_corrected_cw.yaml'

alias rb="rosbag"
alias rbp="rosbag play"
alias rosmon="rosrun rosmon_core rosmon"

alias cpmap="scp $HOME/staging_transformed.yaml as@192.168.19.19:/home/as/"
alias backupmap="scp -r as@192.168.19.19:/home/as/maps ~/backup_maps"

alias l="exa --long --icons --all --no-user"

alias pubpub="rostopic pub -f $HOME/staging_transformed.yaml /slam/map as_msgs/Cones"
