# Dockerfile for building general development
# environment for orbital
FROM ubuntu:16.04
LABEL maintainer "michaelchan_wahyan@yahoo.com.hk"

ENV SHELL=/bin/bash \
    TZ=Asia/Hong_Kong \
    PYTHONIOENCODING=UTF-8 \
    PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin:/usr/lib:/usr/local/lib:/SOURCE/orbital/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib \
    LD_LIBRARY_PATH=/usr/local/lib:/SOURCE/orbital/build:/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib \
    LIBRARY_PATH=/SOURCE/pcl/build:/SOURCE/pcl/build/lib:/SOURCE/vtk_7_1_0/build:/SOURCE/vtk_7_1_0/build/lib \
    CPLUS_INCLUDE_PATH=/SOURCE/orbital \
    BOOST_SYSTEM_LIBRARY=/SOURCE/boost-1.61.0/bin.v2/libs

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak ;\
    cat /etc/apt/sources.list.bak | sed 's/archive/hk.archive/' > /etc/apt/sources.list ;\
    apt-get -y update ;\
    apt-get -y upgrade

RUN apt -y install lsb-release apt-utils ;\
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' ;\
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 ;\
    apt -y update

RUN apt -y install libgoogle-glog-dev libatlas-base-dev libeigen3-dev \
                   libsuitesparse-dev build-essential autotools-dev \
                   libicu-dev libbz2-dev python-dev freeglut3-dev \
                   libjsoncpp-dev libcurl4-openssl-dev libpcap-dev \
                   libavcodec-dev libavformat-dev libswscale-dev \
                   libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
                   libgtk2.0-dev libgtk-3-dev libpng-dev libjpeg-dev \
                   libopenexr-dev libtiff-dev libwebp-dev

RUN apt -y install screen apt-utils htop wget curl net-tools \
                   cmake gcc make g++ gfortran ca-certificates \
                   musl-dev vim nano git apt-transport-https bc \
                   pkg-config doxygen firefox cowsay fortune sl

RUN apt -y install ros-kinetic-cv-bridge \
                   ros-kinetic-tf \
                   ros-kinetic-message-filters \
                   ros-kinetic-image-transport \
                   ros-kinetic-nav-msgs \
                   ros-kinetic-pcl-ros \
                   ros-kinetic-desktop-full

RUN apt -y install python-dev python-numpy python3-dev python3-numpy \
                   python-rosinstall-generator python-wstool \
                   python-rosdep python-rosinstall

RUN DEBIAN_FRONTEND=noninteractive \
    apt -y install xorg openbox xauth xserver-xorg-core xserver-xorg \
                   ubuntu-desktop x11-xserver-utils

RUN mkdir /SOURCE

RUN cd /SOURCE ; wget http://ceres-solver.org/ceres-solver-1.14.0.tar.gz ;\
    tar -zxvf ceres-solver-1.14.0.tar.gz ; cd ceres-solver-1.14.0 ;\
    mkdir build ; cd build ; cmake .. ; make -j8 ; make install

RUN cd /SOURCE ; git clone https://github.com/opencv/opencv.git ;\
    cd opencv ; git checkout tags/4.4.0 ;\
    mkdir build ; cd build ; cmake .. ; make -j8 ; make install

RUN cd /SOURCE ; git clone https://github.com/Livox-SDK/Livox-SDK.git ;\
    git checkout tags/v2.1.1 ; cd Livox-SDK ;\
    bash ./third_party/apr/apr_build.sh ;\
    mkdir -p build ; cd build ; cmake .. ; make -j8 ; make install

RUN cd /SOURCE ; mkdir -p ws_livox/src ;\
    git clone https://github.com/Livox-SDK/livox_ros_driver.git ws_livox/src ;\
    cd ws_livox/src/livox_ros_driver ; git checkout tags/v2.5.0

RUN cd /SOURCE ; mkdir catkin_ws ; cd catkin_ws ; mkdir src ; cd src ;\
    git clone https://github.com/hku-mars/loam_livox.git ; cd loam_livox ;\
    git checkout tags/V1.0.0

COPY [ ".bashrc" , ".vimrc" , "/root/" ]

CMD [ "/bin/bash" ]
