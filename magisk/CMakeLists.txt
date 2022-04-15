cmake_minimum_required(VERSION 3.10)
project(magisk_tools VERSION 1.0.0)
set (CMAKE_CXX_STANDARD 20)
set(CMAKE_C_FLAGS " -Wall -Oz -fomit-frame-pointer -flto")
set(CMAKE_CXX_FLAGS "-Wno-error=permissive")
file(GLOB MINCRYPT_SRCS
  "Magisk/native/jni/external/mincrypt/*.c")

file(GLOB UTILS_SRCS
  "Magisk/native/jni/utils/*.cpp"
  "Magisk/native/jni/utils/*.hpp"
  "Magisk/native/jni/utils/include/*.hpp"
)
  
file(GLOB MAGISK_BOOT_SRCS
  "Magisk/native/jni/magiskboot/*.cpp"
  "Magisk/native/jni/magiskboot/*.hpp"
)

include_directories("Magisk/native/jni/external/mincrypt/include"
"Magisk/native/jni/utils/include")
add_library(utils ${UTILS_SRCS})
add_library(mincrypt ${MINCRYPT_SRCS})
add_executable(magisk_boot ${MAGISK_BOOT_SRCS})