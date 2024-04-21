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


