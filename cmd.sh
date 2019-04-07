#!/bin/bash
set -e

if [ "$RUNTIME" == "python" ] || [ "$RUNTIME" == "python2" ] || [ "$RUNTIME" == "python2.7" ]; then
    su $DEFAULT_USER -c "pip install --requirement requirements.txt --upgrade --target ."
elif [ "$RUNTIME" == "python3" ] || [ "$RUNTIME" == "python3.6" ] || [ "$RUNTIME" == "python3.7" ]; then
    su $DEFAULT_USER -c "pip3 install --requirement requirements.txt --upgrade --target ."
else
    su $DEFAULT_USER -c "npm install --production"
fi
