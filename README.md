<h1 align="center">
  <br>
  <a href="https://ka-raceing.de"><img src="https://raw.githubusercontent.com/ka-raceing/ros-docker/main/misc/2_logostreifenbunt.png" alt="KA-RaceIng" width="200"></a>
  <br>
  ROS-Docker
  <br>
</h1>

<h4 align="center">Comprehensive Docker Image for the development environment of the Autonomous System at <a href="https://ka-raceing.de"> KA-RaceIng</a>.</h4>

<p align="center">
  <a href="#prerequisites">Prerequisites</a> •
  <a href="#docker-usage">Docker Usage</a> •
  <a href="#docker-compose-setup">Docker Compose Setup</a> •
  <a href="#running-with-vscode">Running with VSCode</a> •
  <a href="#license">License</a>
</p>

## Prerequisites
### Docker and Docker Compose
[Docker](https://docs.docker.com/engine/install/) is required to run the image in this repo.
Installing [Docker Compose](https://docs.docker.com/compose/) is also highly recommended.
- Ubuntu: follow [these](https://docs.docker.com/engine/install/ubuntu/) instructions
- Arch Linux:
```bash
sudo pacman -S docker docker-compose
sudo systemctl enable docker
# after this reboot system or manually start the docker service via the following
sudo systemctl start docker
```

## Docker Usage
The image can be pulled from [Github Packages](https://ghcr.io)
```bash
docker pull ghcr.io/ka-raceing/ros-docker
```
It can then be run via docker run
```bash
docker run --name ka-raceing_ros -itd ghcr.io/ka-raceing/ros-docker
```
After that the container's bash shell can be accessed via
```bash
docker exec -it ka-raceing_ros bash
```
Also it is possible to perform actions like mounting external directories via `docker run` parameters it is recommended to use docker-compose for more advanced setups.

## Docker Compose Setup
### with mounted workspace
```yaml
version: '3'

services:
  ros-docker:
    image: ghcr.io/ka-raceing/ros-docker
    network_mode: host
    volumes:
      # the workspace
      - <path_to_ws>:<desired_path_in_container>
    command: /bin/sh -c "while sleep 1000; do :; done"
```

### including graphic support (e.g. for RViz)
```yaml
version: '3'

services:
  ros-docker:
    image: ghcr.io/ka-raceing/ros-docker
    mem_limit: 4g #avoid bricking your device with a rviz memory overrun
    environment:
      - QT_X11_NO_MITSHM=1
      - DISPLAY=$DISPLAY
    devices:
      # this is a workaround, cause there isn't an option that works with different gpu manufacturers yet (https://github.com/docker/cli/issues/2063)
      - /dev/dri/card0:/dev/dri/card0 
    ulimits: # https://answers.ros.org/question/336963/rosout-high-memory-usage/
      nofile:
        soft: 1024
        hard: 524288 
    privileged: true #for graphics permissions
    network_mode: host
    volumes:
      # for GUI applications (e.g. RViz)
      - /tmp/.X11-unix:/tmp/.X11-unix:rw
      - ~/.Xauthority:/root/.Xauthority:ro
    command: /bin/sh -c "while sleep 1000; do :; done"
```

### including external [PCAN](https://www.peak-system.com) driver
```yaml
version: '3'

services:
  ros-docker:
    image: ghcr.io/ka-raceing/ros-docker
    network_mode: host
    volumes:
      # pcan (host paths may be different)
      - /usr/include/libpcan.h:/usr/include/libpcan.h:ro
      - /usr/include/pcan.h:/usr/include/pcan.h:ro
      - /usr/include/libpcanfd.h:/usr/include/libpcanfd.h:ro
      - /usr/include/pcanfd.h:/usr/include/pcanfd.h:ro
      - /usr/lib/libpcan.so:/usr/lib/libpcan.so:ro
      - /usr/lib/libpcanbasic.so:/usr/lib/libpcanbasic.so:ro
      - /usr/lib/libpcanfd.so:/usr/lib/libpcanfd.so:ro
    command: /bin/sh -c "while sleep 1000; do :; done"
```

### including external `.bashrc` file
```yaml
version: '3'

services:
  ros-docker:
    image: ghcr.io/ka-raceing/ros-docker
    network_mode: host
    volumes:
      #bashrc
      - ~/.bashrc:/root/.bashrc:ro
    command: /bin/sh -c "while sleep 1000; do :; done"
```

### everything together
```yaml
version: '3'

services:
  ros-docker:
    image: ghcr.io/ka-raceing/ros-docker
    mem_limit: 4g #avoid bricking your device with a rviz memory overrun
    environment:
      - QT_X11_NO_MITSHM=1
      - DISPLAY=$DISPLAY
    devices:
      # this is a workaround, cause there isn't an option that works with different gpu manufacturers yet (https://github.com/docker/cli/issues/2063)
      - /dev/dri/card0:/dev/dri/card0 
    ulimits: # https://answers.ros.org/question/336963/rosout-high-memory-usage/
      nofile:
        soft: 1024
        hard: 524288 
    privileged: true #for graphics permissions
    network_mode: host
    volumes:
      # the workspace
      - <path_to_ws>:<desired_path_in_container>
      # pcan (host paths may be different)
      - /usr/include/libpcan.h:/usr/include/libpcan.h:ro
      - /usr/include/pcan.h:/usr/include/pcan.h:ro
      - /usr/include/libpcanfd.h:/usr/include/libpcanfd.h:ro
      - /usr/include/pcanfd.h:/usr/include/pcanfd.h:ro
      - /usr/lib/libpcan.so:/usr/lib/libpcan.so:ro
      - /usr/lib/libpcanbasic.so:/usr/lib/libpcanbasic.so:ro
      - /usr/lib/libpcanfd.so:/usr/lib/libpcanfd.so:ro
      # for GUI applications (e.g. RViz)
      - /tmp/.X11-unix:/tmp/.X11-unix:rw
      - ~/.Xauthority:/root/.Xauthority:ro
      #bashrc
      - ~/.bashrc:/root/.bashrc:ro

    command: /bin/sh -c "while sleep 1000; do :; done"
```

## Running with [VSCode](https://www.ka-raceing.de/)
Using the [Remote Development](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack) Plugin for VSCode enables you to create and work inside a Docker Container as if you were working on your own machine.
An example for the required `.devcontainer.json` file would be
```json
{
    "name": "ros-docker_container",
    "service": "ros-docker",
    "dockerComposeFile": "./docker-compose.yaml",
    "workspaceFolder": "<path_to_the_ws_folder_inside_the_container>",
    "shutdownAction": "stopCompose"
}
```
Any Extensions that should be pre-installed can be installed at this point.
We would recommend installing the [ROS](https://marketplace.visualstudio.com/items?itemName=ms-iot.vscode-ros) and [C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack) Plugins
```json
{
    "name": "ros-docker_container",
    "service": "ros-docker",
    "dockerComposeFile": "./docker-compose.yaml",
    "customizations": {
            "vscode": {
                "extensions": [
                    "ms-iot.vscode-ros",
                    "ms-vscode.cpptools-extension-pack"
                ]
            }
        },
    "workspaceFolder": "<path_to_the_ws_folder_inside_the_container>",
    "shutdownAction": "stopCompose"
}
```
## License

GNU GPL v3
