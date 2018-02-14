FROM node:8.9.4-alpine

RUN mkdir /app
WORKDIR /app

COPY package.json package.json
RUN yarn && yarn cache clean
COPY src src

EXPOSE 3000

ENTRYPOINT [ "npm", "run", "serve" ]
