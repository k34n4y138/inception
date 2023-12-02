# Project Inception - Containers based web project 

## Overview

This project aims to create a multi-container web application using Docker and Docker Compose. The project's goal is to serve a simple wordpress blog and a portfolio webpage and ship the project in docker compose. The project is based on the 1337|42 project called **INCEPTION**.

## Project Structure

This project involves constructing and configuring a system of services, each residing in its designated container. These services include:

1. **MariaDB**:  Database service with a designated volume.
2. **Wordpress Blog**:  Served through a php-fpm daemon.
3. **FTP**:  Accessing WordPress's wp-content volume.
4. **Redis**:  Utilized as a cache.
5. **Adminer**:  Database management tool.
6. **Portfolio Webpage**:  Custom portfolio webpage.
7. **Service of Choice**:  To be determined later.

## Services Overview

### MariaDB
The MariaDB service functions as the project's primary database. It operates within its designated volume to ensure data persistence and efficient management.

### Wordpress Blog
The WordPress blog is served through a php-fpm daemon, enabling dynamic content delivery and website functionality. Its content is isolated within specific volume.

### Nginx
The Nginx webserver acts as the entry point to the system, managing incoming traffic and routing it to the respective services within the private network.

### FTP
The FTP service facilitates file transfer and access to WordPress's wp-content volume. It enables efficient management and manipulation of website content.

### Redis
Utilized as a cache, Redis enhances the system's performance by storing frequently accessed data and reducing load times.

### Adminer
Adminer serves as the database management tool, allowing convenient access and administration of the MariaDB service.

### Portfolio Webpage
The project includes a custom-built portfolio webpage, offering a showcase of work and personal projects, this part come in handy as I'm about to start my internship search.

### Service of Choice
A service yet to be determined will be integrated into the system, adding further functionality or features.

## Setup and Configuration

### Network Isolation
All containers are orchestrated within a private network. Mandatory part specifies that the network's entry point is the nginx through 443 port with SSL enabled. for bonus part other ports are allowed to be exposed as needed.

### SSL Enabled Nginx
The Nginx container acts as the entry point to the system, utilizing SSL for secure communication. It manages incoming traffic and routes it to the respective services within the private network.
sertificate is self signed and generated using openssl.

### Volumes
The project utilizes volumes to ensure data persistence and efficient management. Each service has its designated volume, with the exception of the Nginx container, which is configured to use a bind mount.

### secrets management
The project utilizes secrets management to ensure sensitive data is not exposed. The secrets are stored in a file named `.env` and are used by the docker-compose file.
