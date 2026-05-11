#!/bin/bash
set -e

vcs import src < ros1.repos

# 워크스페이스 루트의 로컬 패키지를 src/ 에 심볼릭 링크로 연결
# src/ 가 Docker volume 이라 로컬과 격리되므로, 루트의 bind-mount 폴더를 링크로 노출
for pkg_dir in rosbag_rviz_panel; do
  if [ -f "$pkg_dir/package.xml" ] && [ ! -e "src/$pkg_dir" ]; then
    ln -sfn "../$pkg_dir" "src/$pkg_dir"
    echo "[setup.sh] Linked $pkg_dir into src/"
  fi
done

sudo apt-get update
rosdep update --rosdistro=$ROS_DISTRO
rosdep install --from-paths src --ignore-src -y --rosdistro=$ROS_DISTRO
