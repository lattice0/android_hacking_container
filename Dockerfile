
FROM ubuntu:focal

# non root user (https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user)
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME

RUN sudo apt-get update && \
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git-core gnupg flex bison build-essential \
        zip curl wget zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
        lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev \
        libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig libncurses5 rsync \
        nano libssl-dev bc python2 cpio device-tree-compiler openjdk-8-jdk libc6-dev \
        python-is-python3 abootimg brotli usbutils python3-setuptools libarchive-tools \
        qemu-kvm ninja-build python3-pip ccache language-pack-ru dos2unix unzip ed autoconf && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH="${PATH}:/opt/platform_tools/platform-tools/"
# Some precompiled tools like adb
RUN sudo mkdir -p /opt/platform_tools && \
    TEMPD=$(mktemp -d) && \
    wget -O $TEMPD/platform_tools.zip https://dl.google.com/android/repository/platform-tools-latest-linux.zip -q --show-progress --progress=bar:force 2>&1 && \
    cd $TEMPD && unzip platform_tools.zip && rm platform_tools.zip && \
    sudo cp -r $TEMPD/* /opt/platform_tools

ENV PATH="/opt/repo/bin:${PATH}" 
# Repo, for cloning AOSP
RUN set -x && sudo mkdir -p /opt/repo/bin && \
    TEMPD=$(mktemp -d) && \
    wget -O $TEMPD/repo https://storage.googleapis.com/git-repo-downloads/repo && \
    sudo cp -r $TEMPD/repo /opt/repo/bin/repo && \
    sudo chmod a+rx /opt/repo/bin/repo

# Helper for extracing some .dat files
ENV PATH="${PATH}:/opt/sdat2img/sdat2img"
RUN COMMIT=b432c988a412c06ff24d196132e354712fc18929 && \
    sudo mkdir /opt/sdat2img && \
    TEMPD=$(mktemp -d) && \
    cd $TEMPD && git clone https://github.com/xpirt/sdat2img && \
    cd sdat2img && git checkout $COMMIT && \
    sudo cp -r $TEMPD/sdat2img /opt/sdat2img

# .img unpack/repack tool for Android
RUN COMMIT=d4a2677828fe9b60117af8996dcf1dea85d6b431 && \
    sudo mkdir -p /opt/mkbootimg && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && git clone https://github.com/osm0sis/mkbootimg && \ 
    cd mkbootimg && git checkout $COMMIT && \
    make && sudo make install && \
    sudo cp -r $TEMPD/mkbootimg /opt/mkbootimg

# Official .img unpack/repack tool for Android
ENV PATH="${PATH}:/opt/google_mkbootimg/mkbootimg"
RUN ANDROID_BRANCH=android-11.0.0_r48 && \
    COMMIT=3e4ce8371dc459d9ef6911714386399e867202af && \
    sudo mkdir -p /opt/google_mkbootimg && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && \
    git clone https://android.googlesource.com/platform/system/tools/mkbootimg -b $ANDROID_BRANCH && \ 
    cd mkbootimg && git checkout $COMMIT && \
    sudo cp -r $TEMPD/mkbootimg /opt/google_mkbootimg

# Official misc prebuilts
ENV PATH="${PATH}:/opt/google_misc/misc"
RUN ANDROID_BRANCH=android-11.0.0_r48 && \
    COMMIT=9ae268fc4354288daed74956df3a1dba1548abbd && \
    sudo mkdir -p /opt/google_misc && \
    TEMPD=$(mktemp -d) && \   
    cd $TEMPD && git clone https://android.googlesource.com/platform/prebuilts/misc -b $ANDROID_BRANCH && \ 
    cd misc && git checkout $COMMIT && \
    sudo cp -r $TEMPD/misc /opt/google_misc

WORKDIR /tmp

RUN cd /tmp && git clone https://github.com/ReFirmLabs/binwalk && \
    cd binwalk && sudo python3 setup.py install

RUN sudo apt-get update && sudo apt-get install -y python3-dev && \
    git clone https://github.com/theopolis/uefi-firmware-parser && \
    cd uefi-firmware-parser && sudo python3 setup.py install

RUN cd /tmp && git clone https://github.com/PabloCastellano/extract-dtb && \
    cd extract-dtb && sudo python3 setup.py install

RUN sudo mkdir /opt/entrypoint && \ 
    TEMPD=$(mktemp -d) && \   
    echo "#!/bin/sh\n\
source /home/project/source_me.sh\n\
exec \"\$@\"" > $TEMPD/entrypoint.sh && \
    sudo cp $TEMPD/entrypoint.sh /opt/entrypoint

RUN cat /opt/entrypoint/entrypoint.sh 

RUN git config --global color.ui true

RUN sudo usermod -aG plugdev dev

WORKDIR /home/dev/project
