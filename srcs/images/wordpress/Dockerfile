FROM debian:bookworm

LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.name="wordpress"
LABEL ma.1337.version="inception"

RUN apt update

RUN apt install -y curl mariadb-client php-fpm php-mysql php-mbstring php-xml php-gd php-curl php-zip php-imagick php-redis php-pear php-dev

COPY ./tools/install_wordpress.sh /tools/

RUN chmod +x /tools/install_wordpress.sh && /tools/install_wordpress.sh
# separated to avoid rebuilding the image when changing the config

COPY ./tools/setup_database.sh ./tools/setup_config.sh /tools/
RUN chmod +x /tools/*.sh
COPY ./tools/spinup.sh /spinup.sh
RUN chown wordpress:wordpress /spinup.sh && chmod +x /spinup.sh

WORKDIR /var/www/wordpress


# update php-fpm config
RUN sed "s/^listen = .*/listen = 0.0.0.0:9000/" -i /etc/php/8.2/fpm/pool.d/www.conf
RUN sed "s/^user = .*/user = wordpress/" -i /etc/php/8.2/fpm/pool.d/www.conf
RUN sed "s/^group = .*/group = wordpress/" -i /etc/php/8.2/fpm/pool.d/www.conf

HEALTHCHECK --interval=5s --timeout=10s --start-period=10s --retries=3 CMD ["pidof", "php-fpm8.2"]

EXPOSE 9000
ENTRYPOINT [ "/spinup.sh"]
CMD ["php-fpm8.2", "-F"]
