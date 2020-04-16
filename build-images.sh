#!/bin/bash
docker build --build-arg PYTHON_VERSION=3.8.2 -t myrmex/lambda-packager:python-3.8 python
docker build --build-arg NODE_VERSION=12.16.2 -t myrmex/lambda-packager:nodejs-12 node