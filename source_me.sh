#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function fail_if_no_device() {
    (cd $SCRIPT_DIR
    if [[ -z "$DEVICE" ]]; then
        echo "Must provide DEVICE variable in environment"
        #exit 1
    fi)
}

# Kernel Clone
function dt() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE && ./download_tools.sh)
}

# Kernel Download
function kd() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/kernel; ./kernel_download.sh)
}

# Kernel Clone
function ke() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/kernel; ./kernel_extract.sh)
}

# Kernel Build
function kb() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/kernel; ./kernel_build.sh)
}

# ROM Download
function rd() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/rom; ./rom_download.sh)
}

# Rom Extract
function re() {
    fail_if_no_device
    echo "unzipping ROM at $DEVICE"
    if [ ! -f $SCRIPT_DIR/devices/$DEVICE/rom/rom.zip ]; then
        echo "you must download the ROM first with the rd command"
    fi
    (cd $SCRIPT_DIR/devices/$DEVICE/rom; rm -rf r && mkdir r && unzip *.zip -d r)
}

# Boot.img Extract
function be() {
    fail_if_no_device
    echo "extracting boot.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r && rm -rf boot_img_unpacked && 
    mkdir boot_img_unpacked && unpackbootimg -i boot.img -o boot_img_unpacked)
}

# Install Magisk
function im() {
    echo "downloading/installing magisk..."
    (cd $SCRIPT_DIR/magisk_for_linux/&& /bin/bash ./install_magisk.sh)
}

# Patch with Magisk
function pm() {
    echo "patching with magisk..."
    (cd $SCRIPT_DIR/magisk_for_linux/ && /bin/bash ./patch_magisk.sh $SCRIPT_DIR/devices/$DEVICE/rom/r/boot.img)
}

# Magisk boot.img extract, so we can repack with custom kernel + root
function mbe() {
    fail_if_no_device
    MAGISK_FILE=$SCRIPT_DIR/devices/$DEVICE/rom/magisk/boot.img
    echo "extracting magisk_boot.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r && rm -rf boot_img_unpacked && 
    mkdir boot_img_unpacked && unpackbootimg -i $MAGISK_FILE -o boot_img_unpacked)
}

function edt() {
    fail_if_no_device
    extract-dtb $SCRIPT_DIR/devices/$DEVICE/rom/r/boot.img -o $SCRIPT_DIR/devices/$DEVICE/rom/device_tree
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/device_tree &&
    rm -rf decompiled_device_tree
    mkdir -p decompiled_device_tree
    for file in *;
        do
            #echo "doing for file $file"
            dtc -q -I dtb -O dts -o decompiled_device_tree/$file.dts "$file";
        done
    )
}

# Boot.img Repack "$(< FILE)"
function br() {
    fail_if_no_device
    echo "repacking boot.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r/boot_img_unpacked && \
    mkbootimg --kernel "$SCRIPT_DIR/devices/$DEVICE/kernel/k/out/arch/arm64/boot/Image.gz" \
    --ramdisk boot.img-ramdisk \
    --dtb boot.img-dtb \
    --cmdline "$(< boot.img-cmdline) androidboot.init_fatal_reboot_target=recovery" \
    --base "$(< boot.img-base)" \
    --kernel_offset "$(< boot.img-kernel_offset)" \
    --ramdisk_offset "$(< boot.img-ramdisk_offset)" \
    --tags_offset "$(< boot.img-tags_offset)" \
    --dtb_offset "$(< boot.img-dtb_offset)" \
    --os_version "$(< boot.img-os_version)" \
    --os_patch_level "$(< boot.img-os_patch_level)" \
    --pagesize "$(< boot.img-pagesize)" \
    --header_version "$(< boot.img-header_version)" \
    --hashtype "$(< boot.img-hashtype)" \
    --board "$(< boot.img-board)" \
    -o ../boot.img)
    #TODO:
    #    --second `cat boot.img-second_offset` \
    #    --second_offset `cat boot.img-second_offset` \
}

# Boot.img Repack With Original Kernel
function brwok() {
    fail_if_no_device
    echo "repacking boot.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r/boot_img_unpacked && \
    mkbootimg --kernel boot.img-kernel \
    --ramdisk boot.img-ramdisk \
    --dtb boot.img-dtb \
    --cmdline "$(< boot.img-cmdline)" \
    --base "$(< boot.img-base)" \
    --kernel_offset "$(< boot.img-kernel_offset)" \
    --ramdisk_offset "$(< boot.img-ramdisk_offset)" \
    --tags_offset "$(< boot.img-tags_offset)" \
    --dtb_offset "$(< boot.img-dtb_offset)" \
    --os_version "$(< boot.img-os_version)" \
    --os_patch_level "$(< boot.img-os_patch_level)" \
    --pagesize "$(< boot.img-pagesize)" \
    --header_version "$(< boot.img-header_version)" \
    --hashtype "$(< boot.img-hashtype)" \
    --board "$(< boot.img-board)" \
    -o ../boot.img)
}


# Ramdisk Unpack
function rau() {
    fail_if_no_device
    echo "unpacking ramdisk.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r && mkdir initrd && cd initrd && \
        cat ../initrd.img | gunzip | cpio -vid)
}

# Ramdisk Repack
function rar() {
    fail_if_no_device
    echo "repacking ramdisk.img at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r/initrd && find . | cpio --create --format='newc' | gzip > initrd.img)
}

