#!/bin/bash

set -e

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

if [ -z "$MARIADB_ROOT_PASSWORD" -o -z "$WORDPRESS_DB_HOST" -o -z "$WORDPRESS_DB_USER" -o -z "$WORDPRESS_DB_PASSWORD" -o -z "$WORDPRESS_DB_NAME" ]; then
    fatal "Missing required environment variables"
fi

mysqsrvr="mysql -u root -p$MARIADB_ROOT_PASSWORD -h $WORDPRESS_DB_HOST"

# check that all required variables are set
$mysqsrvr -e  "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'%'" ||  fatal "Failed to create database user"
$mysqsrvr -e  "ALTER USER '$WORDPRESS_DB_USER'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('$WORDPRESS_DB_PASSWORD');" || fatal "Failed to set database user password"
$mysqsrvr -e  "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME;" || fatal "Failed to create database"
$mysqsrvr -e  "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'%';" || fatal "Failed to grant privileges to database user"
$mysqsrvr -e  "FLUSH PRIVILEGES;" || fatal "Failed to flush privileges"
# check if database contains tables
if $mysqsrvr -e "USE $WORDPRESS_DB_NAME; SHOW TABLES;" | grep -q "wp_"; then
    echo "Database already contains tables"
fi