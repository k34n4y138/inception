#!/bin/bash

(curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
        && chmod +x /usr/local/bin/wp) || (echo "wp-cli.phar download failed"; exit 1;)

mkdir -p /var/www/wordpress && cd /var/www/wordpress

(wp core download --allow-root) || (echo "Wordpress download failed"; exit 1;)

adduser --gecos "" --disabled-password wordpress
chown -R wordpress:wordpress /var/www/wordpress

echo "Wordpress installed"