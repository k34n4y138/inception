#!/bin/bash

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

MARIA_ROOT_PASSWORD=`cat /run/secrets/mariadb_root_password`

alias server="mysql -u root -p$MARIA_ROOT_PASSWORD -h $WORDPRESS_DB_HOST"

# check that all required variables are set
if [ -z "$MARIA_ROOT_PASSWORD" ] && [ -z "$WORDPRESS_DB_NAME" ] && [ -z "$WORDPRESS_DB_USER" ] && [ -z "$WORDPRESS_DB_PASSWORD" ] && [ -z "$WORDPRESS_DB_HOST" ]; then
    server -e "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';" ||  fatal "Failed to create database user"
    server -e "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;" || fatal "Failed to create database"
    server -e "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';" || fatal "Failed to grant privileges to database user"
    server -e "FLUSH PRIVILEGES;" || fatal "Failed to flush privileges
else
    fatal "MISSING ENVIRONMENT VARIABLES"
fi
