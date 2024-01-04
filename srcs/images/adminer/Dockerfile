FROM debian:bookworm

LABEL name="adminer"
LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.version="inception"


RUN apt update

RUN apt install -y php-fpm php-mysql

RUN apt install -y wget
RUN mkdir -p /var/www/html
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O /var/www/html/adminer.php

RUN sed "s/^listen = .*/listen = 0.0.0.0:9600/" -i /etc/php/8.2/fpm/pool.d/www.conf

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD ["pidof", "php-fpm8.2"]

WORKDIR /var/www/html
ENTRYPOINT ["php-fpm8.2", "-F"]
EXPOSE 9600