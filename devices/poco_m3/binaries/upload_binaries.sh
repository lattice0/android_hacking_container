set -ex
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
(cd ${SCRIPT_DIR}/kexec && /bin/bash ./upload.sh)
(cd ${SCRIPT_DIR}/strace && /bin/bash ./upload.sh)
#(cd ${SCRIPT_DIR}/nano && /bin/bash ./upload.sh)
(cd ${SCRIPT_DIR}/texterm && /bin/bash ./upload.sh)