FROM node:8.5.0
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN npm i

EXPOSE 8100 35729 53703
