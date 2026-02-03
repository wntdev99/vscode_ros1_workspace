# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a VSCode-based ROS1 Noetic development workspace template using Docker devcontainers. The project name is **WATT** and it's configured for Ubuntu 20.04 with pre-configured development tools, linting, debugging, and CI/CD.

**Key architecture:**
- Development happens inside a Docker container (user: `watt`)
- The `src/` directory is a Docker volume, NOT tracked by git - keeps local and container environments separate
- External repositories are imported via `ros1.repos` using vcs tool
- Uses `catkin build` (catkin_tools) instead of `catkin_make`

## Build and Development Commands

All commands run inside the devcontainer.

**Build:**
```bash
./build.sh                    # Build workspace (RelWithDebInfo)
BUILD_TYPE=Debug ./build.sh   # Build with debug symbols
catkin build                  # Direct catkin build
catkin build <package_name>   # Build specific package
```

**Test:**
```bash
./test.sh                     # Run all tests
catkin run_tests              # Run tests directly
catkin_test_results build/    # Show test results
```

**Setup (import repos + install deps):**
```bash
./setup.sh
```

**Linting:**
```bash
cppcheck --enable=all --inconclusive src/   # C++ static analysis
cpplint --recursive src/                     # C++ style checker
flake8 src/                                  # Python linter
```

**Clean workspace:**
```bash
catkin clean -y               # Clean build artifacts
rm -rf build devel logs .catkin_tools  # Full purge
```

**Create new package:**
```bash
cd src && catkin_create_pkg <package_name> std_msgs rospy roscpp
```

## Repository Management (vcs tool)

```bash
vcs import src < ros1.repos   # Import repos from workspace file
vcs export src > ros1.repos   # Export current repos to workspace file
```

## Shell Aliases (inside container)

| Alias | Action |
|-------|--------|
| `cm` | Build + auto-source (recommended) |
| `cb` | Build only |
| `cw` | cd to workspace root |
| `cs` | cd to src/ |
| `eb` | Edit bashrc |
| `sb` | Source bashrc |

## Debugging

VSCode launch configurations are available for:
- **Python**: Debug current file
- **C++ (gdb)**: Launch or attach to ROS1 node at `devel/lib/<package>/<program>`
- **roslaunch**: Debug launch files at `src/<package>/launch/`

Debug builds: Use `BUILD_TYPE=Debug ./build.sh` for symbols.

## VSCode Tasks

Run via Terminal → Run Task. Key tasks:
- `build` / `debug` - Build workspace
- `test` - Run all tests
- `clean` / `purge` - Clean workspace
- `cppcheck` / `cpplint` / `flake8` - Run linters
- `new catkin package` - Create package from template
- `install dependencies` - Install rosdep dependencies

## CI/CD

GitHub Actions runs on push to `main`/`noetic*` branches and PRs:
- Build job using `osrf/ros:noetic-desktop-full`
- Lint jobs: cppcheck, cpplint, flake8

## GPU Support

Current configuration uses Intel integrated graphics (`--device=/dev/dri`). For NVIDIA or WSL2 vGPU, see commented sections in `.devcontainer/devcontainer.json` and `.devcontainer/Dockerfile`.
