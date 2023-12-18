# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: zmoumen <zmoumen@student.1337.ma>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/12/04 13:01:31 by zmoumen           #+#    #+#              #
#    Updated: 2023/12/04 13:22:01 by zmoumen          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


COMPOSE = docker compose -f ./srcs/compose.yaml



all: run

generate_passwords:
	@ if [ ! -f ./srcs/.env ] || [ "$(MAKECMDGOALS)" = "generate_passwords" ]; then \
	echo -n "\
	MARIADB_ROOT_PASSWORD='$$(openssl rand -hex 32)'\n\
	WORDPRESS_DB_NAME='$$(openssl rand -hex 32)'\n\
	WORDPRESS_DB_HOST='mariadb'\n\
	WORDPRESS_DB_USER='$$(openssl rand -hex 32)'\n\
	WORDPRESS_DB_PASSWORD='$$(openssl rand -hex 32)'\n\
	WORDPRESS_ADMIN='admin'\n\
	WORDPRESS_ADMIN_PASSWORD='$$(openssl rand -hex 32)'\n\
	WORDPRESS_ADMIN_EMAIL='zmoumen@student.1337.ma'\n\
	WORDPRESS_USER='user'\n\
	WORDPRESS_USER_PASSWORD='$$(openssl rand -hex 32)'\n\
	WORDPRESS_USER_EMAIL='user@example.com'\n\
	WORDPRESS_TITLE='INCEPTION'\n\
	WORDPRESS_URL='https://zmoumen.42.fr'\n\
	" > ./srcs/.env;\
	fi

generate_ssl:
	mkdir -p ./srcs/ssl
	@ if [ ! -f ./srcs/ssl/inception-ssl.key ] || [ ! -f ./srcs/ssl/inception-ssl.cert ] || [ "$(MAKECMDGOALS)" = "generate_ssl" ]; then \
	rm -rf ./srcs/ssl/inception-ssl.key ./srcs/ssl/inception-ssl.cert;\
	mkcert -key-file ./srcs/ssl/inception-ssl.key -cert-file ./srcs/ssl/inception-ssl.cert "zmoumen.42.fr" "*.zmoumen.42.fr";\
	fi

create_volume_folders:
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/mariadb

build: generate_passwords generate_ssl create_volume_folders
	$(COMPOSE) build

run: build
	$(COMPOSE) up -d

logs:
	$(COMPOSE) logs -f

clean:
	$(COMPOSE) down

fclean: clean
	$(COMPOSE) down -v --rmi all
	rm -rf ./srcs/ssl ./srcs/.env
	sudo rm -fr ~/data

.PHONY: all build run stop clean generate_passwords generate_ssl create_volume_folders logs fclean

