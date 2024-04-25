# turtlebot4 Docker

## Build the docker image

`docker build . -t tb4`

## Run the container

* Install Docker with `sudo apt install docker.io`
* You may need to [add yourself to the Docker group](https://stackoverflow.com/questions/21871479/docker-cant-connect-to-docker-daemon) with the command `sudo usermod -aG docker $(whoami)` 
* Install Rocker (see [instructions](https://github.com/osrf/rocker))

Then run:

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


## Amended Setup with Dev Repo and ROS 2 Control updates

* Install Docker, Rocker, and this Repo as noted above

* In your local dev environment checkout out your dev repository and ros2_control

```bash
git clone git@github.com:kscottz/tb4_toy.git
git clone git@github.com:ros-controls/ros2_control.git

```

* Change `ros2_control` to the Humble branch `git checkout humble`

* Start the container with the following command to link the directories

```bash
rocker --x11 --devices=/dev/dri  --volume=<your_path>/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control --volume=/<your_path>/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash
```

* Now we need to re-build ros2_control and tb4_toy

```bash
source ./install/setup.bash
colcon build
```

* Now start the Maze simulator

```bash

```