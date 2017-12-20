# Dockerfile - python, opencv and ffmpeg on ARM Architecture
This image is based on [docker-python-opencv-ffmpeg](https://github.com/Valian/docker-python-opencv-ffmpeg) with the base image changed from ubuntu to **resin/rpi-raspbian:stretch**.

## Building the image
The image needs to be **built on ARM architecture**, I used a Raspberry Pi3 to create the image. To build it from scratch will take a couple of hours since opencv needs to be compiled with ffmpeg support for video processing.

1) Download [Raspbian Stretch](https://www.raspberrypi.org/downloads/raspbian/) and [install](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) it.
2) Optionally [setup wifi on the pi](https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md).
3) [Install docker](https://iotbytes.wordpress.com/setting-up-docker-on-raspberry-pi-and-running-hello-world-container/):
```bash
$ sudo apt-get update && sudo apt-get upgrade
$ curl -sSL https://get.docker.com | sh
$ sudo usermod -aG docker pi
$ docker --version
Docker version 17.05.0-ce, build 89658be
```
4) I had to add boot parameters to get docker to work property, add `cgroup_enable=memory cgroup_memory=1 swapaccount=1` to `/boot/cmdline.txt`
```
$ cat /boot/cmdline.txt
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=PARTUUID=243e3d50-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=memory cgroup_memory=1 swapaccount=1
```
5) Optionally enable ssh `raspi-config to enable ssh`
6) Build the image. Since it may take a while you may want to run it in a screen session if you are ssh'ing into the pi
```bash
$ apt-get install screen
$ screen
$ git clone git@github.com:monkey-codes/docker-rpi-python-opencv-ffmpeg.git
$ cd docker-rpi-python-opencv-ffmpeg
$ docker build -t monkeycodes/rpi-python-opencv-ffmpeg .
```
You can detach from the screen session that is building the image by pressing `Ctrl-a d` and re-attach to the screen by running `screen -r`

## Usage
The image can be pulled from docker hub, which will be much faster than doing building the image (which does the opencv compilation).
```
$ docker pull monkeycodes/rpi-python-opencv-ffmpeg
$ docker run --rm -it -v $PWD:/srv monkeycodes/rpi-python-opencv-ffmpeg python
>>> import cv2; cv2.VideoCapture('/srv/example.mp4').read()
# truncated for transparency
(True, array([[[ 46, 112, 104], ...]], dtype=uint8))
```
```
