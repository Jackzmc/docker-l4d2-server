# Left 4 Dead 2 Dedicated Server in Docker

Running srcds in a docker container. Designed for Left 4 Dead 2, but should work for other source games.

Some code and implementations taken from:
* [https://github.com/startersclan/docker-sourceservers/](https://github.com/startersclan/docker-sourceservers/)
* Forked originally from [https://github.com/Gonzih/docker-csgo-server](https://github.com/Gonzih/docker-csgo-server)

## Image

[Dockerfile](https://github.com/Jackzmc/docker-l4d2-server/blob/base/Dockerfile)
```shell
docker pull git.jackz.me/jackz/srcds-l4d2:master
```

## Notes

* Addons, sourcemod, etc should be installed externally and bind mounted.
* Runs as unprivileged 'steam' user (uid/gid 1003) 
* The default entrypoint is `/bin/bash` with no arguments, see examples below.
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
docker run -it -p 27015:27015 -p 27015:27015/udp git.jackz.me/jackz/srcds-l4d2:master ".-game left4dead2 -nowatchdog -usercon +map c8m1_apartment"
# add extra cvars at the end

# Setting hostname or any variables with spaces
# You should enclose it with quotes (\"), for example:
docker run -it -p 27015:27015 -p 27015:27015/udp git.jackz.me/jackz/srcds-l4d2:master ./srcds_linux -nowatchdog +hostname "\"My Server With Spaces\""

# Versus Server
docker run -it -p 27015:27015 -p 27015:27015/udp git.jackz.me/jackz/srcds-l4d2:master ./srcds_linux -nowatchdog +map c8m1_apartment versus +sv_gametypes "VERSUS" 

# Run a server with custom addons / sourcemod (external)
docker run -it -p 27015:27015/udp -v /home/steam/l4d2/addons:/server/left4dead2/addons -vjackzmc/srcds-l4d2:sourcemod ./srcds_linux -usercon +map c8m1_apartment 
```
## Building

There are two images, a content image (srcds-l4d2-content:latest) and the server image itself (srcds-l4d2:master). The server copies server content from the content image. Content image only needs to rebuilt when the game updates.
