FROM debian:bookworm-slim

LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.name="wordpress"
LABEL ma.1337.version="inception"

RUN apt update

RUN apt install -y curl mariadb-client php-fpm php-mysql php-mbstring php-xml php-gd php-curl php-zip php-imagick php-redis php-pear php-dev

ADD  https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp

RUN chmod +x /usr/local/bin/wp && \
    mkdir -p /var/www/wordpress && \
    wp core download --path=/var/www/wordpress --allow-root && \
    chown -R www-data:www-data /var/www/wordpress

COPY ./tools /tools
RUN chmod +x /tools/*.sh


# update php-fpm config
RUN sed "s/^listen = .*/listen = 0.0.0.0:9000/" -i /etc/php/8.2/fpm/pool.d/www.conf

HEALTHCHECK --interval=5s --timeout=10s --start-period=10s --retries=3 CMD ["pidof", "php-fpm8.2"]

WORKDIR /var/www/wordpress
ENTRYPOINT [ "/tools/spinup.sh"]
CMD ["php-fpm8.2", "-F"]
EXPOSE 9000
