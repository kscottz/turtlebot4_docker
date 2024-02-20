# turtlebot4 Docker

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
