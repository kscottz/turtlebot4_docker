# Choose from humble, iron, jazzy
ARG FROM_IMAGE=ros:jazzy

FROM $FROM_IMAGE

ARG OVERLAY_WS=/opt/ros/overlay_ws

# Choose from fortress, garden, and harmonic.
ARG GZ_VERSION=harmonic

# Run apt update 
RUN apt-get update \
    && apt-get install -y lsb-release wget gnupg \
    && rm -rf /var/lib/apt/lists/*

ENV GZ_VERSION=${GZ_VERSION}
# Install Gazeob Harmonic
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null \
    && apt-get update \
    && apt-get install -y "gz-${GZ_VERSION}"  \
    && rm -rf /var/lib/apt/lists/*


# Install the matching ros_gz version, eg. `ros-jazzy-ros-gzharmonic`.
# For Fortress, a suffix is not necessary, so it would just be `ros-jazzy-ros-gz`
# TODO: why do we need to force install ros-jazzy-*? Why is it not being picked up?
RUN apt-get update \
    && apt-get install -y "ros-${ROS_DISTRO}-ros-gz${GZ_VERSION#harmonic}" emacs htop byobu python3 pip less ros-${ROS_DISTRO}-teleop-twist-keyboard ros-${ROS_DISTRO}-turtlebot4-msgs ros-${ROS_DISTRO}-irobot-create-msgs ros-${ROS_DISTRO}-irobot-create-toolbox ros-${ROS_DISTRO}-irobot-create-gz-plugins \
    && rm -rf /var/lib/apt/lists/*

# RUN apt install ros-jazzy-turtlebot4-msgs ros-jazzy-irobot-create-msgs

# For colcon to build python packages without errors we'll need
# Note, this may not be the 
RUN pip install setuptools --break-system-packages


# Build turtlebot4 and ros_gz from source
WORKDIR $OVERLAY_WS/src
RUN git clone https://github.com/turtlebot/turtlebot4_simulator -b ${ROS_DISTRO}


WORKDIR $OVERLAY_WS
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt-get update && rosdep install -y \
      --from-paths src \
      --ignore-src \
    && rm -rf /var/lib/apt/lists/*

# build overlay source
RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    colcon build --symlink-install


# source entrypoint setup
ENV OVERLAY_WS $OVERLAY_WS
RUN sed --in-place --expression \
      '$isource "$OVERLAY_WS/install/setup.bash"' \
      /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]

CMD ["/bin/bash"]


