#https://android.googlesource.com/platform/external/qemu/+/refs/heads/emu-master-dev/android/docs/LINUX-DEV.md
set -xe
rm -rf e
mkdir e
cd e
repo init -u https://android.googlesource.com/platform/manifest -b emu-master-dev
repo sync -c -j8