# Fastboot flash boot.img
function ffb() {
    echo "flashing boot.img at $DEVICE"
    fastboot flash boot $SCRIPT_DIR/devices/$DEVICE/rom/r/boot.img
}

# Fastboot boot boot.img
function fbb() {
    echo "flashing boot.img at $DEVICE"
    fastboot boot $SCRIPT_DIR/devices/$DEVICE/rom/r/boot.img
}

# Fastboot boot magisk_boot.img (flashes the working boot.img with root)
function ffmb() {
    echo "flashing boot.img at $DEVICE"
    MAGISK_FILE=$SCRIPT_DIR/devices/$DEVICE/rom/magisk/boot.img
    if [ ! -f $MAGISK_FILE ]; then
        echo "you must put your magisk patched boot.img at $MAGISK_FILE"
    fi
    fastboot flash boot $MAGISK_FILE
}

# System.img extract mount
function se() {
    fail_if_no_device
    echo "unpacking system.new.dat at $DEVICE"
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r && rm -rf unpacked_system.new.dat && \
    brotli --decompress system.new.dat.br -o unpacked_system.new.dat && \
    sdat2img.py system.transfer.list unpacked_system.new.dat unpacked_system.img && \
    rm -rf system && mkdir system && mount -o ro unpacked_system.img system)
}

# Reboot into bootloader mode using adb
function f() {
    echo "rebooting into bootloader mode (fastboot)"
    adb reboot bootloader
}

# Reboot from fastboot to adb
function r() {
    echo "rebooting from fastboot"
    fastboot reboot
}

# Goes to the script directory (the root of the project)
function p() {
    cd $SCRIPT_DIR
}

# Goes to the root of the current $DEVICE
function d() {
    fail_if_no_device
    cd $SCRIPT_DIR/devices/$DEVICE
}

function h() {
    cat << EOF
Commands:
 DEVICE=my_device        sets the current device, which makes all commands work on devices/my_device
 dt			 downloads the toolchain for this device
 im                      install magisk
 pm                      patch boot.img with magisk
 kd                      downloads the kernel
 ke                      extracts the kernel
 kb                      builds the kernel
 rd                      rom download
 re                      rom extrack
 be                      boot.img (from ROM) extract 
 edt                     extract device tree from boot.img
 mbe                     magisk_boot.img extract, extracts magisk-patched boot img, for repacking with custon kernel and root
 br                      boot.img repacked with kernel built from kb
 brwok                   repacks boot.img but with original kernel, not built from kb
 rau                     ramdisk unpack
 rar                     ramdisk repack
 su                      unpacks system.new.dat.br into a system.img and mounts it in devices/\$DEVICE/rom/r/system_unpacked/system_mounted
 ffb                     runs fastboot flash boot.img
 ffmb                    runs fastboot flash magisk_boot.img (flashes the boot.img patched by magisk so you have root)
 fbb                     runs fastboot boot boot.img
 f                       reboot to fastboot mode (must be in adb mode)
 r                       reboot from fastboot to adb mode (must be in fastboot mode)
 p                       goes to the root of the project
 d                       goes to the root of the device (root_of_project/devices/$DEVICE)
 discover_clang_version  discovers the clang version used to build the kernel from the ROM
 aosp_clone              clones AOSP entirely (could take hours)
 emu_clone               clones android emulator source code
 emu_rebuild             rebuild emulator
 emu_build               build again only changes
 emu_launch_generic      launches emulator with generic AOSP image built with `m`
EOF
}

# Clones the Android Open Source Project
function aosp_clone() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/aosp; ./aosp_clone.sh)
}

# Clones the emulator source code
function emu_clone() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/emu; ./emu_clone.sh)
}

# Rebuilds the emulator
function emu_rebuild() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/emu; ./emu_rebuild.sh)
}

# Builds the emulator
function emu_build() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/emu; ./emu_build.sh)
}

# Builds the emulator
function emu_launch_generic() {
    fail_if_no_device
    (cd $SCRIPT_DIR/devices/$DEVICE/emu; ./emu_launch_generic.sh)
}

# Discovers clang version inside the kernel from the ROM
function discover_clang_version() {
    fail_if_no_device
    if [ ! -f $SCRIPT_DIR/devices/$DEVICE/rom/r/boot.img ]; then
        echo "you must extract the rom first with the bu command"
    fi
    if [ ! -f $SCRIPT_DIR/devices/$DEVICE/rom/r/boot_img_unpacked/boot.img-kernel ]; then
        echo "you must extract the boot.img first with the bu command"
    fi
    (cd $SCRIPT_DIR/devices/$DEVICE/rom/r/boot_img_unpacked && \
    rm -rf boot.img-kernel_extracted && cp boot.img-kernel boot.img-kernel_extracted.gz && \
    gunzip boot.img-kernel_extracted.gz && strings boot.img-kernel_extracted | grep -i clang && \
    rm boot.img-kernel_extracted)
}

if [[ -z "$DEVICE" ]]; then
    echo -e "Attention: set the variable DEVICE to work in. Example: DEVICE=poco_m3. Then you should have devices/poco_m3/{kernel,rom} with the kernel and ROM.\nDo cp -R devices/poco_m3 devices/YOUR_DEVICE and edit the .sh scripts according to your device"
fi

echo "Welcome to Android Hacking Container. Here are the most commonly used commands:"
h
exec "$@"
