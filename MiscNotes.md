Rocker --volume -v  <path> mount a directory
Rocker --home

# load everything in the workspace

# Docker build creates image
# Docker commit back to the image
# Docker commit <container> <image name> // next time load from saved image

# <launch command> world:=maze

# put the new sdf world file in the worlds directory

ign gazebo -v4 maze.sdf

 https://fuel.ignitionrobotics.org to https://fuel.gazebosim.org

[create-7] [INFO] [1712699982.337452032] [ros_gz_sim]: Requesting list of world names.
[create-8] [INFO] [1712699982.377983758] [ros_gz_sim]: Requesting list of world names.
[ruby $(which ign) gazebo-1] [Err] [FuelClient.cc:717] Failed to download model.
[ruby $(which ign) gazebo-1]   Server: https://fuel.ignitionrobotics.org
[ruby $(which ign) gazebo-1]   Route: openrobotics/models/warehouse/tip/warehouse.zip
[ruby $(which ign) gazebo-1]   REST response code: 504
[ruby $(which ign) gazebo-1] [Wrn] [FuelClient.cc:1978] The fuel.ignitionrobotics.org URL is deprecrated. Pleasse change https://fuel.ignitionrobotics.org to https://fuel.gazebosim.org
[create-7] [INFO] [1712699987.338099736] [ros_gz_sim]: Requesting list of world names.



Steps
* Clone https://github.com/ros-controls/gz_ros2_control/ into source, change to humble
* rm -rf ./build ./install
* replace all occurances of  https://fuel.ignitionrobotics.org to https://fuel.gazebosim.org
* `colcon build`
* source /opt/ros/overlay_ws/install/setup.bash
* ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py world:=maze
* Kill all docker containers: docker stop $(docker ps -a -q)

ros2 action send_goal /undock overlay_ws/irobot_create_msgs/action/Undock '{}'

Pleasse change https://fuel.ignitionrobotics.org to https://fuel.gazebosim.org

[Mount a directory from docker to local directory](
https://www.digitalocean.com/community/tutorials/how-to-share-data-between-the-docker-container-and-the-host)

Name a container at runtime
`--name your_name`

e.g. rocker --x11 --devices=/dev/dri tb4 bash --name tb4sim

rocker run --name tb4sim -d -v ~/Code/overlay_ws/src:/opt/ros/overlay_ws/src

Mount directory?

rocker run --name tb4sim  --volume /home/kscottz/Code/overlay_ws/src:/opt/ros/overlay_ws/src

What the hell, why are all of these ROS errors?
https://www.google.com/search?q=docker+Extension+volume+doesn%27t+support+default+arguments.+Please+extend+it.&oq=docker+Extension+volume+doesn%27t+support+default+arguments.+Please+extend+it.&gs_lcrp=EgZjaHJvbWUyBggAEEUYQNIBCDQ0NjVqMGo0qAIAsAIB&sourceid=chrome&ie=UTF-8

https://rocker-project.org/use/shared_volumes.html


# THIS IS THE COMMAND YOU WANT
docker run --rm -ti --user root -v /home/kscottz/Code/shared_dir/:/opt/ros/overlay_ws/src/shared_dir  tb4 bash

git clone https://github.com/ros-controls/gz_ros2_control/

# Multiple directories
docker run --rm -ti --user root -v /home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control -v /home/kscottz/Code/shared_dir/:/opt/ros/overlay_ws/src/shared_dir  tb4 bash^C

## Example

Let's say you have a Docker container with the name `tb4` and you would like to share your local directory `/home/username/Code/fake_package` inside the `tb4` container at the point `/opt/ros/container_ws/src/fake_package`. To do this you will need to know the username used within the Docker container. You can find the correct username inside the container using the `whoami` command, for this example let's say the user name is `root`. The command to make this happen would be:

`docker run --rm -ti --user root -v/home/username/Code/fake_package:/opt/ros/container_ws/src/fake_package tb4 bash`

It is worth noting that you can use the -v flag multiple times during a single command.

https://github.com/rocker-org/website/edit/master/use/shared_volumes.md

docker run --rm -ti --user root -v /home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control -v /home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy  tb4 bash


THIS IS THE WORKING COMMAND
rocker --x11 --devices=/dev/dri  --volume=/home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control --volume=/home/kscottz/Code/shared_dir/:/opt/ros/overlay_ws/src/shared_dir  tb4 bash

rocker --x11 --devices=/dev/dri  --volume=/home/kscottz/Code/gz_ros2_control/:/opt/ros/overlay_ws/src/gz_ros2_control --volume=/home/kscottz/Code/tb4_toy/:/opt/ros/overlay_ws/src/tb4_toy tb4 bash

# Running into errors installing a python package in the Docker container. Python and PIP are missing.
 error specifically looks like this:
```bash
root@4c53ffc94ca1:/opt/ros/overlay_ws# colcon build --packages-select tb4_toy
Starting >>> tb4_toy 
--- stderr: tb4_toy                   
/usr/lib/python3/dist-packages/setuptools/command/install.py:34: SetuptoolsDeprecationWarning: setup.py install is deprecated. Use build and pip and other standards-based tools.
  warnings.warn(
---
Finished <<< tb4_toy [2.57s]

Summary: 1 package finished [4.80s]
```

We need an older version of setup tools:
`pip install setuptools==58.2.0`


ros2 topic pub --once /cmd_vel geometry_msgs/msg/Twist "{linear: {x: -2.0, y: 0.0, z: 0.0}, angular: {x: 0.0, y: 0.0, z: 0.0}}"

