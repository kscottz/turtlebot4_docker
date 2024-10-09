 ![The TurtleBot 4 Simulator in a Docker Container](/example.png)

# Turtlebot4 Docker

This Docker container contains [ROS 2 Humble](https://docs.ros.org/en/humble/), [Gazebo Fortress](https://gazebosim.org/docs/harmonic/install_ubuntu), and the [TurtleBot 4 simulation](https://turtlebot.github.io/turtlebot4-user-manual/). The Docker container has been configured to work well on commodity hardware without a graphics card. Most reasonably configured hardware should be able to run the simulation with a real time factor of at least 0.2.

👉 This Docker container is meant to be used with this [example code for a toy TB4 node](https://github.com/kscottz/tb4_toy) and the associated [PyCon 2024 talk](https://docs.google.com/presentation/d/1OaOoQi-Ja5go319JDQfb3lyBg6Azz5cfrdgx6MOJ7wc/edit?usp=sharing) or [ROSCon 2024 Workshop](https://docs.google.com/presentation/d/1V1LQblvSvm84qXzOgCCoJoYtR35na5vPyZZ5lZmNRJs/edit?usp=sharing)

👉 This Docker also includes a full ROS 2 Humble install. If you would like to brush up on your ROS skills you can work through the ROS 2 tutorials. We suggest you start with the [CLI Tutorials.](https://docs.ros.org/en/jazzy/Tutorials/Beginner-CLI-Tools.html)

# Overview

If you are following along after the talk or in a workshop you have two options:

* Build the Dockerfile from scratch using the instructions below. This will allow you to build upon what you've learned alreay.
* Pull the Docker image from Docker Hub by doing the following:
  * TODO DockerHub Link

For the workshop you have two options for how to follow along:

* Write the code from scratch and use the `tb4_toy` repository as a reference when you get stucl. 
* Follow along from completed code, there are git tags for points along the way.

# Using this Docker Image

## Installing and Running the Container

* Install Docker with `sudo apt install docker.io`
* You may need to [add yourself to the Docker group](https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon) with the command `sudo usermod -aG docker $(whoami)` 
* Install Rocker (see [instructions](https://github.com/osrf/rocker))
* Clone this repository
* `docker build . -t tb4`

### How to Start with an Empty Container

Note that this approach will require you to work inside the container at all times. This approach will leave your host system untouched. *To save your progress you will need to use `[docker commit](https://docs.docker.com/reference/cli/docker/container/commit/)` to save your work.

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

### How to Start with Example Code

This approach will allow you to use your host operating system's tools and directories inside of the Docker container. If you would like to use your own empty Github repo you can replace the sample repo with one of your own. 

* Install Docker, Rocker, and this Repo as noted above

* In your local dev environment checkout out your dev repository and ros2_control. ros2_control is a temporary patch and should be fixed soon. An older version of setup tools may be needed 

```bash
git clone git@github.com:kscottz/tb4_toy.git
git clone git@github.com:ros-controls/ros2_control.git
pip install setuptools==58.2.0

```

* Change `ros2_control` to the Humble branch `git checkout humble`

* Start the container with the following command to link the directories you will need to update the first path to match the path you are using on your machine for the checked out directories.

```bash
rocker --x11 --devices=/dev/dri  --volume=/home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control --volume=/home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash
```
Note that you need to replace the full path above with your full path. This is to say, replace `/home/kscottz/Code` with the full path to your Github repository.


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


# NEED HELP?!

* A full list of ROS resources including our Discord and Q&A website [can be found here](https://github.com/ros2/).
* A full list of Gazebo resources [can be found here.](https://github.com/gazebosim)
* The TurtleBot 4 manual [can be found here.](https://turtlebot.github.io/turtlebot4-user-manual/)

