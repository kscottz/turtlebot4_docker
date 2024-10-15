 ![The TurtleBot 4 Simulator in a Docker Container](/example.png)

# Turtlebot4 Docker

This Docker container contains [ROS 2 Humble](https://docs.ros.org/en/humble/), [Gazebo Fortress](https://gazebosim.org/docs/harmonic/install_ubuntu), and the [TurtleBot 4 simulation](https://turtlebot.github.io/turtlebot4-user-manual/). The Docker container has been configured to work well on commodity hardware without a graphics card. Most reasonably configured hardware should be able to run the simulation with a real time factor of at least 0.2.

👉 This Docker container is meant to be used with this [example code for a toy TB4 node](https://github.com/kscottz/tb4_toy) and the associated [PyCon 2024 talk](https://docs.google.com/presentation/d/1OaOoQi-Ja5go319JDQfb3lyBg6Azz5cfrdgx6MOJ7wc/edit?usp=sharing) or [ROSCon 2024 Workshop](https://docs.google.com/presentation/d/1V1LQblvSvm84qXzOgCCoJoYtR35na5vPyZZ5lZmNRJs/edit?usp=sharing)

👉 This Docker also includes a full ROS 2 Humble install. If you would like to brush up on your ROS skills you can work through the ROS 2 tutorials. We suggest you start with the [CLI Tutorials.](https://docs.ros.org/en/jazzy/Tutorials/Beginner-CLI-Tools.html)


# Choose Your Own Adventure

This workshop let's you choose your own adventure. You have two big decisions to make:

* Build the container yourself -or- pull down the container from DockerHub.
  * In a classroom setting we recommend pulling the container down from DockerHub.
  * If you are home we recommend you build the container yourself. It will allow you to build a ROS + Gazebo Docker container that fits your particular needs.
* Write the code yourself from scratch -or- follow along from a finished repository.
  * We recommend you write the code yourself! It will give you experience with the ROS APIs and development process. You can always peek at the finished project for some help.
  * If you want to follow along from the finished project you can clone the [following repository](https://github.com/kscottz/tb4_toy) into your working directory.

But wait, there's more! Do you just want to try out some of the great tutorials on [docs.ros.org](https://docs.ros.org/en/humble/) we also have instructions on how to do that too!

# Setup Instructions

* Install Docker with `sudo apt install docker.io`
* You may need to [add yourself to the Docker group](https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon) with the command `sudo usermod -aG docker $(whoami)` 
* Install Rocker (see [instructions](https://github.com/osrf/rocker)). Make sure to setup and use a Python virtual environment. Note your virtual environments name and location

If you wish to build the Docker container from scratch:

* Clone this repository `git clone git@github.com:kscottz/turtlebot4_docker.git`
* Build the container using: `docker build . -t tb4`
* *REMEMBER tb4* is the name of your image in this case

If you wish to use the pre-built Docker image run:

* `docker pull osrf/icra2023_ros2_gz_tutorial:roscon2024_tutorial_humble_Building the Container


### How to Start the Container

Let's start by talking about how to start your container. There is more than one way to skin a cat and there is more than one way to start this workshop. *Take a look below but do not start the container yet! You have a few more options to decide on!* 

* If you downloaded your Docker container you can start it using:
  * `rocker --x11 --devices=/dev/dri  osrf/icra2023_ros2_gz_tutorial:roscon2024_tutorial_humble_turtlebot4  bash`
* If you built your Docker container you can start it using:
  * `rocker --x11 --devices=/dev/dri tb4 bash`

*Note that all that changed here is the name of the container which is the second to last parameter!*

Now you must decided where you want to save your work. You have two options, start from scratch and build everything yourself, or follow along from a finished project. There is also a third option, where you just start the container but use Docker's internal tools to save your work. While this is certainly possible we don't recommend it.

* If you want to work from scratch, our preferred workflow, then all you do is create a directory:
  * `mkdir tb4_toy`
  * Now run, `rocker --x11 --devices=/dev/dri --volume=<full path to your directory>:/opt/ros/overlay_ws/src/tb4_toy <container name> bash` where the directory has been replaced by your new directory, and container is the container you want to use. 
  * Here's an example from my system: `rocker --x11 --devices=/dev/dri --volume=/home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash`	

* If you want to work from a finished code example, please do the following
  * `git clone git@github.com:kscottz/tb4_toy.git` -- [here's the code](https://github.com/kscottz/tb4_toy) if you just want to peek. 
  * Now run, `rocker --x11 --devices=/dev/dri --volume=<full path to your directory>:/opt/ros/overlay_ws/src/tb4_toy <container name> bash` where the directory has been replaced by your new directory, and container is the container you want to use. 
  * Here's an example from my system: `rocker --x11 --devices=/dev/dri --volume=/home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash`	

**Important Note** -- if your laptop has a fancy graphics card you can enable it by omitting the line: `--devices=/dev/dri.` 

Note that this tutorial will require you to work inside the container at all times and should leave your host system untouched. *If you happen to change the Docker container's internal configuration and want to save it, you  will need to use `[docker commit](https://docs.docker.com/reference/cli/docker/container/commit/)` to save your work.

### Want to use just Docker? 

We have a comprehensive guide to using this container without Rocker [available here](https://github.com/osrf/icra2023_ros2_gz_tutorial/tree/roscon2024/docker). This guide includes a number of Bash scripts that make starting an appropriate Docker container easy! This guide also provides some alternative approaches to performing ROS development inside of a container. 


# Running ROS and Gazebo

Once you have started your container you can launch ROS and Gazebo by running the following commands:

```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze
```

### How to Start Gazebo and ROS

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
* [Docker cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/). 
