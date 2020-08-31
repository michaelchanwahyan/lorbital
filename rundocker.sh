#!/bin/sh
clear
docker rm -f sleepy_snorlax
export TZ=Asia/Hong_Kong
mem=$(free -g | head -2 | tail -1 | awk -F " " '{print $2}') # if you run to error, set mem to your system memory (in GB unit)
target_mem=$(echo "$mem * 0.9" | bc) # if you run to error, install bc
xhost +local:docker
docker run -dt \
           --name=sleepy_snorlax \
           --memory="$target_mem"g \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v /data:/data \
           lorbital:latest \
           systemd
