#!/usr/bin/env bash
#script based on https://github.com/daboynb/magisk_for_linux
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -ex
cd $SCRIPT_DIR/Magisk/pc_magisk
ls
/bin/bash ./boot_patch.sh $1
rm -rf $2/devices/$3/rom/r/magisk/
mkdir -p $2/devices/$3/rom/r/magisk/
cp new-boot.img $2/devices/$3/rom/r/magisk/boot.img