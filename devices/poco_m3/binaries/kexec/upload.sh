set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEVICE_DIR=${SCRIPT_DIR}/../../
adb push ${DEVICE_DIR}/kernel/k/out/arch/arm64/boot/Image /data/local/tmp/
adb push ${DEVICE_DIR}/kernel/k/out/arch/arm64/boot/Image.gz /data/local/tmp/
#adb push ${SCRIPT_DIR}/devices/${DEVICE}/rom/r/initrd /data/local/kexec
rm -rf command_line.txt || true
echo `adb shell su -c "cat /proc/cmdline"` > command_line.txt
adb push command_line.txt /data/local/tmp
adb push ${DEVICE_DIR}/rom/r/boot_img_unpacked/boot.img-ramdisk /data/local/tmp
#--append=\"`cat ./command_line.txt`\"
echo "set -xe; ./kexec -l ./Image --initrd=./boot.img-ramdisk --reuse-cmdline" > kexec_command.sh
adb push kexec_command.sh /data/local/tmp
echo "set -xe; ./kexec -l ./Image.gz --initrd=./boot.img-ramdisk --reuse-cmdline" > kexec_command_gz.sh
adb push kexec_command_gz.sh /data/local/tmp
adb shell su -c "chmod +x /data/local/tmp/kexec_command.sh"
adb shell su -c "chmod +x /data/local/tmp/kexec_command_gz.sh"
rm command_line.txt