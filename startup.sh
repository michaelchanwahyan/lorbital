#!/bin/bash
source /opt/ros/kinetic/setup.bash
date
echo BUILDING UP LIVOX ROS DRIVER ...
echo
cd /SOURCE/ws_livox
catkin_make
date
echo BUILDING UP LIVOX LOAM ROS DRIVER ...
echo
cd /SOURCE/ws_loamlivox
catkin_make

echo goto loam-livox and get the resource by
echo source /SOURCE/ws_loamlivox/devel/setup.bash

