FROM node:7.4.0
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

# ENV or ARG?
ENV NODE_ENV=development

# update system level tools I need
RUN apt-get update
RUN apt-get install ncftp

# node_modules
RUN mkdir /app
WORKDIR /app
ADD docker/dependencies.json /app/package.json
RUN npm i
RUN npm i -g ionic@3.9.1 cordova@7.0.1

# platform dependency
ADD docker/dependencies-scripts.json /app/package.json
ADD ionic.config.json /app/ionic.config.json
ADD docker/config.xml /app/config.xml
RUN npm run add-platforms

# for live reload
EXPOSE 8100 35729 53703
ENTRYPOINT [ "npm", "run", "browser" ]

# run it with this
# docker run -it -p 8100:8100 -p 35729:35729 -p 53703:53703 -v $(pwd)/src:/app/src unboxedtechnology/new-years-resolutions
