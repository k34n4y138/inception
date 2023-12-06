FROM debian:bookworm

LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.name="wordpress"
LABEL ma.1337.version="inception"

RUN apt update

RUN apt install -y php-fpm php-mysql curl mariadb-client


COPY ./tools/install_wordpress.sh /tools/

RUN chmod +x /tools/install_wordpress.sh && /tools/install_wordpress.sh
# separated to avoid rebuilding the image when changing the config

COPY ./tools/spinup.sh ./tools/setup_database.sh ./tools/setup_config.sh /tools/
RUN chmod +x /tools/*.sh
CMD [ "/spinup.sh"]
