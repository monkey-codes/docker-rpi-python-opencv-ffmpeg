FROM resin/rpi-raspbian:stretch
#FROM armv7/armhf-ubuntu

#FROM resin/rpi-raspbian
# 3.5
ENV PYTHON_VERSION 3.5

# Install all dependencies for OpenCV 3.2
RUN apt-get -y update && apt-get -y install python$PYTHON_VERSION-dev wget unzip \
    build-essential cmake git pkg-config libatlas-base-dev gfortran \
    libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev \
    libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libv4l-dev \
    && wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && pip3 install numpy && rm get-pip.py \
    && wget https://github.com/Itseez/opencv/archive/3.2.0.zip -O opencv3.zip \
    && unzip -q opencv3.zip && mv /opencv-3.2.0 /opencv && rm opencv3.zip \
    && wget https://github.com/Itseez/opencv_contrib/archive/3.2.0.zip -O opencv_contrib3.zip \
    && unzip -q opencv_contrib3.zip && mv /opencv_contrib-3.2.0 /opencv_contrib && rm opencv_contrib3.zip \
    && mkdir /opencv/build && cd /opencv/build \
    && cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_PYTHON_SUPPORT=ON \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=/opencv_contrib/modules \
      -D BUILD_EXAMPLES=OFF \
      -D PYTHON_DEFAULT_EXECUTABLE=/usr/bin/python3 \
      -D BUILD_opencv_python3=ON \
      -D BUILD_opencv_python2=OFF \
      -D WITH_IPP=OFF \
      -D WITH_FFMPEG=ON \
      -D WITH_V4L=ON .. \
    && cd /opencv/build && make -j$(nproc) && make install && ldconfig \

    && apt-get -y remove build-essential cmake git pkg-config libatlas-base-dev gfortran \
    libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev \
    libswscale-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libv4l-dev \
    && apt-get clean \
    && rm -rf /opencv /opencv_contrib /var/lib/apt/lists/*

# Define default command.
CMD ["python3"]
