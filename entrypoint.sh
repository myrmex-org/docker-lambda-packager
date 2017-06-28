#!/bin/bash
set -e

if [ `whoami` == "root" ]; then

    if [ "$RUNTIME" == "node4" ]; then
        echo "Setting node to v4"
        rm /usr/local/bin/node /usr/local/bin/npm
        ln -s /opt/node-v${NODE_VERSION_4}-linux-x64/bin/node /usr/local/bin/node
        ln -s /opt/node-v${NODE_VERSION_4}-linux-x64/bin/npm /usr/local/bin/npm
    fi

    if [ "$HOST_UID" != "" ]; then
        # If the user is root and a HOST_UID environment variable exists,
        # we changer the myrmex user UID and execute the command as the myrmex user
        if [ "$HOST_UID" != `id -u $DEFAULT_USER` ]; then
            echo "Changing $DEFAULT_USER UID to $HOST_UID"
            change-uid $HOST_UID $HOST_GID >/dev/null
        fi
    fi

fi

exec $@
