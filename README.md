## Left 4 Dead 2 Dedicated Server + Docker
Running srcds in a docker container. Designed for Left 4 Dead 2, but should work for other source games.

Some code and implementations taken from:
* [https://github.com/startersclan/docker-sourceservers/](https://github.com/startersclan/docker-sourceservers/)
* Forked originally from [https://github.com/Gonzih/docker-csgo-server](https://github.com/Gonzih/docker-csgo-server)

### Docker hub image
[DockerHub](https://hub.docker.com/r/jackzmc/srcds-l4d2)
[Dockerfile](https://github.com/Jackzmc/docker-l4d2-server/blob/base/Dockerfile)
```shell
docker pull jackzmc/srcds-l4d2:base
```


## Notes

* The container will run as root, sourcemod should be installed externally and bind mounted. 
* The default entrypoint is `/bin/bash -c` with no arguments, see examples below.
* The image contains the full game installed by steamcmd, it will not auto download updates.

#### Args:
```env
# Appid of dedicated server
ARG APPID=222860
# Folder name for game within $SERVER_DIR
ARG APPNAME=left4dead2  
# Where server runs from
ARG SERVER_DIR=/server
```
#### Envs:
```env 
APPID - from arg
APPNAME - from arg (folder within $SERVER_DIR)
SERVER_DIR
```

## Examples
```bash
# Generic Server
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:base "./srcds_linux -game left4dead2 -usercon +map c8m1_apartment"
# add extra cvars at the end

# Setting hostname or any variables with spaces
# You should enclose it with quotes (\"), for example:
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:base ./srcds_linux -usercon +hostname "\"My Server With Spaces\""

# Versus Server
docker run -it -p 27015:27015 -p 27015:27015/udp jackzmc/srcds-l4d2:base ./srcds_linux -usercon +map c8m1_apartment versus +sv_gametypes "VERSUS" 

# Run a server with custom addons / sourcemod (external)
docker run -it -p 27015:27015 -p 27015:27015/udp -v /home/steam/l4d2/addons:/server/left4dead2/addons -vjackzmc/srcds-l4d2:sourcemod ./srcds_linux -usercon +map c8m1_apartment 
```
# Building Docker Images
The game files are downloaded externally with steamcmd, this way if you need to change the Dockerfile, you don't need to wait for the entire game to be redownlaoded every time.
The dockerfile pulls from `srcds_cache`, a script to automatically setup steamcmd, install the game, and build the image is provided: `build.sh`

See the SteamCMD documentation for any dependencies needed: [https://developer.valvesoftware.com/wiki/SteamCMD#Manually](https://developer.valvesoftware.com/wiki/SteamCMD#Manually)

You can use steamcmd to download to srcds-cache with this command:
`steamcmd.sh +login aonymous +force_install_dir /path/to/dockerfile/srcds-cache +app_update 222860 +quit`

