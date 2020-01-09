FROM ubuntu:18.04 as builder
# Reference:
# https://www.pyimagesearch.com/2018/05/28/ubuntu-18-04-how-to-install-opencv/
RUN apt-get update

RUN apt-get -y install build-essential cmake unzip pkg-config
RUN apt-get -y install libjpeg-dev libpng-dev libtiff-dev

RUN apt-get -y install software-properties-common

RUN apt-get -y install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
RUN apt-get -y install libxvidcore-dev libx264-dev
RUN apt-get -y install libatlas-base-dev gfortran
RUN apt-get -y install wget

WORKDIR /app/opencv
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.4.zip
RUN unzip opencv.zip
RUN mv opencv-3.4.4 opencv

WORKDIR /app/opencv/opencv/build
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
  -D CMAKE_INSTALL_PREFIX=/usr/local \
  -D WITH_CUDA=OFF \
  -D INSTALL_PYTHON_EXAMPLES=OFF \
  -D OPENCV_ENABLE_NONFREE=OFF \
  -D BUILD_SHARED_LIBS=OFF \
  -D WITH_QT=OFF \
  -D WITH_GTK=OFF \
  -D WITH_TIFF=OFF \
  -D WITH_PNG=OFF \
  -D WITH_JASPER=OFF \
  -D BUILD_EXAMPLES=OFF ..
RUN make 

COPY . /cc-opencv
ENV OpenCV_DIR=/app/opencv/opencv/build

WORKDIR /cc-opencv/build

RUN cmake -D BUILD_SHARED_LIBS=OFF .. && make

FROM alpine

COPY --from=builder /cc-opencv/build/cc-opencv /app/detect

COPY ./haarcascades /app/models

WORKDIR /app
