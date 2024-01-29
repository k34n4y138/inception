#!/bin/bash

set -e

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

cd /var/www/wordpress

rm -rf wp-config.php

# check that all required variables are set
if [ -z "$WORDPRESS_URL" \
    -o -z "$WORDPRESS_TITLE" \
    -o -z "$WORDPRESS_ADMIN" \
    -o -z "$WORDPRESS_ADMIN_PASSWORD" \
    -o -z "$WORDPRESS_USER" \
    -o -z "$WORDPRESS_USER_PASSWORD" \
    -o -z "$WORDPRESS_DB_NAME" \
    -o -z "$WORDPRESS_DB_USER" \
    -o -z "$WORDPRESS_DB_PASSWORD" \
    -o -z "$WORDPRESS_DB_HOST" \
    -o -z "$WORDPRESS_REDIS_HOST" \
    -o -z "$WORDPRESS_REDIS_PORT" \
    -o -z "$FTP_USER" \
    -o -z "$FTP_PASSWORD" \
    -o -z "$FTP_HOST" \
    ]; then
    fatal "Missing required environment variables"
fi



echo "creating wp-config.php"
wp config create --allow-root \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    || fatal "Failed to create wp-config.php"

echo "setting up FTP"
wp --allow-root config set FTP_USER $FTP_USER
wp --allow-root config set FTP_PASS $FTP_PASSWORD
wp --allow-root config set FTP_HOST $FTP_HOST
wp --allow-root config set FTP_SSL false

# remove redis if exists 
# wp --allow-root plugin deactivate redis-cache
echo "setting up redis"
wp --allow-root config set WP_REDIS_PREFIX "inception42"
wp --allow-root config set WP_REDIS_HOST $WORDPRESS_REDIS_HOST
wp --allow-root config set WP_REDIS_PORT $WORDPRESS_REDIS_PORT

echo "creating database"
wp core install  --allow-root \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN""@inception.demo" \
    || fatal "Failed to install wordpress"

wp --allow-root plugin install redis-cache
wp --allow-root plugin activate redis-cache
wp --allow-root redis update-dropin


if ! wp --allow-root user get "$WORDPRESS_USER"; then
    wp --allow-root user create "$WORDPRESS_USER" "$WORDPRESS_USER"@inception.demo --role=author --user_pass="$WORDPRESS_USER_PASSWORD";
else
    wp --allow-root user update "$WORDPRESS_USER" --user_pass="$WORDPRESS_USER_PASSWORD";
fi



# set FTP credentials


