#!/bin/bash

COPY_DIR="/tmp/integrity_check/$(date +%Y-%m-%d)"
ARCH_FILE="/root/susp_files-$(date +%Y-%m-%d).tgz"

# we need debsums
dpkg -l | grep debsums >/dev/null || apt-get install -y debsums

# backup tampered files
TAMPERED_FILES=$(debsums -ca)
mkdir -p $COPY_DIR
cp --parents $TAMPERED_FILES $COPY_DIR/
tar -czf $ARCH_FILE $COPY_DIR && rm -rf $COPY_DIR

# reinstall or not
if [ -n "$FORCE_REINSTALL" ]
then
    apt-get install -y --reinstall $(dpkg-query -S $(echo $TAMPERED_FILES | sed -e "s/.*file \(.*\) (.*/\1/g") | cut -d: -f1 | sort -u)
else
    echo proponuje wykonac reinstalacje:
    echo apt-get install -y --reinstall $(dpkg-query -S $(echo $TAMPERED_FILES | sed -e "s/.*file \(.*\) (.*/\1/g") | cut -d: -f1 | sort -u)
fi


