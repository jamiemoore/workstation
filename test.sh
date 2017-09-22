#!/bin/bash
docker build -t 'jamie/dockerws' .
docker run --rm -it -h "dockerws" -v /var/run/docker.sock:/var/run/docker.sock -v home:/home/jamie  -v ${HOME}/projects/dotfiles:/home/jamie/projects/dotfiles -v ${PWD}:/home/jamie/dev-environment jamie/dockerws
#docker volume rm home
