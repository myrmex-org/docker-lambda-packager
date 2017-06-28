#!/bin/bash
set -e

su $DEFAULT_USER -c "npm install --production"
