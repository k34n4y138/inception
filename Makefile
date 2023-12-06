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

# make file for inception, a docker project


COMPOSE = docker compose -f ./srcs/compose.yaml

all: build run

build:
	$(COMPOSE) build

run:
	$(COMPOSE) up -d

stop:
	$(COMPOSE) down -v

clean:
	$(COMPOSE) down -v --rmi all

