# Turtlebot4 Docker

This Docker container contains [ROS 2 Humble](https://docs.ros.org/en/humble/), [Gazebo Fortress](https://gazebosim.org/docs/harmonic/install_ubuntu), and the [TurtleBot 4 simulation](https://turtlebot.github.io/turtlebot4-user-manual/). The Docker container has been configured to work well on commodity hardware without a graphics card. Most reasonably configured hardware should be able to run the simulation with a real time factor of at least 0.2.

This Docker container is meant to be used with this [example code for a toy TB4 node](https://github.com/kscottz/tb4_toy) and the associated [PyCon 2024 talk](https://docs.google.com/presentation/d/1OaOoQi-Ja5go319JDQfb3lyBg6Azz5cfrdgx6MOJ7wc/edit?usp=sharing).


# NEED HELP?!

* A full list of ROS resources including our Discord and Q&A website [can be found here](https://github.com/ros2/).
* A full list of Gazebo resources [can be found here.](https://github.com/gazebosim)
* The TurtleBot 4 manual [can be found here.]((https://turtlebot.github.io/turtlebot4-user-manual/)


# Using this Docker Image

## Installing and Running the Container

* Install Docker with `sudo apt install docker.io`
* You may need to [add yourself to the Docker group](https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon) with the command `sudo usermod -aG docker $(whoami)` 
* Install Rocker (see [instructions](https://github.com/osrf/rocker))
* Clone this repository
* `docker build . -t tb4`

### How to start an empty container

```bash
rocker --x11 tb4 bash
```

If you are using an Intel integrated graphics card do this instead:

```bash
rocker --x11 --devices=/dev/dri tb4 bash
```

Inside the container, run

```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze
```

### Start to start the container to run the example code

* Install Docker, Rocker, and this Repo as noted above

* In your local dev environment checkout out your dev repository and ros2_control. ros2_control is a temporary patch and should be fixed soon. An older version of setup tools may be needed 

```bash
git clone git@github.com:kscottz/tb4_toy.git
git clone git@github.com:ros-controls/ros2_control.git
pip install setuptools==58.2.0

```

* Change `ros2_control` to the Humble branch `git checkout humble`

* Start the container with the following command to link the directories

```bash
rocker --x11 --devices=/dev/dri  --volume=/home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control --volume=/home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash
```

* Now we need to re-build ros2_control and tb4_toy

```bash
source ./install/setup.bash
colcon build
```

* Now start the Maze simulator

```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze
```

## Other useful commands:

* Send a velocity command: `ros2 topic pub /cmd_vel geometry_msgs/msg/Twist "{linear: {x: 30.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}"`
* Control the robot via keyboard: `ros2 run teleop_twist_keyboard teleop_twist_keyboard`
* Run the toy node: `ros2 run tb4_toy toy_node`
* Trigger the toy node service: `ros2 service call /do_loopy std_srvs/Trigger '{}'`