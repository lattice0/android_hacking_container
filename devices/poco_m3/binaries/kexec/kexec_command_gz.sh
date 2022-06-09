set -xe; ./kexec -l ./Image.gz --initrd=./boot.img-ramdisk --reuse-cmdline
