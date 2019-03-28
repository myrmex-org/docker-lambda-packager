#!/bin/bash
set -e

if [ `whoami` == "root" ]; then

    if [ "$RUNTIME" == "" ]; then
        echo "Using default runtime node v8"
    fi

    if [ "$RUNTIME" == "node" ]; then
        echo "Using default node v8 runtime"
    fi
    
    if [ "$RUNTIME" == "node6" ]; then
        echo "Setting node runtime to v6"
        rm /usr/local/bin/node /usr/local/bin/npm
        ln -sf /opt/node-v${NODE_VERSION_6}-linux-x64/bin/node /usr/local/bin/node
        ln -sf /opt/node-v${NODE_VERSION_6}-linux-x64/bin/npm /usr/local/bin/npm
    fi

    if [ "$RUNTIME" == "node8" ]; then
        echo "Setting node runtime to v8"
        rm /usr/local/bin/node /usr/local/bin/npm
        ln -sf /opt/node-v${NODE_VERSION_8}-linux-x64/bin/node /usr/local/bin/node
        ln -sf /opt/node-v${NODE_VERSION_8}-linux-x64/bin/npm /usr/local/bin/npm
    fi

    if [ "$RUNTIME" == "python" ]; then
        echo "Using default python v2 runtime"
        ln -sf /usr/bin/python2.7 /usr/bin/python2
    fi

    if [ "$RUNTIME" == "python2" ]; then
        echo "Setting python runtime to 2"
        ln -sf /usr/bin/python2.7 /usr/bin/python2
    fi

    if [ "$RUNTIME" == "python3.6" ]; then
        echo "Setting python runtime to 3.6"
        ln -sf /opt/python-${PYTHON_VERSION_3_6}/bin/python3 /usr/bin/python3
        ln -sf f/opt/python-${PYTHON_VERSION_3_6}/bin/pip3 /usr/bin/pip3
    fi

    if [ "$RUNTIME" == "python3.7" ]; then
        echo "Setting python runtime to 3.7"
        ln -sf /opt/python-${PYTHON_VERSION_3_7}/bin/python3 /usr/bin/python3
        ln -sf /opt/python-${PYTHON_VERSION_3_7}/bin/pip3 /usr/bin/pip3
    fi

    if [ "$HOST_UID" != "" ]; then
        # If the user is root and a HOST_UID environment variable exists,
        # we change the myrmex user UID and execute the command as the myrmex user
        if [ "$HOST_UID" != `id -u $DEFAULT_USER` ]; then
            echo "Changing $DEFAULT_USER UID to $HOST_UID"
            change-uid $HOST_UID $HOST_GID >/dev/null
        fi
    fi

fi

exec $@
