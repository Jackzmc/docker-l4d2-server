## Left 4 Dead 2 Dedicated Server + Docker [![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/Gonzih/docker-csgo-server/blob/master/LICENSE.md)
L4D2 server in docker 

### Docker hub image
[DockerHub](https://hub.docker.com/r/jackzmc/srcds-l4d2)
```shell
docker pull jackzmc/srcds-l4d2
```

### Tag Descriptions / Dockerfile Links
* [Latest](https://github.com/Jackzmc/docker-l4d2-server/blob/master/Dockerfile) - The latest, full game image.
* [Bare](https://github.com/Jackzmc/docker-l4d2-server/blob/bare/Dockerfile) - Does not contain a predownloaded game image, must be installed on start
* [Sourcemod](https://github.com/Jackzmc/docker-l4d2-server/blob/sourcemod/Dockerfile) - Contains bare version with sourcemod preinstalled
* [Sourcemod-full](https://github.com/Jackzmc/docker-l4d2-server/blob/sourcemod-full/Dockerfile) - Contains full version with sourcemod preinstalled

#### Envs:
```env 
USER - username for /home/ dir (default: steam)
SERVER - where to store data files (steamcmd & csgo dir, defaults to /home/$USER/server )
```

### Details:
You can create new Dockerfile based on that image and customize it with plugins, configs, CMD and ENTRYPOINT instructions.

Also you can create volumes with the `-v` flag that point to the host for these directories:
* /data/addons - Copied to the left4dead2 addon folder on start (left4dead2/addons)
* /data/configs - Copied to the game's configs folder (left4dead2/cfgs)
* /data/sm-plugins - Copied to sourcemod plugins folder
* /data/sm-configs - Copied to sourcemod configs folder

## Examples
```bash
# Generic Server
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:[tag-name] -usercon +map c8m1_apartment
# add extra cvars at the end

# Setting hostname or any variables with spaces
# You should enclose it with quotes (\"), for example:
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:[tag-name] -usercon +hostname "\"My Server With Spaces\""

# Versus Server
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:[tag-name] -usercon +map c8m1_apartment versus +sv_gametypes "VERSUS" 

# Run a server with sourcemod configs & plugins
docker run -it -p 27015:27015 -p 27015:27015/udp -v /home/jackz/sourcemod-plugins:/data/sm-plugins -v /home/jackz/sourcemod-configs/configs:/data/sm-configs jackzmc/srcds-l4d2:sourcemod -usercon +map c8m1_apartment 
#you can also use sourcemod-full if you are going to be restarting it often

```
# Building Docker Images
The bare and sourcemod branches should contain all elements you need to build the image, but the master/latest branch will require you to have a cache copy of l4d2 installed. This folder should be where the Dockerfile exists, and should be called `srcds-cache`. 

```shell
# Build custom image
docker build -t l4d2 github.com/jackzmc/docker-l4d2-server
```

You can use steamcmd to download to srcds-cache with this command:
`steamcmd.sh +login aonymous +force_install_dir /path/to/dockerfile/srcds-cache +app_update 222860 +quit`

