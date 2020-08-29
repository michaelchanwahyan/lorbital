#!/bin/sh
docker build -t lorbital:latest ./
docker rmi   -f $(docker images -f "dangling=true" -q)
