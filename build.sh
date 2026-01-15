#!/bin/bash
set -e

# Set the default build type
BUILD_TYPE=RelWithDebInfo

# Limit parallel jobs to reduce system load (adjust as needed)
PARALLEL_PACKAGES=2      # Number of packages to build simultaneously
PARALLEL_JOBS=2          # Number of compile jobs per package

export CMAKE_BUILD_PARALLEL_LEVEL=$PARALLEL_JOBS

colcon build \
        --merge-install \
        --symlink-install \
        --parallel-workers $PARALLEL_PACKAGES \
        --cmake-args "-DCMAKE_BUILD_TYPE=$BUILD_TYPE" "-DCMAKE_EXPORT_COMPILE_COMMANDS=On" \
        -Wall -Wextra -Wpedantic
