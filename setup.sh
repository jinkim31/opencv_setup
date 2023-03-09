#!/bin/bash

opencv_version="4.6.0"
cuda_arch="8.6"
build_type="DEBUG"

printf 'Install Opencv %s with CUDA arch %s (y/n)? ' $opencv_version $cuda_arch
read answer
if [ "$answer" != "${answer#[Nn]}" ] ;then
    exit 0
fi

sudo apt-get update

echo "==========Installing opencv dependencies=========="
sudo apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install -y python3.8-dev python-dev python-numpy python3-numpy
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2 v4l2ucp
sudo apt-get install -y curl

echo "==========Downloading OpenCV=========="
curl -L https://github.com/opencv/opencv/archive/${opencv_version}.zip -o opencv-${opencv_version}.zip
curl -L https://github.com/opencv/opencv_contrib/archive/${opencv_version}.zip -o opencv_contrib-${opencv_version}.zip
unzip opencv-${opencv_version}.zip
unzip opencv_contrib-${opencv_version}.zip
rm opencv-${opencv_version}.zip opencv_contrib-${opencv_version}.zip

echo "==========Building OpenCV=========="
cd opencv-${opencv_version}/
mkdir release
cd release
cmake \
-D WITH_CUDA=ON \
-D WITH_CUDNN=ON \
-D OPENCV_DNN_CUDA=ON \
-D CUDA_FAST_MATH=ON \
-D WITH_CUFFT=ON \
-D WITH_FFMPEG=ON \
-D WITH_QT=OFF \
-D WITH_GTK=ON \
-D WITH_GTK_2_X=ON \
-D WITH_OPENGL=ON \
-D CUDA_ARCH_BIN=${cuda_arch} \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${opencv_version}/modules \
-D WITH_LIBV4L=ON \
-D BUILD_opencv_python3=ON \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_EXAMPLES=OFF \
-D CMAKE_BUILD_TYPE=${build_type} \
-D OPENCV_ENABLE_NONFREE=ON \
-D BUILD_TIFF=ON \
-D CMAKE_INSTALL_PREFIX=/usr/local/opencv-${opencv_version}-release ..
make -j$(nproc)

printf 'Build completed and will be install at /usr/local/opencv-%s. continue(y/n)? ' $opencv_version $opencv_version
read answer
if [ "$answer" != "${answer#[Nn]}" ] ;then 
    exit 0
fi

echo "==========Installing OpenCV=========="
sudo make install

echo "==========Adding user to video group=========="
sudo adduser $USER video

echo "==========Done!=========="
