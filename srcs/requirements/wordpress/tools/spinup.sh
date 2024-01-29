#!/bin/bash

set -e

function fatal () {
    echo "<!>FATAL ERROR: $1"
    exit 1
}

# ping database
if ! mysqladmin ping -h "$WORDPRESS_DB_HOST" -u "$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" 2>&1 | grep "alive" ; then
    echo "couldn't connect to database, attempting to setup and set credentials with root...";
    /tools/setup_database.sh || fatal "Failed to setup database";
    rm -rf /var/www/wordpress/wp-config.php
fi

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Setting up config...";
    /tools/setup_config.sh || fatal "Failed to setup config";
else
    echo "Using pre-existing config";
    /tools/set_credentials.sh || fatal "Failed to set credentials";
fi

echo "now running \`$@'"
exec -c $@
