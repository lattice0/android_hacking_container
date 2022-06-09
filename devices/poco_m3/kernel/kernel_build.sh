#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -xeo pipefail
cd k
PATH="${PATH}:$SCRIPT_DIR/../tools/clang/bin:$SCRIPT_DIR/../tools/gcc/toolchain/bin"
export ARCH=arm64 && export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-android-
#TODO: why this?
export DTC_EXT="/opt/google_misc/misc/linux-x86/dtc/dtc"
clang -v
rm -rf out
mkdir -p out
rm -rf out_modules
mkdir -p out_modules
#TODO: remove old boot.img?
EXTRA_CONFIGS=""
EXTRA_KVM_FLAGS=""
# For extra logging:
#make SHELL='sh -x' ..
make O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- vendor/citrus-perf_defconfig
make O=out ARCH=arm64 CC=clang CLANG_TRIPLE=aarch64-linux-gnu- -j$(nproc --all) 2>&1 | tee kernel.log