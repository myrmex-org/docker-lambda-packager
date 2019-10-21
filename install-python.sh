#!/bin/bash
set -e

PYTHON_VERSION=$1
PYTHON_MAJOR_VERSION="$(cut -d'.' -f1 <<<${PYTHON_VERSION})"
PYTHON_MINOR_VERSION="$(cut -d'.' -f1-2 <<<${PYTHON_VERSION})"

# Install python version
curl -O https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz
tar zxvf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --prefix=/opt/python-${PYTHON_VERSION}
make
make install
ln -s /opt/python-${PYTHON_VERSION}/bin/python${PYTHON_MAJOR_VERSION} /usr/bin/python${PYTHON_MINOR_VERSION}
ln -s /opt/python-${PYTHON_VERSION}/bin/pip${PYTHON_MAJOR_VERSION} /usr/bin/pip${PYTHON_MINOR_VERSION}

# Set as default python major version
ln -fs /opt/python-${PYTHON_VERSION}/bin/python${PYTHON_MAJOR_VERSION} /usr/bin/python${PYTHON_MAJOR_VERSION}
ln -fs /opt/python-${PYTHON_VERSION}/bin/pip${PYTHON_MAJOR_VERSION} /usr/bin/pip${PYTHON_MAJOR_VERSION}