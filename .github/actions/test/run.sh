#!/bin/bash
set -e

echo "Installing dependencies..."
apt-get update
apt-get install -y python3-catkin-tools python3-vcstool python3-rosdep

echo "Running setup..."
./setup.sh

source /opt/ros/$ROS_DISTRO/setup.bash

echo "Running build..."
./build.sh

echo "Running test..."
./test.sh
