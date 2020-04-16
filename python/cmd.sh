#!/bin/bash
set -e

# Copy everything to prepare installation
rsync -av --progress . /workspace/install $RSYNC_OPTIONS
cd /workspace/install
pip3.8 install --requirement requirements.txt --upgrade --target .

zip -r /workspace/package/package.zip ./*
