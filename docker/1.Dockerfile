FROM node:8.5.0
LABEL maintainer="Unboxed Technology LLC, https://unboxedtechnology.com"

ENV NODE_ENV=development

RUN mkdir /app
WORKDIR /app
ADD . /app
RUN npm i

EXPOSE 8100 35729 53703

# docker run -it -p 8100:8100 -p 35729:35729 -p 53703:53703 \
#   -v $(pwd)/src:/app/src unboxedtechnology/new-years-resolutions \
#   npm run browser
