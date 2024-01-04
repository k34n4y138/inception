#!/bin/bash

set -e

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

cd /var/www/wordpress

rm -rf wp-config.php


echo "creating wp-config.php"
wp config create --allow-root \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    || fatal "Failed to create wp-config.php"


echo "installing wordpress"
wp core install  --allow-root \
    --url="$WORDPRESS_URL" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    || fatal "Failed to install wordpress"

if ! wp --allow-root user get $WORDPRESS_USER; then
    wp --allow-root user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD;
else
    wp --allow-root user update $WORDPRESS_USER --user_pass=$WORDPRESS_USER_PASSWORD;
fi


# enable redis cache
if [ "$WORDPRESS_REDIS_HOST" != "" ]; then
    echo "enabling redis cache"
    wp --allow-root plugin install redis-cache
    wp --allow-root config set WP_REDIS_PREFIX "inception42"
    wp --allow-root config set WP_REDIS_HOST $WORDPRESS_REDIS_HOST
    wp --allow-root config set WP_REDIS_PORT $WORDPRESS_REDIS_PORT
    wp --allow-root plugin activate redis-cache
    wp --allow-root redis update-dropin
    # anonymous user
fi


# set FTP credentials
wp --allow-root config set FTP_USER $FTP_USER
wp --allow-root config set FTP_PASS $FTP_PASSWORD
wp --allow-root config set FTP_HOST $FTP_HOST
wp --allow-root config set FTP_SSL false

chown -R wordpress:wordpress /var/www/wordpress/wp-config.php /var/www/wordpress/wp-content

