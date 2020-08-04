# Docker-Web-Redirect #

![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/m4rc77/docker-web-redirect) 
![Docker Cloud Automated build](https://img.shields.io/docker/cloud/automated/m4rc77/docker-web-redirect) 
![Docker Pulls](https://img.shields.io/docker/pulls/m4rc77/docker-web-redirect)
![Docker Stars](https://img.shields.io/docker/stars/m4rc77/docker-web-redirect)

This Docker container listens (by default) on port 8080 and redirects all web traffic permanently to the given target domain/URL.

_Hint: This repo was forked from https://github.com/MorbZ/docker-web-redirect._

## Features ##
- Lightweight: Uses only ~2 MB RAM on Linux
- Keeps the URL path and GET parameters
- Permanent redirect (HTTP 301)
- Image Size only ~25MB
- Image runs for security reasons with non-root user

## Usage ##
### Docker run ###
The target domain/URL is set by the `REDIRECT_TARGET` environment variable.
The port may be changed to another port than 8080 by the `PORT` environment variable.
Possible redirect targets include domains (`mydomain.net`), paths (`mydomain.net/my_page`) or specific protocols (`https://mydomain.net/my_page`).  

**Example (Listen on Port 8080):** `$ docker run --rm -d -e REDIRECT_TARGET=mydomain.net -p 8080:8080 m4rc77/docker-web-redirect`

**Example (Listen on Port 80):** `$ docker run --rm -d -u0:0  -e REDIRECT_TARGET=mydomain.net -e PORT=80 -p 80:80 m4rc77/docker-web-redirect `

### Paths are retained ###
The URL path and GET parameters are retained. That means that a request to `http://myolddomain.net/index.php?page=2` will be redirected to `http://mydomain.net/index.php?page=2` when `REDIRECT_TARGET=mydomain.net` is set.

### Permanent redirects ###
Redirects are permanent (HTTP status code 301). That means browsers will cache the redirect and will go directly to the new site on further requests. Also search engines will recognize the new domain and change their URLs. This means this image is not suitable for temporary redirects e.g. for site maintenance.

## Docker Compose ##
This image can be combined with the [jwilder nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/). A sample docker-compose file that redirects `myolddomain.net` to `mydomain.net` could look like this:

```yaml
version: '3'
services:
  redirect:
    image: m4rc77/docker-web-redirect
    restart: always
    environment:
      - VIRTUAL_HOST=myolddomain.net
      - REDIRECT_TARGET=mydomain.net
      - VIRTUAL_PORT=8080
```

### Build the image yourself ###
`$ docker build -t m4rc77/docker-web-redirect:latest .`
