# General description
This MRI_suite is for MRI data processing and analysis with AFNI.

With this suite, one could run analysis on different platforms, macOS, linux or windows. 

To begin with, one should build the image or directly pull the pre-built image. Several settings need to be fixed for specific aims (see below).

# Pull and push
Use the github workflow to automatically build the image after push to the github repository. 

# Mount local data
Usually we want to mount local data to the container, set this when run this image by
```
docker run -v local_path:container_path image_name
```
Here `-v` sets the to be mounted *local path* to the *container path* so we could find the local files in the container path. 

# Open GUI apps
Some applications have GUIS, such as AFNI, and we need to operate based on the GUI, so it is usually necessary to construct an environment where we can open the GUIS. Generally we use X11 servers on the local computers to receives the graphical outputs from the containers, so we could open the GUIs as our local applications. 

## For windows
### Use MobaXterm
Download [MobaXterm](https://mobaxterm.mobatek.net/) and the [docker desktop for windows](https://www.docker.com/products/docker-desktop/).

Setup the MobaXterm following this [instruction](https://www.rootisgod.com/2021/Running-Linux-Desktop-Apps-From-a-Docker-Container-on-Windows-with-MobaXterm/).

### Use VcXsrv
Download [VcXsrv](https://sourceforge.net/projects/vcxsrv/files/latest/download) and the [docker desktop for windows](https://www.docker.com/products/docker-desktop/).

Open *XLaunch* and select the wanted window type. **Disable access control** and **Off the native opengl**.

#### If use WSL2
Open the windows powershell. Do `ipconfig` to find the IPv4 address of the WSL. Do
```
docker run --rm -it -e DISPLAY=IP_address:0.0 image_name:tag
```
to entry the bash. Now `afni` can open the GUIS.

#### If use WSL1
*Not tested*:
```
docker run --rm -it -e DISPLAY=:0.0 image_name:tag
```

# Useful commands
To see the helper
```
docker build --help
```

To build an image
```
docker build -t mri_suite:0.1 .
```

To run an iamge
```
docker run mri_suite:0.1
```

To use the bash terminal in the imaged system
```
docker run -it mri_suite:0.1
```

To open the GUI 
```
    docker run --rm -ti                  \
        --user=`id -u`                   \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY=${DISPLAY}            \
        -v ${HOME}:/opt/home             \
        afni/afni_make_build
```
`-v loca_path:docker_path` mount the local paths to the docker
