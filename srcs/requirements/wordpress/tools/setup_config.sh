#!/bin/bash


rm -rf /var/www/html/wp-config.php


wp config create --dbname=$WORDPRESS_DB_NAME --dbuser=$WORDPRESS_DB_USER --dbpass=$WORDPRESS_DB_PASSWORD --dbhost=$WORDPRESS_DB_HOST --allow-root --path=/var/www/worpress || (echo "Failed to create wp-config.php" && exit 1)

wp core install --url=$WORDPRESS_URL --title=$WORDPRESS_TITLE --admin_user=$WORDPRESS_ADMIN_USER --admin_password=$WORDPRESS_ADMIN_PASSWORD --admin_email=$WORDPRESS_ADMIN_EMAIL --allow-root --path=/var/www/worpress || (echo "Failed to install wordpress" && exit 1)

wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL --role=author --user_pass=$WORDPRESS_USER_PASSWORD --allow-root --path=/var/www/worpress || (echo "Failed to create user" && exit 1)

chown -R www:www /var/www/wordpress/wp-config.php /var/www/wordpress/wp-content
