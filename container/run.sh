#!/bin/bash

GUI=${1:-"native"}

ROS_DISTRO=humble
IMAGE_NAME="me396p/ros:$ROS_DISTRO"

SCRIPT_PATH=$(readlink -f $BASH_SOURCE)
CONTAINER_PATH="${SCRIPT_PATH%/*}/"
WORKSPACE_PATH=${CONTAINER_PATH/container/workspace}

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
    #set parent image
    PARENT_IMAGE="docker.io/ros:$ROS_DISTRO"
    
    # build an image
    $CONTAINER_ENGINE build -t $IMAGE_NAME $CONTAINER_PATH \
        --build-arg PARENT_IMAGE=$PARENT_IMAGE \
        --build-arg ROS_DISTRO=$ROS_DISTRO

    # run it
    xhost +local:docker
    DISPLAY=:1.0
    $CONTAINER_ENGINE run -it \
                        --net=host \
                        --device /dev/dri/ \
                        -e DISPLAY=$DISPLAY \
                        -v $HOME/.Xauthority:/root/.Xauthority:ro \
                        -v $WORKSPACE_PATH:/workspace/src \
                        $IMAGE_NAME
elif [ $GUI == "vnc" ]; then
    # set parent image
    PARENT_IMAGE="docker.io/tiryoh/ros2-desktop-vnc:$ROS_DISTRO"
    
    # build an image
    $CONTAINER_ENGINE build -t $IMAGE_NAME $CONTAINER_PATH \
        --build-arg PARENT_IMAGE=$PARENT_IMAGE \
        --build-arg ROS_DISTRO=$ROS_DISTRO
    
    # run it
    $CONTAINER_ENGINE run -p 6080:80 \
                        --shm-size=512m \
                        --security-opt seccomp=unconfined \
                        -v $WORKSPACE_PATH:/home/ubuntu/workspace/src \
                        $IMAGE_NAME
else
    echo "There is not such a GUI type!"
fi
