# Start from an official PHP image with Apache
FROM php:8.2-apache

# Update and install any necessary system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/


# Install PHP extensions as needed
# For example: pdo_mysql for database connectivity
RUN install-php-extensions \
    pdo_mysql \
    mysqli \
    pdo_sqlite \
    sqlite3 \
    mbstring \
    intl \
    gd

# Enable Apache mod_rewrite if needed
RUN a2enmod rewrite

# Copy application files into the container
# If you prefer, you could rely solely on volumes in docker-compose and not copy.
WORKDIR /var/www/html
COPY . /var/www/html/

# Set recommended PHP.ini settings
# You can create a custom php.ini file in your repo and COPY it over to /usr/local/etc/php/
# For now, just as an example, let's increase memory_limit
RUN echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory-limit.ini

# Expose the web server on port 80
EXPOSE 80

# The default command uses Apache started via the official base image
