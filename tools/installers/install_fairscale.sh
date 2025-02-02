#!/usr/bin/env bash

set -euo pipefail

if [ $# != 0 ]; then
    echo "Usage: $0"
    exit 1;
fi

torch_version=$(python3 -c "import torch; print(torch.__version__)")
python_36_plus=$(python3 <<EOF
from distutils.version import LooseVersion as V
import sys

if V(sys.version) >= V("3.6"):
    print("true")
else:
    print("false")
EOF
)

pt_plus(){
    python3 <<EOF
import sys
from distutils.version import LooseVersion as L
if L('$torch_version') >= L('$1'):
    print("true")
else:
    print("false")
EOF
}

echo "[INFO] torch_version=${torch_version}"


if ! "${python_36_plus}"; then
    echo "[ERROR] python<3.6 is not supported"
    exit 1
else

    if $(pt_plus 1.6.0); then
        pip install fairscale
    else
        echo "[WARNING] fairscale requires pytorch>=1.6.0"
    fi

fi


# Check the pytorch version is not changed from the original version
current_torch_version="$(python3 -c 'import torch; print(torch.__version__)')"
if [ ${torch_version} != "${current_torch_version}" ]; then
    echo "[ERROR] The torch version has been changed. Please report to espnet administrators"
    exit 1
fi
