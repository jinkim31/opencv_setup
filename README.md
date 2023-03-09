# OpenCV Setup
 OpenCV setup script for Ubuntu desktops

## Setup Procedure

### 1. Install Nvidia graphics driver
```sh
# Check appropriate driver for your GPU
$ sudo ubuntu-drivers devices
# Install driver
$ sudo apt install [driver_name(e.g. nvidia-driver-525)]
# reboot
$ sudo reboot
# Check installation
$ nvidia-smi
```

### 2. Install CUDA 11.x
https://developer.nvidia.com/cuda-11-8-0-download-archive
- Operating system: Linux
- Archetecture: x86_64
- Distribution: Ubuntu
- Version: 20.04(or whatever version you are running)
- Installer type deb [local]
Check CUDA version you are installing carefully. Some CUDA deprecated features may get removed in the heghier versions and OpenCV won't compile.

### 3. Install cuDNN for CUDA 11.x
https://developer.nvidia.com/cudnn-download-survey
- Download cuDNN Library for Linux (x86_64)
- Extract
- Copy files
```sh
# [extracted_dir] is the folder you extracted downloaded library
$ sudo cp [extracted_dir]/include/cudnn* /usr/local/cuda/include
$ sudo cp [extracted_dir]/lib/libcudnn* /usr/local/cuda/lib64
```

### 5. Run the script
- Open `[dir_to_project]/setup/opencv_setup.sh`
- Edit `cuda_arch="8.9"` to match your GPU(GeForce RTX 4090 -> 8.9). GPU archs are listed here: https://en.wikipedia.org/wiki/CUDA#GPUs_supported.
```sh
$ cd [project_dir]/setup
$ sudo chmod 777 opencv_setup.sh
$ sudo ./opencv_setup.sh
```

### 6. Edit .bashrc
- Open .bashrc
```sh
$ gedit ~/.bashrc
```
- Add following to ~/.bashrc
```sh
export CUDA_HOME=/usr/local/cuda 
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64 
export PATH=$PATH:$CUDA_HOME/bin
```

 Jin Kim @ AnsurLab
