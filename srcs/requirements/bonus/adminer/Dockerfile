FROM debian:bookworm-slim

LABEL name="adminer"
LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.version="inception"


RUN apt update

RUN apt install -y php-fpm php-mysql

ADD https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php  /var/www/html/adminer.php
ADD https://cdn.jsdelivr.net/gh/pepa-linha/Adminer-Design-Dark/adminer.css /var/www/html/adminer.css
RUN chmod 755 /var/www/html/adminer.php
RUN chmod 755 /var/www/html/adminer.css
RUN sed "s/^listen = .*/listen = 0.0.0.0:9600/" -i /etc/php/8.2/fpm/pool.d/www.conf

HEALTHCHECK --start-period=10s --timeout=10s --interval=10s --retries=3 CMD ["pidof", "php-fpm8.2"]

WORKDIR /var/www/html
ENTRYPOINT ["php-fpm8.2", "-F"]
EXPOSE 9600