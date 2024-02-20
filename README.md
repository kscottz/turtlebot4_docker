# turtlebot4 Docker


## Build the docker image

`docker build . -t tb4`


## Run the container
```bash
docker run \
--interactive \
--privileged \
--tty \
--env DISPLAY \
--name "test" \
--volume /tmp:/tmp:rslave \
--rm \
tb4 \
bash
```
