## Left 4 Dead 2 Dedicated Server + Docker [![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/Gonzih/docker-csgo-server/blob/master/LICENSE.md)
L4D2 server in docker 

### Docker hub image
[DockerHub](https://hub.docker.com/r/jackzmc/srcds-csgo)
```shell
docker pull jackzmc/srcds-l4d2
```

### Tag Descriptions / Dockerfile Links
* [Latest](https://github.com/Jackzmc/docker-l4d2-server/blob/master/Dockerfile) - The latest, full game image.
* [Bare](https://github.com/Jackzmc/docker-l4d2-server/blob/bare/Dockerfile) - Does not contain a predownloaded game image, must be installed on start
* [Sourcemod](https://github.com/Jackzmc/docker-l4d2-server/blob/sourcemod/Dockerfile) - Contains bare version with sourcemod preinstalled

#### Envs:
```env 
USER - username for /home/ dir (default: steam)
SERVER - where to store data files (steamcmd & csgo dir, defaults to /home/$USER/server )
```

### Details:
You can create new Dockerfile based on that image and customize it with plugins, configs, CMD and ENTRYPOINT instructions.

Also you can create volumes with the `-v` flag that point to the host for these directories:
* /home/steam/server/left4dead2
* /home/steam/server/left4dead2/cfg
* /home/steam/server/left4dead2/addons


```shell
# Build image and tag it as csgo
docker build -t csgo github.com/jackzmc/docker-l4d2-server

# Run image with default options (CMD in Dockerfile)
docker run -d -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:latest
```

# Building Docker Images
The bare and sourcemod branches should contain all elements you need to build the image, but the master/latest branch will require you to have a cache copy of l4d2 installed. This folder should be where the Dockerfile exists, and should be called `srcds-cache`. 

You can use steamcmd to download to there with this command:
`steamcmd.sh +login aonymous +force_install_dir /path/to/dockerfile/srcds-cache +app_update 222860 +quit`

