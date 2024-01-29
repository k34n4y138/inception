#!/bin/bash

set -e
echo "Updating credentials..."

if ! wp --allow-root user get "$WORDPRESS_ADMIN"; then
    wp --allow-root user create "$WORDPRESS_ADMIN" "$WORDPRESS_ADMIN"@inception.demo --role="administrator" --user_pass="$WORDPRESS_ADMIN_PASSWORD";
else
    wp --allow-root user update "$WORDPRESS_ADMIN" --user_pass="$WORDPRESS_ADMIN_PASSWORD";
fi

if ! wp --allow-root user get "$WORDPRESS_USER"; then
    wp --allow-root user create "$WORDPRESS_USER" "$WORDPRESS_USER"@inception.demo --role=author --user_pass="$WORDPRESS_USER_PASSWORD";
else
    wp --allow-root user update "$WORDPRESS_USER" --user_pass="$WORDPRESS_USER_PASSWORD";
fi
