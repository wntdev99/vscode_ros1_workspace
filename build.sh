#!/bin/bash
set -e

# Set the default build type
BUILD_TYPE=${BUILD_TYPE:-RelWithDebInfo}

# Limit parallel jobs to reduce system load (adjust as needed)
PARALLEL_JOBS=2

# Initialize catkin workspace if not already done
if [ ! -f .catkin_tools/profiles/default/config.yaml ]; then
    catkin init
    catkin config --extend /opt/ros/$ROS_DISTRO
    catkin config --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
fi

# Build message packages first
catkin build james_msgs \
    --jobs $PARALLEL_JOBS \
    --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Source devel to make message headers available
source devel/setup.bash

# Build laser_line_extraction (dependency for other packages)
catkin build laser_line_extraction \
    --jobs $PARALLEL_JOBS \
    --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

# Build remaining packages
catkin build \
    --jobs $PARALLEL_JOBS \
    --cmake-args -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
