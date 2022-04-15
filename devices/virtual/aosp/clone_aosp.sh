set -xe
rm -rf a
mkdir a
cd a
repo init -u https://android.googlesource.com/platform/manifest -b android-12.0.0_r29
repo sync -c -j8
