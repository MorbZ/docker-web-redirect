# Docker-Web-Redirect #

![Docker Build Status](https://img.shields.io/docker/build/morbz/docker-web-redirect.svg) ![Docker Pulls](https://img.shields.io/docker/pulls/morbz/docker-web-redirect.svg) ![Docker Stars](https://img.shields.io/docker/stars/morbz/docker-web-redirect.svg)

This Docker container listens on port 80 and redirects all web traffic to the given target domain/URL.

## Features ##
- Lightweight: Uses only ~2 MB RAM on Linux
- Keeps the URL path and GET parameters
- Permanent or temporary redirect

## Usage ##
### Docker run ###
The target domain/URL is set by the `REDIRECT_TARGET` environment variable.  
Possible redirect targets include domains (`mydomain.net`), paths (`mydomain.net/my_page`) or specific protocols (`https://mydomain.net/my_page`).  

**Example:** `$ docker run --rm -d -e REDIRECT_TARGET=mydomain.net -p 80:80 morbz/docker-web-redirect`

### Paths are retained ###
The URL path and GET parameters are retained by default. That means that a request to `http://myolddomain.net/index.php?page=2` will be redirected to `http://mydomain.net/index.php?page=2` when `REDIRECT_TARGET=mydomain.net` is set. If you do not want to retain the path and GET parameters, set the environment variable `RETAIN_PATH` to `false`.

### Permanent redirects ###
Redirects are, by default, permanent (HTTP status code 301). That means browsers will cache the redirect and will go directly to the new site on further requests. Also search engines will recognize the new domain and change their URLs. To make redirects temporary (HTTP status code 302), e.g. for site maintenance, set the environment variable `REDIRECT_TYPE` to `redirect`.

## Docker Compose ##
This image can be combined with the [jwilder nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/). A sample docker-compose file that redirects `myolddomain.net` to `mydomain.net` could look like this:

```yaml
version: '3'
services:
  redirect:
    image: morbz/docker-web-redirect
    restart: always
    environment:
      - VIRTUAL_HOST=myolddomain.net
      - REDIRECT_TARGET=mydomain.net
```
