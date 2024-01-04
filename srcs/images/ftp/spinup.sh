#!/bin/bash


### spinup script for ftp

set -e

if [ ! -z "$FTP_USER" ]; then
    if [ -z "$FTP_PASSWORD" ]; then
        echo "ERROR: FTP_PASSWORD not set" >&2
        exit 1
    fi
    (useradd --home-dir $FTP_HOME $FTP_USER --shell /bin/bash && echo "user created") || true
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    echo "USER password set"
fi

exec $@