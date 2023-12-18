#!/bin/bash

set -e

function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}


if mysqladmin ping -h $WORDPRESS_DB_HOST -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD > /dev/null 2>&1; then
    echo "Setting up database...";
     /tools/setup_database.sh || fatal "Failed to setup database";
fi

if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Setting up config...";
    /tools/setup_config.sh || fatal "Failed to setup config";
fi

exec -c $@
