#!/bin/bash
set -e

NODE_VERSION=$1
NODE_SHORT_VERSION="$(cut -d'.' -f1 <<<${NODE_VERSION})"

# Install node version
cd /opt
curl -O https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz
tar xvzf node-v${NODE_VERSION}-linux-x64.tar.gz
rm node-v${NODE_VERSION}-linux-x64.tar.gz
ln -s /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node${NODE_SHORT_VERSION}

# Set as default node version
ln -fs /opt/node-v${NODE_VERSION}-linux-x64/bin/node /usr/local/bin/node
ln -fs /opt/node-v${NODE_VERSION}-linux-x64/bin/npm /usr/local/bin/npm

# Update npm to version 4
/opt/node-v${NODE_VERSION}-linux-x64/bin/npm install -g npm@4