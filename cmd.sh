#!/bin/bash
set -e

if [ "$RUNTIME" == "python" ] || [ "$RUNTIME" == "python2" ]; then
    su $DEFAULT_USER -c "pip install --requirement requirements.txt --upgrade --target ."
elif [ "$RUNTIME" == "python3" ]; then
    su $DEFAULT_USER -c "pip3 install --requirement requirements.txt --upgrade --target ."
else
    su $DEFAULT_USER -c "npm install --production"
fi
