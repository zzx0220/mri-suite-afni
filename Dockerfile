FROM ubuntu:24.04

LABEL org.opencontainers.image.authors="zzx"
SHELL ["/bin/bash", "-c"]

RUN apt update
RUN apt-get install -y software-properties-common
RUN apt update
RUN add-apt-repository universe
RUN apt-get update

# SETUP THE AFNI
# install prerequisite packages
RUN apt-get install -y tcsh xfonts-base libssl-dev       \
python-is-python3                 \
python3-matplotlib python3-numpy  \
python3-flask python3-flask-cors  \
python3-pil                       \
gsl-bin netpbm gnome-tweaks       \
libjpeg62 xvfb xterm vim curl     \
gedit evince eog                  \
libglu1-mesa-dev libglw1-mesa-dev \
libxm4 build-essential            \
libcurl4-openssl-dev libxml2-dev  \
libgfortran-14-dev libgomp1       \
gnome-terminal nautilus           \
firefox xfonts-100dpi             \
r-base-dev cmake bc               \
libgdal-dev libopenblas-dev       \
libnode-dev libudunits2-dev

# Install AFNI binaries
RUN cd
RUN curl -O https://afni.nimh.nih.gov/pub/dist/bin/misc/@update.afni.binaries
RUN tcsh @update.afni.binaries -package linux_ubuntu_24_64 -do_extras
RUN echo  'export PATH=$HOME/abin/:$PATH' >> ~/.bashrc

# Install R
RUN export R_LIBS=$HOME/R && mkdir $R_LIBS
RUN echo  'export R_LIBS=$HOME/R' >> ~/.bashrc
RUN echo  'setenv R_LIBS ~/R'     >> ~/.cshrc

ENV PATH="/root/abin/:$PATH"
ENV R_LIBS="/root/R"
RUN rPkgsInstall -pkgs ALL

# nicefy terminal
RUN echo 'set filec'    >> ~/.cshrc
RUN echo 'set autolist' >> ~/.cshrc
RUN echo 'set nobeep'   >> ~/.cshrc

RUN echo 'alias ls ls --color=auto' >> ~/.cshrc
RUN echo 'alias ll ls --color -l'   >> ~/.cshrc
RUN echo 'alias ltr ls --color -ltr'   >> ~/.cshrc
RUN echo 'alias ls="ls --color"'    >> ~/.bashrc
RUN echo 'alias ll="ls --color -l"' >> ~/.bashrc
RUN echo 'alias ltr="ls --color -ltr"' >> ~/.bashrc

# install extras
#RUN @afni_R_package_install -shiny -circos

# Check the AFNI
COPY extra_suites_for_afni/check_afni.sh /root/abin/
COPY extra_suites_for_afni/add_extra_pkgs.sh /root/abin/

# Extra fix
RUN cp /root/abin//AFNI.afnirc ~/.afnirc
RUN suma -update_env
RUN apsearch -update_all_afni_help

