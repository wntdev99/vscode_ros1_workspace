FROM osrf/ros:noetic-desktop-full

# Set up dev packages
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
   && apt-get -y install --no-install-recommends \
    bash-completion \
    gdb \
    gettext-base \
    git-core \
    openssh-client \
    python3-argcomplete \
    python3-catkin-tools \
    python3-osrf-pycommon \
    python3-rosdep \
    python3-vcstool \
    sudo \
    # For GUI
    libx11-xcb1 libxcb1 libxcb-render0 libxcb-shm0 libxcb-xfixes0 libxcb-shape0 \
    libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-util1 \
    libxcb-xinerama0 libxcb-xkb1 libxkbcommon0 libxkbcommon-x11-0 \
    libglu1-mesa libxi6 libsm6 libxrender1 libfontconfig1 \
    # For nwjs (flexbe_app)
    libxtst6 libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 \
    libgtk-3-0 libgbm1 libasound2 \
    # For GTK/D-Bus (suppress warnings)
    libcanberra-gtk3-module dbus-x11 \
    # Korean language support
    fonts-nanum fonts-nanum-coding locales \
    # For WATT users
    gedit \
    # ROS1 Noetic packages
    ros-noetic-topic-tools \
    ros-noetic-tf2-tools ros-noetic-rqt-tf-tree ros-noetic-tf2-sensor-msgs \
    ros-noetic-ros-control ros-noetic-ros-controllers ros-noetic-gazebo-ros-control \
    ros-noetic-navigation \
    ros-noetic-mbf-msgs \
    # Python packages
    python3-pip \
    python3-schedule \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    # Generate Korean locale
    && sed -i '/ko_KR.UTF-8/s/^# //g' /etc/locale.gen \
    && locale-gen

# Install Python packages
RUN pip3 install --no-cache-dir pymsteams fastapi uvicorn firebase-admin
ENV DEBIAN_FRONTEND=dialog
ENV LANG=ko_KR.UTF-8
ENV LC_ALL=ko_KR.UTF-8

### For Windows, uncomment the following lines to install WSLg dependencies and utilize vGPU acceleration 
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install \
#           vainfo \
#           mesa-va-drivers \
#           mesa-utils \
#    # Clean up
#         && apt-get autoremove -y \
#         && apt-get clean -y \
#         && rm -rf /var/lib/apt/lists/*
# ENV LIBVA_DRIVER_NAME=d3d12
# ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib
# CMD vainfo --display drm --device /dev/dri/card0
# ENV DEBIAN_FRONTEND=dialog

################
# uncomment below for nvidia support
# Expose the nvidia driver to allow opengl 
# Dependencies for glvnd and X11.
################
# RUN apt-get update \
#  && apt-get install -y -qq --no-install-recommends \
#   libglvnd0 \
#   libgl1 \
#   libglx0 \
#   libegl1 \
#   libxext6 \
#   libx11-6 \
# && rm -rf /var/lib/apt/lists/*

# Env vars for the nvidia-container-runtime.
#ENV NVIDIA_VISIBLE_DEVICES all
#ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

#ENV QT_X11_NO_MITSHM=1

# ** [Optional] Uncomment this section to install additional packages. **
#
# ENV DEBIAN_FRONTEND=noninteractive
# RUN apt-get update \
#    && apt-get -y install --no-install-recommends <your-package-list-here> \
#    #
#    # Clean up
#    && apt-get autoremove -y \
#    && apt-get clean -y \
#    && rm -rf /var/lib/apt/lists/*
# ENV DEBIAN_FRONTEND=dialog

# Set up auto-source of workspace for watt
ARG WORKSPACE
ARG USERNAME=watt
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Find and replace any user with matching UID
RUN set -eux; \
    existing_user=$(getent passwd "$USER_UID" | cut -d: -f1 || true); \
    if [ -n "$existing_user" ]; then \
        usermod -l $USERNAME -d /home/$USERNAME -m $existing_user && \
        groupmod -n $USERNAME $existing_user && \
        echo "Renamed $existing_user to $USERNAME"; \
    else \
        groupadd --gid $USER_GID $USERNAME && \
        useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
        echo "Created new user $USERNAME"; \
    fi
