#!/usr/bin/env bash
#script from https://github.com/daboynb/magisk_for_linux
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -ex
MAGISK_INSTALL_DIR=$SCRIPT_DIR
#Dependencies
rm -rf $MAGISK_INSTALL_DIR/Magisk
mkdir $MAGISK_INSTALL_DIR/Magisk
cd $MAGISK_INSTALL_DIR/Magisk
echo "Downloading lastest magisk..."
wget $(curl -s https://api.github.com/repos/topjohnwu/Magisk/releases/latest | grep 'browser_download_url' | cut -d\" -f4)
ls
#Remove no needed apk
rm $MAGISK_INSTALL_DIR/Magisk/stub-release.apk
#Unzip the apk on his directory
echo "Unzipping..."
mkdir $MAGISK_INSTALL_DIR/Magisk/wokdir
unzip $MAGISK_INSTALL_DIR/Magisk/Magisk* -d $MAGISK_INSTALL_DIR/Magisk/wokdir
#Create direcorty where file will be copied
mkdir $MAGISK_INSTALL_DIR/Magisk/pc_magisk
#Copy all files needed
echo "Copying files..."
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/assets/boot_patch.sh $MAGISK_INSTALL_DIR/Magisk/pc_magisk/boot_patch.sh
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/assets/util_functions.sh $MAGISK_INSTALL_DIR/Magisk/pc_magisk/util_functions.sh
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/lib/x86_64/libmagiskboot.so $MAGISK_INSTALL_DIR/Magisk/pc_magisk/magiskboot
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/lib/armeabi-v7a/libmagisk32.so $MAGISK_INSTALL_DIR/Magisk/pc_magisk/magisk32
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/lib/arm64-v8a/libmagisk64.so $MAGISK_INSTALL_DIR/Magisk/pc_magisk/magisk64
cp $MAGISK_INSTALL_DIR/Magisk/wokdir/lib/arm64-v8a/libmagiskinit.so $MAGISK_INSTALL_DIR/Magisk/pc_magisk/magiskinit
#Remove old dir
rm -rf $MAGISK_INSTALL_DIR/Magisk/wokdir
#Enter into folder 
cd $MAGISK_INSTALL_DIR/Magisk/pc_magisk
#Get line
echo "Adapting script for pc"
line=$(grep -n '/proc/self/fd/$OUTFD' util_functions.sh | awk '{print $1}' | sed 's/.$//')
#Edit the scripts
KEYWORD="/proc/self/fd/$OUTFD";
ESCAPED_KEYWORD=$(printf '%s\n' "$KEYWORD" | sed -e 's/[]\/$*.^[]/\\&/g');
sed -i "/$ESCAPED_KEYWORD/d" util_functions.sh
#Add echo "$1"
(echo "$line-1"; echo a; echo 'echo "$1"'; echo .; echo wq) | ed util_functions.sh 
#Replace getprop
sed -i 's/getprop/adb shell getprop/g' util_functions.sh 
#Adb
#echo "Waiting for adb conenction"
#while true; do adb get-state > /dev/null 2>&1 && break; done
#Patch
#echo "Be sure adb is running and you have allowed on your phone"
#echo "Now if the adb is working we can patch the image"
#echo ""
#read -e -p "Enter filename : " file
#eval xyz=${abc[i]}
#eval file=$file
#echo "$file" | tr -d ''
#sh boot_patch.sh $file
