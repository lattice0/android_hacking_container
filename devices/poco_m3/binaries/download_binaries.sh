set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
(cd ${SCRIPT_DIR}/kexec && ./download.sh)
(cd ${SCRIPT_DIR}/strace && ./download.sh)
(cd ${SCRIPT_DIR}/nano && ./download.sh)
(cd ${SCRIPT_DIR}/texterm && ./download.sh)
