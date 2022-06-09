set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export TOOLCHAIN=${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=aarch64-linux-android
#minSdkVersion.
export API=28
export AR=$TOOLCHAIN/bin/llvm-ar
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export AS=$CC
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip
(cd nano && LDFLAGS=-static ./configure --disable-mpers --host $TARGET && make CFLAGS="-Wno-unused-function")
# needed because of https://github.com/termux/termux-packages/issues/8273
../align_fix.py ${SCRIPT_DIR}/str/src/strace
