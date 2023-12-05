#!/bin/bash

echo "Starting MariaDB server";

if [ ! -z $MARIADB_ROOT_PASSWORD ]; then
    echo "root password provided, reseting root password";
    mysqld_safe --skip-grant-tables --skip-networking &
    while (! mysqladmin ping > /dev/null 2>&1); do
        sleep 1
    done;
   (mysql -e "USE mysql;
    UPDATE user SET host='%' where host='localhost' AND user='root';
    FLUSH PRIVILEGES;
    ALTER USER 'root'@'%' IDENTIFIED VIA mysql_native_password USING PASSWORD('$MARIADB_ROOT_PASSWORD');
    FLUSH PRIVILEGES;" && echo "root password reseted") || echo "ERROR: failed to reset root password";
    mysqladmin shutdown -u root -p$MARIADB_ROOT_PASSWORD || (echo "FATAL: failed to shutdown UNSECURE mysql instance!" && exit 1);
fi

exec mysqld_safe

