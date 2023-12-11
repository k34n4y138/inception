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
    --dbname=$WORDPRESS_DB_NAME \
    --dbuser=$WORDPRESS_DB_USER \
    --dbpass=$WORDPRESS_DB_PASSWORD \
    --dbhost=$WORDPRESS_DB_HOST \
    || fatal "Failed to create wp-config.php"


echo "installing wordpress"
wp core install  --allow-root \
    --url=$WORDPRESS_URL \
    --title="$WORDPRESS_TITLE" \
    --admin_user=$WORDPRESS_ADMIN \
    --admin_password=$WORDPRESS_ADMIN_PASSWORD \
    --admin_email=$WORDPRESS_ADMIN_EMAIL \
    || fatal "Failed to install wordpress"

if [ $(wp user list --allow-root | grep $WORDPRESS_USER | wc -l) -lt 1 ]
then
wp user create --allow-root \
    $WORDPRESS_USER \
    $WORDPRESS_USER_EMAIL \
    --role=author \
    --user_pass=$WORDPRESS_USER_PASSWORD \
    || fatal "Failed to create user"
fi

chown -R wordpress:wordpress /var/www/wordpress/wp-config.php /var/www/wordpress/wp-content

