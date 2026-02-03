#!/bin/bash
set -e

if [ -f devel/setup.bash ]; then source devel/setup.bash; fi
catkin run_tests
catkin_test_results build/
