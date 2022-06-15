# Android Hacking Container 

Project that facilitates hacking android phones, compiling and flashing kernels, etc, on a docker container/devcontainer.

Supports: kernel download/build, boot.img unpack from ROM + repack, kernel/boot.img boot/flash, magisk root on computer instead of android, system.img unpack, building binaries for android like kexec, and more!

You can however use this repo, but it's not recommended as you'll mess with the repo and won´t be able to make commits/PRs. Use the template, modify for your phone, enjoy the github workflows, etc.

# Using it

This repo is not meant to be used directly. It's supposed to be used as a submodule on another repo, where you'll also put files specific for your phone. For a template based on the Poco M3 phone, see here: https://github.com/lattice0/poco_m3_hacking and click "use this template".

## Example

Let's download the kernel, ROM, patch boot.img inside the ROM and flash to the phone. Inside the template, after sourcing the `source_me.sh`

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

# Combos

This repo allows you to use combos of commands to do things in series. Examples of combos:

```
f && kb && re && be && br && ffb && r # fastboot, kernel build, rom extract, boot.img extract, boot.img repack (w/ built kernel), fastboot flash boot.img, reboot

im && be && pm && ffb && r # install magisk, boot.img extract, patch (boot.img) with magisk, fastboot flash boot, reboot

f && kb && re && mbe && br && ffb && r # fastboot, kernel build, rom extract, boot.img extract, magisk boot.img repack (w/ built kernel), fastboot flash boot.img, reboot

```

# Devcontainer

You can open the template or even this repo on VSCode's devcontainer, where you'll be able to do all the commands. Edit the .devcontainer.json to set your phone.
