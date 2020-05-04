#!/bin/bash
set -e

SOURCE=`readlink -f ${1:-/workspace/sources}`
DESTINATION=`readlink -f ${2:-/workspace/package/package.zip}`
INSTALLATION=$(mktemp -d -t package-XXXXXXXXXX)

echo "Copy sources from $SOURCE to $INSTALLATION"
(cd $SOURCE && rsync -av --progress . $INSTALLATION $RSYNC_OPTIONS)

echo "Install dependencies in $INSTALLATION"
(cd $INSTALLATION && pip3.8 install --requirement requirements.txt --upgrade --target .)

echo "Zip the content of $INSTALLATION in $DESTINATION"
(cd $INSTALLATION && zip -r $DESTINATION ./*)
