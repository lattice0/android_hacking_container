# Clang, the compiler
(ANDROID_BRANCH=android-11.0.0_r48 && \
CLANG_VERSION=clang-r383902b.tar.gz && \
echo "downloading clang for branch $ANDROID_BRANCH and version $CLANG_VERSION..." && \
rm -rf tools/clang && mkdir -p tools/clang && cd tools/clang && \
wget -O clang.tar.gz https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/$ANDROID_BRANCH/$CLANG_VERSION -q --show-progress --progress=bar:force 2>&1 && \
echo "extracting clang.tar.gz..." && \
tar xzf clang.tar.gz)

# GCC toolchain
(ANDROID_BRANCH=android-11.0.0_r48 && \
echo "downloading gcc for branch $ANDROID_BRANCH..." && \
rm -rf tools/gcc && mkdir -p tools/gcc && cd tools/gcc && \
git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 toolchain && \
cd toolchain && git checkout $ANDROID_BRANCH )
