set -xe
rm -rf a
mkdir a
cd a
repo init -u https://android.googlesource.com/platform/manifest -b android-11.0.0_r48
repo sync -c -j8
