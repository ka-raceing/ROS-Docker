FROM osrf/ros:noetic-desktop-full

# avoid config interfaces
ARG DEBIAN_FRONTEND=noninteractive

# initial update and upgrade
RUN apt-get update && apt-get upgrade -y

#--------------------------------------------------
# build tools & base dependencies
#--------------------------------------------------
RUN apt-get update && apt-get install --install-recommends -y \
    automake \
    bc \
    bison \
    ccache \
    clang \
    clang-format \
    clang-tidy \
    cmake \
    cppcheck \
    flex \
    g++ \
    gcc \
    gfortran \
    git \
    libelf-dev \
    liblapack-dev \
    libqglviewer-dev-qt5 \
    libspdlog-dev \
    libsuitesparse-dev \
    libtool \
    libpcap-dev \
    libyaml-cpp-dev \
    lld \
    m4 \
    make \
    pkg-config \
    python-is-python3 \
    qt5-qmake \
    qtdeclarative5-dev \
    sl \
    software-properties-common \
    texinfo \
    vim \
    bash-completion \
    curl \
    wget

# Install fzf, fuzzy find tool for commandline
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf \
    && ~/.fzf/install


# add system76 package archive
RUN apt-add-repository -ys ppa:system76-dev/stable \
    && apt-get update \
    && apt-get -y --fix-broken install

#--------------------------------------------------
# shared dependencies
#--------------------------------------------------
#osqp
COPY dependencies/osqp /tmp/osqp
RUN mkdir /tmp/osqp/build
WORKDIR /tmp/osqp/build
RUN cmake -G "Unix Makefiles" ..
RUN cmake --build . --target install

#osqp-eigen
COPY dependencies/osqp-eigen /tmp/osqp-eigen
RUN mkdir /tmp/osqp-eigen/build
WORKDIR /tmp/osqp-eigen/build
RUN cmake -G "Unix Makefiles" ..
RUN make
RUN make install

#fmt
COPY dependencies/fmt /tmp/fmt
RUN mkdir /tmp/fmt/build
WORKDIR /tmp/fmt/build
RUN cmake -DBUILD_SHARED_LIBS=TRUE ..
RUN make install

#qpmad
COPY dependencies/qpmad /tmp/qpmad
RUN mkdir /tmp/qpmad/build
WORKDIR /tmp/qpmad/build
RUN cmake ..
RUN make install

#rosparam_handler
RUN mkdir -p /tmp/rosparam_handler_ws/src
COPY dependencies/rosparam_handler /tmp/rosparam_handler_ws/src
WORKDIR /tmp/rosparam_handler_ws
RUN . /opt/ros/noetic/setup.sh \ 
    && catkin_make -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic/
WORKDIR /tmp/rosparam_handler_ws/build
RUN . /opt/ros/noetic/setup.sh \ 
    && make install

#--------------------------------------------------
# control dependencies
#--------------------------------------------------
#swig
COPY dependencies/swig /tmp/swig
WORKDIR /tmp/swig
RUN ./autogen.sh
RUN ./configure
RUN make -j3 && make install

#casadi
COPY dependencies/casadi /tmp/casadi
RUN mkdir /tmp/casadi/build
WORKDIR /tmp/casadi/build
RUN cmake -DWITH_PYTHON=ON -DWITH_OSQP=OFF ..
RUN make -j3 && make install

#gsl
COPY dependencies/GSL /tmp/gsl
WORKDIR /tmp/gsl
RUN ./autogen.sh
RUN ./configure
RUN make -j3 && make install

#blasfeo
COPY dependencies/blasfeo /tmp/blasfeo
WORKDIR /tmp/blasfeo
RUN make -j3 static_library && make install_static

#hpipm
COPY dependencies/hpipm /tmp/hpipm
WORKDIR /tmp/hpipm
RUN make shared_library && make install_shared

#--------------------------------------------------
# slam dependencies
#--------------------------------------------------
# g2o
COPY dependencies/g2o /tmp/g2o
RUN mkdir /tmp/g2o/build
WORKDIR /tmp/g2o/build
RUN cmake .. && make -j3 && make install

# mrpt
RUN add-apt-repository -y ppa:joseluisblancoc/mrpt-stable
RUN apt-get update && apt-get install -y \
    libmrpt-dev \
    mrpt-apps

# rviz plugin
RUN apt-get update && apt-get install -y \
    ros-noetic-jsk-rviz-plugins

#--------------------------------------------------
# trajectory dependencies
#--------------------------------------------------
RUN apt-get update && apt-get install -y \
    pip \
    python3-tk
RUN pip install scikit-learn

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

#--------------------------------------------------
# post installation steps
#--------------------------------------------------
COPY .bashrc /root/.bashrc
COPY .bash_aliases /root/.bash_aliases
COPY bagger /usr/local/bin

#remove /opt/ros/noetic/include/fmt because we're using a different version of fmt than ROS
RUN rm -rf /opt/ros/noetic/include/fmt 

# set working directory and shell
WORKDIR /
CMD ["bash"]
