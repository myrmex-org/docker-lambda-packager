#!/bin/bash
set -e

# Copy everything to prepare installation
rsync -av --progress . /workspace/install $RSYNC_OPTIONS
cd /workspace/install
npm install

zip -r /workspace/package/package.zip ./*
