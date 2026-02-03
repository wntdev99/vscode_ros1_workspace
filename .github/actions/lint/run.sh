#!/bin/bash
set -e

# Install linters
apt-get update
apt-get install -y cppcheck python3-pip
pip3 install cpplint flake8

case "$LINTER" in
  "cppcheck"|"cpplint")
    if [ -z "$(find src/ -name '*.cpp' -o -name '*.hpp' -o -name '*.c' -o -name '*.h' 2>/dev/null)" ]; then
      echo "No C/C++ files found. Skipping $LINTER."
      exit 0
    fi
    ;;
  "flake8")
    if [ -z "$(find src/ -name '*.py' 2>/dev/null)" ]; then
      echo "No Python files found. Skipping $LINTER."
      exit 0
    fi
    ;;
esac

case "$LINTER" in
  "cppcheck")
    cppcheck --enable=warning,style --error-exitcode=1 src/
    ;;
  "cpplint")
    cpplint --recursive src/
    ;;
  "flake8")
    flake8 src/
    ;;
  *)
    echo "Unknown linter: $LINTER"
    exit 1
    ;;
esac
