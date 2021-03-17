FROM php:8.0.3-cli-alpine3.13

LABEL maintainer="Made Team <contact@made.dev>"
LABEL org.opencontainers.image.source="https://github.com/made/docker_alpine-php"

# Default ENV variables. These can be overridden by passing ENV when running the container (RUN).
ENV APP_ENV=prod \
    APP_DEBUG=false \
    LOG_LEVEL=warn

    # To install php extensions use -> docker-php-ext-install
    # @see https://github.com/mlocati/docker-php-extension-installer

# Copy necessary files
COPY ./scripts /usr/local/bin

RUN chmod -R a+x /usr/local/bin \
    && mkdir -p /var/php \
    && chmod -R 0755 /var/php

# Preparing the environment
WORKDIR /var/php

# Startup script
ENTRYPOINT ["docker-php-entrypoint"]
CMD [ "php", "-a" ]
