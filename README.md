# MRI Suite for AFNI

A Docker-based environment for MRI data processing and analysis with [AFNI](https://afni.nimh.nih.gov/). 


## Building

The correct `Dockerfile` depends on your CPU architecture:

| Platform | Architecture | Dockerfile |
| --- | --- | --- |
| Windows | amd64 | `Dockerfile` |
| macOS (Intel) | amd64 | `Dockerfile` |
| macOS (M-series chips) | arm64 | `Dockerfile_arm64` |

**macOS with Apple Silicon (arm64):**

```bash
# with Docker
docker build -t mri_suite_afni:latest .

# with Apple Container
container build -t mri_suite_afni:latest .
```

> **Tip:** Give the builder enough memory. Low memory during the build can fail the R package setup. For example, with Apple Container:
>
> ```bash
> container builder start --memory 8g
> ```

**Cross-build an amd64 image on Apple Silicon:**

You can build the amd64 image with the common `Dockerfile` on M-series chips by specifying the platform:

```bash
docker build --platform linux/amd64 -t mri_suite_afni_amd64:latest .
```

---

## Mounting data

To make local data available inside the container, mount it at run time:

```bash
docker run -v local_path:container_path image_name
```

Here `-v` maps the *local path* to the *container path*, so files on your machine can be found at `container_path` inside the container.

The image also includes `sshfs`, so you can mount remote servers inside the container as well.

---

## Opening GUI apps

Some applications (such as AFNI) have GUIs. To use them, you need a way to display the container's graphical output on your local machine. This is usually done with an **X11 server** running on the host, plus a `DISPLAY` environment variable that tells the container which IP address to send the graphics to.

### macOS

Install an X server such as [XQuartz](https://www.xquartz.org/).

When running or creating a container, pass the `DISPLAY` variable:

- **Docker:** `-e DISPLAY=host.docker.internal:0`
- **Apple Container:** `-e DISPLAY=192.168.64.1:0` (a common practice)

To open the AFNI GUI:

1. Start XQuartz, then allow connections from the container host:
   ```bash
   xhost + $(hostname)
   ```
2. Run or exec into the container:
   ```bash
   docker run ... -e DISPLAY=... image_name
   # or, if the container is already running:
   docker exec -it <container_id> bash
   ```
3. Launch AFNI inside the container:
   ```bash
   afni
   ```

### Windows

#### With MobaXterm

Download [MobaXterm](https://mobaxterm.mobatek.net/) and [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/), then set up MobaXterm following this [guide](https://www.rootisgod.com/2021/Running-Linux-Desktop-Apps-From-a-Docker-Container-on-Windows-with-MobaXterm/).

#### With VcXsrv

Download [VcXsrv](https://sourceforge.net/projects/vcxsrv/files/latest/download) and [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/).

Open **XLaunch** and select the window type you want. **Disable access control** and **turn off native OpenGL**.

##### If you use WSL2

In Windows PowerShell, run `ipconfig` to find the IPv4 address of the WSL, then start the container with:

```bash
docker run --rm -it -e DISPLAY=IP_address:0.0 image_name:tag
```

You should now be able to open AFNI GUIs with `afni`.

##### If you use WSL1

*Not tested:*

```bash
docker run --rm -it -e DISPLAY=:0.0 image_name:tag
```


