ARG PARENT_IMAGE
FROM $PARENT_IMAGE

ARG ROS_DISTRO
RUN apt-get update \
    && apt-get install -y \
            ros-${ROS_DISTRO}-desktop \
            ros-${ROS_DISTRO}-turtle-tf2-py \
            ros-${ROS_DISTRO}-tf2-tools \
            ros-${ROS_DISTRO}-tf-transformations \
    && rm -rf /var/lib/apt/lists/*
