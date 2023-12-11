#!/bin/bash

echo "Starting MariaDB server";

if [ -f /run/secrets/mariadb_secrets ]; then
    echo "root password file provided, reseting root password";
    export $(cat run/secrets/mariadb_secrets | sed 's/#.*//g' | xargs)
    if [ -z "$MARIADB_ROOT_PASSWORD" ]; then
        echo "ERROR: root password file is empty";
        exit 1;
    fi
    mysqld_safe --skip-grant-tables --skip-networking &
    while (! mysqladmin ping > /dev/null 2>&1); do
        sleep 1
    done;
   (mysql -e "USE mysql;
    UPDATE user SET host='%' where host='localhost' AND user='root';
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MARIADB_ROOT_PASSWORD');
    FLUSH PRIVILEGES;" && echo "root password reseted") || echo "ERROR: failed to reset root password";
    mysqladmin shutdown -u root -p"$MARIADB_ROOT_PASSWORD" || (echo "FATAL: failed to shutdown UNSECURE mysql instance!" && exit 1);
fi

exec $@