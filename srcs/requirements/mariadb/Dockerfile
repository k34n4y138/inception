FROM debian:bookworm

LABEL ma.1337.author="zmoumen <zmoumen@student.1337.ma>"
LABEL ma.1337.version="inception"

RUN apt update

RUN apt install -y mariadb-server mariadb-client

COPY ./spinup.sh /spinup.sh
RUN chmod +x /spinup.sh

EXPOSE 3306

ENTRYPOINT [ "/spinup.sh" ]
CMD [ "mysqld_safe", "--bind-address=0.0.0.0", "--port 3306" ]