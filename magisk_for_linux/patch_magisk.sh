#!/usr/bin/env bash
#script from https://github.com/daboynb/magisk_for_linux
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -ex
echo "patching with magisk for file $1"
echo "Waiting for adb conenction"
while true; do adb get-state && sleep 1 && break; done
#read -e -p "Enter filename : " file
#eval xyz=${abc[i]}
#eval file=$file
#echo "$file" | tr -d ''
cd $SCRIPT_DIR/Magisk/pc_magisk
ls
/bin/bash ./boot_patch.sh $1
cp new-boot.img $1