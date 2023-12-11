#!/bin/bash

set -e

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

if [ ! -f /run/secrets/mariadb_secrets ]; then
    echo "ERROR: mariadb rootpassword file not found";
    exit 1;
fi

export $(cat /run/secrets/mariadb_secrets | sed 's/#.*//g' | xargs)

mysqsrvr="mysql -u root -p$MARIADB_ROOT_PASSWORD -h $WORDPRESS_DB_HOST"

# check that all required variables are set
$mysqsrvr -e "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';" ||  fatal "Failed to create database user"
$mysqsrvr -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;" || fatal "Failed to create database"
$mysqsrvr -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';" || fatal "Failed to grant privileges to database user"
$mysqsrvr -e "FLUSH PRIVILEGES;" || fatal "Failed to flush privileges"