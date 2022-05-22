# Android Hacking Container 

Project that facilitates hacking android phones, compiling and flashing kernels, etc, on a docker container.

# Using it

Just clone and do `./build.sh` and `./run.sh`, run `source source_me.sh` (I'm trying to get rid of this part), then you should get a container with everything setted up for building/hacking/flashing the kernel/ROM. Look at `devices/poco_m3` for an example. Anyways, just set `DEVICE=your_device` (change by your phone name) and it should run the commands on the directory `devices/$DEVICE`, where it will find the scripts for cloning aos, kernel and the ROM. The `source_me.sh` file defines functions that calls these scripts and more, you can call these functions by their name from terminal to do stuff like cloning the kernel, building the kernel, unpacking boot.img from the ROM, repacking it, flashing the boot, etc.

## Example

Inside the container:

```bash
DEVICE=poco_m3
# Show all commands:
h
# Downloads/Installs toolchain for device
dt
# Downloads the kernel
kd
# Builds the kernel
kb
# Downloads the ROM:
rd
# Extracts the ROM:
re
# Extracts the boot.img from inside the ROM
be
# Repacks the boot.img with the newest compiled kernel
br
# Reboots into fastboot mode using adb (phone must be on, connected and you should have accepted adb connection from this container)
f
# Fastboot Flashes boot.img to the boot partition on the Android device
ffb
# Fastboot Boot boot.img, but some phones don´t support this option (Poco M3 does not)
#fbb
# Reboots the phone using fastboot so it boots with the new kernel (must be in fastboot mode)
r
# If the kernel goes wrong and you return to fastboot mode, then you can do re to Rom Extract again and thus overwriting everything you changed
re
# Then do ffb to reflash the original unmodified boot.img from the unzipped ROM
ffb
```

# Devcontainer

If you open this project on VSCode, it should build the container and mount itself inside of it and everything should work, but I'm not sure if USB is going to work on macOS and Windows, so I advise using this on a Linux host, so you can use `adb` and `fastboot` inside the container (they are available). So, running everything on a Linux host will give you a plug and play Android hacking environment. Anyways, open this on VSCode, but do `source source_me.sh` when you enter it, I'm working on a way for it to be not needed.
