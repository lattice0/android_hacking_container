#!/usr/bin/env bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd $SCRIPT_DIR/k
#patch -p1 < ../patches/genheaders.patch
#patch -p1 < ../patches/security_five.patch