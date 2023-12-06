#!/bin/bash


function fatal () {
    echo "FATAL ERROR: $1"
    exit 1
}

# check if wp-config.php has PLACEHOLDERs
#    if yes, call setup_database.sh then followed by setup_config.sh

# if grep -q "PLACEHOLDER" /var/www/wordpress/wp-config.php; then
#     /tools/setup_database.sh || fatal "Failed to setup database"
#     /tools/setup_config.sh || fatal "Failed to setup config"
# fi

while true; do
    sleep 1;
done

