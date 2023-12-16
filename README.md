# Dokku Private Registry

Private Docker [registry server](https://hub.docker.com/_/registry) deployed as a [dokku](https://dokku.com) app with HTTP Basic auth using`AUTH_USER` and `AUTH_PASSWORD` env variables.

## Setup

```bash
dokku apps:create my-registry

dokku config:set my-registry REGISTRY_HTTP_SECRET=$(openssl rand -hex 64)
dokku config:set my-registry AUTH_USER=user AUTH_PASSWORD=$(openssl rand -hex 16)

dokku storage:mount my-registry /var/lib/dokku/data/storage/my-registry:/var/lib/registry
dokku ps:set-restart-policy my-registry unless-stopped

dokku domains:add my-registry my-registry.example.com
dokku letsencrypt:enable my-registry
```

## Deploy

```bash
# Clone this repository and push to to the host as a normal dokku app.
git remote add dokku dokku@dokku.example.com:my-registry
git push dokku master
```

Once the app is deployed, you need to set the ports and nginx config server-side.

```bash
# Set the proper ports.
dokku ports:set my-registry https:443:5000 http:80:5000

# To avoid 413 Request Entity Too Large errors.
dokku nginx:set my-registry client-max-body-size 1g
dokku ps:restart my-registry
```

## Test

Make sure you can login and push/pull images.

```bash
docker login -u user -p password my-registry.example.com

docker pull busybox:latest
docker tag busybox:latest my-registry.example.com/user/busybox:latest
docker push my-registry.example.com/user/busybox:latest

docker rmi busybox:latest my-registry.example.com/user/busybox:latest
docker pull my-registry.example.com/user/busybox:latest
```

## Garbage Collect

```bash
dokku run my-registry /bin/registry garbage-collect /app/config.yml
```
