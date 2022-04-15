#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -xe
cd k
PATH="${PATH}:$SCRIPT_DIR/../tools/clang/bin:$SCRIPT_DIR/../tools/gcc/toolchain/bin"
export ARCH=arm64 && export SUBARCH=arm64
#export CROSS_COMPILE=/opt/aosp_prebuilts/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CROSS_COMPILE=aarch64-linux-android-
#TODO: why this?
export DTC_EXT="/opt/google_misc/misc/linux-x86/dtc/dtc"
clang -v
make ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- vendor/citrus-perf_defconfig
make ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- EXTRA_CFLAGS="-I $PWD/techpack/display/pll/ -I $PWD/techpack/camera/drivers/cam_sensor_module/cam_cci/  -I $PWD/techpack/camera/drivers/cam_req_mgr -DSDCARDFS_VERSION= -I $PWD/"  -j$(nproc --all) 2>&1 | tee kernel.log
