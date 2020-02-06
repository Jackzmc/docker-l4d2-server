## Counter Strike Global Offensive + Docker [![License](http://img.shields.io/:license-mit-blue.svg)](https://github.com/Gonzih/docker-csgo-server/blob/master/LICENSE.md)
CS:GO server in docker with 128 tick enabled by default.

Original creator: [Gonzih/docker-csgo-server](https://github.com/Gonzih/docker-csgo-server)

### Docker hub image
[DockerHub](https://hub.docker.com/r/jackzmc/srcds-csgo)
```shell
docker pull jackzmc/srcds-csgo
```

### Tag Descriptions / Dockerfile Links
* [Latest](https://github.com/Jackzmc/docker-csgo-server/blob/master/Dockerfile) - The latest, full game image.
* [Bare](https://github.com/Jackzmc/docker-csgo-server/blob/bare/Dockerfile) - Does not contain a predownloaded game image, must be installed on start
* [Sourcemod](https://github.com/Jackzmc/docker-csgo-server/blob/sourcemod/Dockerfile) - Contains bare version with sourcemod preinstalled

#### Envs:
```env 
USER - username for /home/ dir (default: steam)
SERVER - where to store data files (steamcmd & csgo dir, defaults to /home/$USER/server )
```

### Details:
By default image is build with enabled autoupdate feature (take a look at `csgo.sh` file).
You can create new Dockerfile based on that image (FROM csgo) and customize it with plugins, configs, CMD and ENTRYPOINT instructions.

Also you can create volumes with the `-v` flag that point to the host for these directories:
* /home/steam/csgo
* /home/steam/csgo/csgo/cfg
* /home/steam/csgo/csgo/addons


```shell
# Build image and tag it as csgo
docker build -t csgo github.com/jackzmc/docker-csgo-server

# Run image with default options (CMD in Dockerfile)
docker run -d -p 27015:27015 -p 27015:27015/udp csgo

# Run image with hostname and GLST token, classic casual server
docker run -it -p 27032:27015 -p 27032:27015/udp csgo -console -usercon +mapgroup mg_active +map de_cache +hostname "\"MyCsgoServer\"" +sv_steamaccount "\"GSLT TOKEN HERE\""
# (to have spaces in hostname you need to escape quotes: \"

# Run a private server, with rcon and password
docker run -it -p 27032:27015 -p 27032:27015/udp csgo -console -usercon +mapgroup mg_active +map de_cache +rcon_password "mypass" +sv_password "serverpass"

# Run image with as Classic Casual server
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_cache

# Run image with as Classic Competetive server
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_cache

# Run image with as Arm Race server
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 1 +game_mode 0 +mapgroup mg_armsrace +map ar_shoots

# Run image with as Demolition server
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 1 +game_mode 1 +mapgroup mg_demolition +map de_lake

# Run image with as Deathmatch server
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 1 +game_mode 2 +mapgroup mg_allclassic +map de_dust

# To run lan server just add `+sv_lan 1` at end of command
docker run -d -p 27015:27015 -p 27015:27015/udp csgo -console -usercon +game_type 0 +game_mode 1 +mapgroup mg_active +map de_cache +sv_lan 1
```

### Running public server

To run public server you need to [Register Login Token](http://steamcommunity.com/dev/managegameservers) and adding `+sv_setsteamaccount THISGSLTHERE -net_port_try 1` to the server command
Refer to [Docs](https://developer.valvesoftware.com/wiki/Counter-Strike:_Global_Offensive_Dedicated_Servers#Registering_Game_Server_Login_Token) for more details.

