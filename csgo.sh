#!/bin/sh
./srcds_run -game csgo -tickrate 128 -autoupdate -steam_dir ~/ -steamcmd_script csgo_ds.txt $@
