# Choose from humble and iron
ARG FROM_IMAGE=ros:humble

FROM $FROM_IMAGE

ARG OVERLAY_WS=/opt/ros/overlay_ws

# Choose from fortress, garden, and harmonic.
ARG GZ_VERSION=fortress


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


# Install the matching ros_gz version, eg. `ros-humble-ros-gzharmonic`.
# For Fortress, a suffix is not necessary, so it would just be `ros-humble-ros-gz`
RUN apt-get update \
    && apt-get install -y "ros-${ROS_DISTRO}-ros-gz${GZ_VERSION#fortress}" emacs htop byobu python3 pip less \
    && rm -rf /var/lib/apt/lists/*

# For colcon to build python packages without errors we'll need
RUN pip install setuptools==58.2.0

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


