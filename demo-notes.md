## Containers

docker container run hello-world
docker container run -it ubuntu bash

docker container run --publish 8080:80 nginx
docker container run -d --publish 8080:80 nginx
docker container run -i -t --publish 8080:80 --name nginx-server nginx

docker container ls
docker container ls -a

docker container stop
docker container start
docker container restart

docker container rm

## Images

docker container run -it node:8.9.4 bash

```Dockerfile
FROM node:8.9.4

RUN mkdir /app
WORKDIR /app

# ENV vs ARG
ENV NODE_ENV=development

# COPY vs ADD
COPY package.json package.json
COPY yarn.lock yarn.lock
RUN yarn
COPY tsconfig.json tsconfig.json
COPY tslint.json tslint.json
COPY .angular-cli.json .angular-cli.json
COPY src src

EXPOSE 4200

# CMD vs ENTRYPOINT
ENTRYPOINT [ "yarn", "serve" ]
```

- write until COPY yarn.lock
- docker build -t bob-is-cool .

	- build context: some portion of host fs that daemon can access to create image
	-f option

- finish and build the whole thing
- docker run it!
- demonstrate cache

	- change src, rebuild
	- change package.json, rebuild

- learning tip: study Dockerfiles from official repos and Docker Captains

## Volumes

mkdir bob
docker container run -v $(pwd)/bob:/bob ubuntu bash

# echo into bob.txt in bob
# in new tab, look at bob.txt

docker container rm -v

/////////////////////////////////////////////

Run bob is cool with -v src

/////////////////////////////////////////////

docker volume create bob
docker container run --mount source=bob,target=/bob ubuntu bash
docker container run --mount source=bob,target=/bob alpine sh

docker volume create mongo-db
docker volume create mongo-configdb
docker run -d -p 27017:27017 --mount source=mongo-db,target=/data/db --mount source=mongo-configdb,target=/data/configdb --name mongod mongo:3.6.2-jessie mongod
docker run --name mongo-shell -it --link mongod mongo:3.6.2-jessie bash
mongo $MONGOD_PORT_27017_TCP_ADDR:$MONGOD_PORT_27017_TCP_PORT

-- kill and remove mongod container
-- run new mongod container
-- connect via robo mongo
-- data is still there!

## Under the hood

docker run -it --memory 64m --memory-swap 64m ubuntu bash
# docker stats in new tab
:(){ :|: & };:

docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh
docker inspect bob-is-cool

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN yarn

EXPOSE 8100 35729 53703
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

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /app
WORKDIR /app
ADD package.json /app/package.json
RUN yarn
ADD . /app

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /app
WORKDIR /app
ADD docker/package.json /app/package.json
RUN yarn

ADD ionic.config.json /app/ionic.config.json
ADD docker/config.xml /app/config.xml
ADD /scripts /app/scripts
ADD /webpack /app/webpack
ADD tslint.json /app/tslint.json
ADD tsconfig.json /app/tsconfig.json
ADD package.json /app/package.json
ADD config.xml /app/config.xml

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN apt-get update
RUN apt-get install ncftp

RUN mkdir /app
WORKDIR /app
ADD docker/package.json /app/package.json
RUN yarn

# for live reload
EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```

```Dockerfile
FROM node:8.9.4-alpine
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /app && \
		apk update && \
		apk add --no-cache ncftp=3.2.6-r1 && \
		rm -r /var/cache/apk
WORKDIR /app

ADD docker/package.json package.json
RUN yarn && yarn cache clean

EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "serve" ]
```