
ANDROID_PRODUCT_OUT=/home/project/devices/virtual/aosp/a/out/target/product/generic_x86_64 
AOSP_ROOT=/home/project/devices/virtual/aosp/a 
DIR_OUT=/home/project/devices/virtual/aosp/a/out/target/product/generic_x86_64  
/home/project/devices/virtual/emu/e/external/qemu/objs/emulator \
-sysdir $DIR_OUT/system \
-datadir $DIR_OUT/data \
-kernel $AOSP_ROOT/prebuilts/qemu-kernel/x86_64/5.4/kernel-qemu2 \
-ramdisk $DIR_OUT/ramdisk-qemu.img \
-system $DIR_OUT/system.img \
-data $DIR_OUT/userdata-qemu.img \
-cache $DIR_OUT/cache.img 
-vendor $DIR_OUT/vendor.img
