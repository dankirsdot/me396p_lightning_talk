#!/bin/bash

GUI=${1:-"native"}
IMAGE_NAME="me396p/ros:humble"

SRC_PATH=${PWD/container/src}

# check if docker or podman are available in the system
if [ -x "$(command -v docker)" ]; then
    CONTAINER_ENGINE=docker
elif [ -x "$(command -v podman)" ]; then
    CONTAINER_ENGINE=podman
else
    echo "There is no container engine!"
    exit 0
fi

if [ $GUI == "native" ]; then
    # build an image
    $CONTAINER_ENGINE build -t $IMAGE_NAME $PWD

    # run it
    xhost +local:docker
    DISPLAY=:1.0
    $CONTAINER_ENGINE run -it \
                        --net=host \
                        --device /dev/dri/ \
                        -e DISPLAY=$DISPLAY \
                        -v $HOME/.Xauthority:/root/.Xauthority:ro \
                        -v $SRC_PATH:/demo/src \
                        $IMAGE_NAME
elif [ $GUI == "vnc" ]; then
    # run ready container from Dockerhub
    $CONTAINER_ENGINE run -p 6080:80 \
                        --shm-size=512m \
                        --security-opt seccomp=unconfined \
                        -v $SRC_PATH:/home/ubuntu/demo/src \
                        docker.io/tiryoh/ros2-desktop-vnc:humble
else
    echo "There is not such a GUI type!"
fi
