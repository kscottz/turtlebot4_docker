# turtlebot4 Docker

## Build the docker image

`docker build . -t tb4`

## Run the container

Install rocker (see [instructions](https://github.com/osrf/rocker))

Then run:

```bash
rocker --x11 tb4 bash
```

Inside the container, run

```bash
ros2 launch turtlebot4_ignition_bringup turtlebot4_ignition.launch.py
```
