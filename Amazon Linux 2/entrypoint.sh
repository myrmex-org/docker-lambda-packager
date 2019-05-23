#!/bin/bash
set -e

if [ `whoami` == "root" ]; then
  echo "Using node v10 runtime"

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
