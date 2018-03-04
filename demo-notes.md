```bash
docker version
```

## Containers

```bash
docker container run hello-world
# what just happened?
# docker run

docker container run -it --name ubuntu-bash ubuntu bash
ps -eaf # in ubuntu

docker container ls
docker container ls -a
docker ps
```

- container names
- docker container run: create container 

```bash
docker container run -i -t --publish 8080:80 --name nginx-server nginx
docker container rm nginx-server

docker container run -d --publish 8080:80 --name nginx-server nginx
docker container logs nginx-server

docker container stop nginx-server
docker container start nginx-server
docker container restart nginx-server # stops then starts container

docker container stop nginx-server
docker container rm nginx-server
```

## Images

- Main task of Docker is writing images
- Image built from Dockerfile
- start with a base image (scratch)
- One layer for every line
- rebuild: use cache
- learning tip: study Dockerfiles from official repos and Docker Captains

```bash
docker container run -it node:8.9.4 bash
```

```Dockerfile
FROM node:8.9.4

RUN mkdir /opt/app
WORKDIR /opt/app

# ENV variables like export
ENV NODE_ENV=development

# COPY vs ADD
# copy from build context, into
COPY package.json package.json
COPY yarn.lock yarn.lock

# RUN (command / change) the file system
# intermediate containers are used to build images
RUN yarn

# we'll do something different with this later
COPY tsconfig.json tsconfig.json
COPY tslint.json tslint.json
COPY .angular-cli.json .angular-cli.json
COPY src src

EXPOSE 4200

# CMD vs ENTRYPOINT
ENTRYPOINT [ "yarn", "serve" ]
```

```bash
# build after COPY yarn.lock yarn.lock
docker build -t haydenbr/bob-is-cool .

# build context
# -f option

# built after COPY src src
docker build -t haydenbr/bob-is-cool .
```

- finish and build the whole thing
- docker run it!
- demonstrate cache
	-- change src, rebuild
	-- change package.json, rebuild

## Mounts and Volumes

- Plug directories into container
- bind mount: mount files from host machine
- volumes: mount volumes from host machine in Docker managed storage

### Mounts

```bash
mkdir bob
docker container run --mount src=$(pwd)/bob,dst=/bob,type=bind ubuntu bash

# in container
echo 'Bob is cool!' >> bob.txt

# in new tab, on host
cat bob/bob.txt
docker container rm -v
```

```bash
docker container run -it -p 4200:4200 --mount src=$(pwd)/src,dst=/opt/app/src,type=bind haydenbr/bob-is-cool
```

```bash
docker volume create bob
docker container run --mount src=bob,dst=/bob,type=volume ubuntu bash
docker container run --mount src=bob,dst=/bob,type=volume alpine sh
```

```bash
docker volume create mongo-db
docker volume create mongo-configdb
docker run -d -p 27017:27017 --mount src=mongo-db,dst=/data/db,type=volume --mount src=mongo-configdb,dst=/data/configdb,type=volume --name mongod mongo:3.6.2-jessie mongod
docker run --name mongo-shell -it --link mongod mongo:3.6.2-jessie bash
mongo $MONGOD_PORT_27017_TCP_ADDR:$MONGOD_PORT_27017_TCP_PORT
# read write from shell
# read write from robo mongo
# kill mongod and try to read
```

## Under the hood

### Control groups

```bash
docker run -it --memory 64m --memory-swap 64m ubuntu bash
# docker stats in new tab
:(){ :|: & };:
```

### Union file system

```bash
docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
docker inspect haydenbr/bob-is-cool
# ls each of the image layers

docker run -it --name copy-on-write ubuntu bash
echo 'Bob is cool!' >> bob.txt
# inspect the container and ls the upperdir
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /opt/app
WORKDIR /opt/app
ADD . /opt/app
RUN yarn

EXPOSE 8100 35729 53703
```

```.dockerignore
.git
node_modules
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /opt/app
WORKDIR /opt/app
ADD package.json package.json
RUN yarn
ADD . /opt/app

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /opt/app
WORKDIR /opt/app
ADD docker/package.json package.json
RUN yarn

ADD ionic.config.json ionic.config.json
ADD docker/config.xml config.xml
ADD /scripts /scripts
ADD /webpack /webpack
ADD tslint.json tslint.json
ADD tsconfig.json tsconfig.json
ADD package.json package.json
ADD config.xml config.xml

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /opt/app
WORKDIR /opt/app
ADD docker/package.json package.json
RUN yarn

# for live reload
EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4-alpine
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /opt/app && \
		apk update && \
		apk add --no-cache ncftp=3.2.6-r1 && \
		rm -r /var/cache/apk
WORKDIR /opt/app	

ADD docker/package.json package.json
RUN yarn && yarn cache clean

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```.dockerignore
.git
.gitignore
*.json
*.md
*.xml
docker-compose.yml
node_modules
platforms
plugins
resources
scripts
src
webpack
www
```

- look at the bump script: copy dependencies
