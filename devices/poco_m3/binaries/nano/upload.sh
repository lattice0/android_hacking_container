set -ex 
adb push ./str/src/strace /data/local/tmp
adb shell "chmod +x /data/local/tmp/strace"