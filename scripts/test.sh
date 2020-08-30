#!/usr/bin/env bash

set -ex

echo "***** Start: Testing Miniforge installer *****"

export CONDA_PATH="$HOME/miniforge"

CONSTRUCT_ROOT="${CONSTRUCT_ROOT:-/construct}"

cd ${CONSTRUCT_ROOT}

echo "***** Get the installer *****"
INSTALLER_PATH=$(find build/ -name "Miniforge*$ARCH.sh" | head -n 1)

echo "***** Run the installer *****"
chmod +x $INSTALLER_PATH
bash $INSTALLER_PATH -b -p $CONDA_PATH

echo "***** Setup conda *****"
source $CONDA_PATH/bin/activate

echo "***** Print conda info *****"
conda info
conda config --show

# pass through xargs because osx adds a ton of whitespace
# REPO_ANACONDA=`conda config --show default_channels | grep "repo.anaconda.com/pkgs/main" | wc -l | xargs`
REPO_ANACONDA=`conda config --show default_channels | grep "repo.anaconda.com/pkgs/main" | wc -l`

if [ "${REPO_ANACONDA}" -ne "0" ]; then
    echo Default Repository found in configuration
    conda config --show default_channels
    exit 1;
fi

# 2020/09/15: Running conda update switches from pypy to cpython. Not sure why
# echo "***** Run conda update *****"
# conda update --all -y

echo "***** Python path *****"
python -c "import sys; print(sys.executable)"
python -c "import sys; assert 'miniforge' in sys.executable"

echo "***** Print system informations from Python *****"
python -c "print('Hello Miniforge !')"
python -c "import platform; print(platform.architecture())"
python -c "import platform; print(platform.system())"
python -c "import platform; print(platform.machine())"
python -c "import platform; print(platform.release())"

echo "***** Done: Building Testing installer *****"
