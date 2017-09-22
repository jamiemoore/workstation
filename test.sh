#!/bin/bash
docker build -t 'jamie/ws-setup' .
docker run --rm -it -h "dockerws" -v /var/run/docker.sock:/var/run/docker.sock -v home:/home/jamie -v ${PWD}:/home/jamie/workstation-setup jamie/ws-setup
#docker volume rm home
