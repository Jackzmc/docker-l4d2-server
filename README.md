# Left 4 Dead 2 Dedicated Server in Docker

![content.yaml status](https://git.jackz.me/jackz/docker-l4d2-server/badges/workflows/content.yaml/badge.svg)
[!build.yaml status](https://git.jackz.me/jackz/docker-l4d2-server/badges/workflows/build.yaml/badge.svg)

Running srcds in a docker container. Designed for Left 4 Dead 2, but could work for other source games.

Some code and implementations taken from:
* [https://github.com/startersclan/docker-sourceservers/](https://github.com/startersclan/docker-sourceservers/)
* Forked originally from [https://github.com/Gonzih/docker-csgo-server](https://github.com/Gonzih/docker-csgo-server)

## Image

Build image is ~3.3 GB, content image is 4.8 GB. My server has terrible upload speed, so get the images from github instead:

```shell
docker pull ghcr.io/jackzmc/srcds-l4d2:master
```

## Notes

* Addons, sourcemod, etc should be installed externally and bind mounted, `-v ./addons:/server/left4dead2/addons`
* Runs as unprivileged 'steam' user (default uid/gid 1003, change with GID/UID build args) 
* The default entrypoint is `/bin/bash ./docker-entrypoint.sh` with no extra arguments besides (-nowatchdog -norestart)
* The image contains the full game installed by steamcmd, it will not auto download updates.
* The `-nowatchdog` flag is necessary to prevent SIGALARM (Alarm Clock) crashes

### Args

```env
# Appid of dedicated server
ARG APPID=222860
# Folder name for game within $SERVER_DIR
ARG APPNAME=left4dead2  
# Where server runs from
ARG SERVER_DIR=/server
```

### Envs

```env
APPID - from arg
APPNAME - from arg (folder within $SERVER_DIR)
SERVER_DIR
```

## Examples

```bash
# Generic Server
docker run -it -p 27015:27015 -p 27015:27015/udp ghcr.io/jackzmc/srcds-l4d2:master "-usercon +map c8m1_apartment"
# add extra cvars at the end

# Setting hostname or any variables with spaces
# You should enclose it with quotes (\"), for example:
docker run -it -p 27015:27015 -p 27015:27015/udp ghcr.io/jackzmc/srcds-l4d2:master "+hostname "\"My Server With Spaces\""

# Versus Server
docker run -it -p 27015:27015 -p 27015:27015/udp ghcr.io/jackzmc/srcds-l4d2:master +map c8m1_apartment versus +sv_gametypes "VERSUS" 

# Run a server with custom addons / sourcemod (external)
docker run -it -p 27015:27015/udp -v /home/steam/l4d2/addons:/server/left4dead2/addons ghcr.io/jackzmc/srcds-l4d2:master
```
## Building

There are two images, a content image (srcds-l4d2-content:latest) and the server image itself (srcds-l4d2:master). The server copies server content from the content image. Content image only needs to rebuilt when the game updates.
