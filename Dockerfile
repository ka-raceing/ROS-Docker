FROM osrf/ros:noetic-desktop-full

# avoid config interfaces
ARG DEBIAN_FRONTEND=noninteractive

# initial update and upgrade
RUN apt-get update && apt-get upgrade -y

#--------------------------------------------------
# build tools & base dependencies
#--------------------------------------------------
RUN apt-get update && apt-get install --install-recommends -y \
    git \
    cmake \
    make \
    gcc \
    g++ \
    gfortran \
    liblapack-dev \
    pkg-config \
    libelf-dev \
    qtdeclarative5-dev \
    qt5-qmake \
    libqglviewer-dev-qt5 \
    libsuitesparse-dev \
    ccache \
    bc \
    software-properties-common \
    lld \
    python-is-python3

# add system76 package archive
RUN apt-add-repository -ys ppa:system76-dev/stable \
    && apt-get update \
    && apt-get -y --fix-broken install


#--------------------------------------------------
# monitoring tools
#--------------------------------------------------
RUN apt-get update && apt-get install --install-recommends -y \
    htop \
    ros-noetic-rqt-multiplot \
    ros-noetic-plotjuggler-ros \
    ros-noetic-rosmon

#--------------------------------------------------
# debugging tools
#--------------------------------------------------
RUN apt-get update && apt-get install --install-recommends -y \
    gdb