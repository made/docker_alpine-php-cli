# Alpine production docker image with php cli

:warning: This image is still in a very early release and may contain bugs or future versions contain breaking changes.
It is not completely done. So if you use it, use it with caution.
But we are accepting issues and suggestions already.
:warning:

This is the production image containing

- alpine
- php cli

## Supported ENV and ARG

All variables are optional.

| Stage | Variable              | Description                               | Default                         |
| ----- | --------------------- | ----------------------------------------- | ------------------------------- |
| RUN   | APP_ENV               | Set application environment               | prod                            |
| RUN   | APP_DEBUG             | Set application debug                     | false                           |
| RUN   | LOG_LEVEL             | Set application log level                 | warn                            |

The environment variables `APP_ENV`, `APP_DEBUG`, `LOG_LEVEL` have to also be implemented into the cli script to be used.

## BUILD
### Multi-Stage Build (for CI/CD)
Here an example multi-stage with node.    
Since node is always optional and not necessary in every php project, it's not included in the base image.    
To use node within your application image builds, you can follow the below steps.

````dockerfile
FROM composer:<version> AS composer
COPY ["composer.json", "composer.lock", "./"]
# run composer to install dependencies
RUN composer install --no-ansi --no-dev --no-interaction --no-suggest --optimize-autoloader


FROM this-image
# Copy project files of app into the container.
COPY ./ ./ 
# Then copy vendor from the node build phase into the current workdir
COPY --from=composer ./vendor ./vendor
# And do some other things you need.
...
````

## RUN
You can easily run scripts on the fly within your container.
The workspace is automatically set to the project root.    

### Execute commands in a running docker container
You can add your php script to the container by mounting it.
```shell
# These is just an example
docker run --rm --name=alpine-php-test -v <path-on-host-to-script>:/var/php/index.php <this-image> php index.php
# This is what I used locally to test
docker run --rm --name=alpine-php-test-container -v /usr/local/var/www/phpinfo.php:/var/php/index.php alpine-php-test php index.php
```

## Troubleshooting

### A directory or file which has been created during a build is missing in the final image.
1. Check the path and source in the Dockerfile (COPY)
2. When using docker-compose, ensure you are not mounting a volume over a root directory of the copied 
files. Because mounting happens after the build, the all directory/files within a mounted target will be overridden.
   
## Reference
- [PHP on Docker Hub](https://hub.docker.com/_/php)