# Ensure necessary directories and permissions
RUN mkdir -p /home/$USERNAME /run/user/$USER_UID && \
    chown -R $USER_UID:$USER_GID /home/$USERNAME /run/user/$USER_UID

# Add sudo support for the non-root user
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && touch /home/$USERNAME/.sudo_as_admin_successful

# Set up ROS environment in /etc/bash.bashrc (works for all shells including non-interactive)
# This avoids BASH_SOURCE issues with catkin's setup.bash by setting env vars directly
ARG WS_PATH=/workspaces/vscode_ros1_workspace
RUN { \
    echo '# ROS Noetic environment (loaded for all bash sessions)'; \
    echo '__ROS_WS_PATH=/workspaces/vscode_ros1_workspace'; \
    echo ''; \
    echo '# Source ROS base setup'; \
    echo 'source /opt/ros/noetic/setup.bash'; \
    echo ''; \
    echo '# Workspace devel environment - set paths directly to avoid BASH_SOURCE issues'; \
    echo 'if [ -d $__ROS_WS_PATH/devel ]; then'; \
    echo '    export CMAKE_PREFIX_PATH="$__ROS_WS_PATH/devel:$CMAKE_PREFIX_PATH"'; \
    echo '    export PYTHONPATH="$__ROS_WS_PATH/devel/lib/python3/dist-packages:$PYTHONPATH"'; \
    echo '    export LD_LIBRARY_PATH="$__ROS_WS_PATH/devel/lib:$LD_LIBRARY_PATH"'; \
    echo '    export PKG_CONFIG_PATH="$__ROS_WS_PATH/devel/lib/pkgconfig:$PKG_CONFIG_PATH"'; \
    echo '    export PATH="$__ROS_WS_PATH/devel/bin:$PATH"'; \
    echo '    if [ -f $__ROS_WS_PATH/devel/.catkin ]; then'; \
    echo '        __ROS_CATKIN_PKGS=$(cat $__ROS_WS_PATH/devel/.catkin | tr ";" ":")'; \
    echo '        export ROS_PACKAGE_PATH="$__ROS_CATKIN_PKGS:$ROS_PACKAGE_PATH"'; \
    echo '        unset __ROS_CATKIN_PKGS'; \
    echo '    fi'; \
    echo 'fi'; \
    echo ''; \
    echo '# Load .env file (for HW_SERIAL_NUMBER, etc.)'; \
    echo 'if [ -f $__ROS_WS_PATH/.env ]; then'; \
    echo '    set -a; source $__ROS_WS_PATH/.env; set +a'; \
    echo 'fi'; \
    echo 'unset __ROS_WS_PATH'; \
    echo ''; \
    } | cat - /etc/bash.bashrc > /tmp/bash.bashrc && mv /tmp/bash.bashrc /etc/bash.bashrc

# Set up user bashrc (interactive shell customizations only)
RUN  echo "# WATT Customs" >> /home/$USERNAME/.bashrc \
  && echo "alias eb='gedit ~/.bashrc'" >> /home/$USERNAME/.bashrc \
  && echo "alias sb='source ~/.bashrc'" >> /home/$USERNAME/.bashrc \
  && echo "alias cw='cd /workspaces/vscode_ros1_workspace'" >> /home/$USERNAME/.bashrc \
  && echo "alias cs='cd /workspaces/vscode_ros1_workspace/src'" >> /home/$USERNAME/.bashrc \
  && echo "alias cb='cd /workspaces/vscode_ros1_workspace && ./build.sh'" >> /home/$USERNAME/.bashrc \
  && echo "alias cm='cd /workspaces/vscode_ros1_workspace && ./build.sh && source devel/setup.bash'" >> /home/$USERNAME/.bashrc

# Set up python symlinks for vscode paths
RUN PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info[0]}.{sys.version_info[1]}')") \
 && tgt="/opt/ros/${ROS_DISTRO}/lib/python${PYTHON_VERSION}/dist-packages" \
 && [ -d "$tgt" ] && ln -s "$tgt" "/opt/ros/${ROS_DISTRO}/lib/ros_site_packages" || true
