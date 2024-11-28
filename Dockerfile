FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/Stanko/pulsar.git && \
    cd pulsar && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    # rm -rf .git && \
    sed -i '/base:/d' vite.config.js

FROM node AS build

WORKDIR /pulsar
COPY --from=base /git/pulsar .
RUN npm install && \
    npm run build

FROM lipanski/docker-static-website

COPY --from=build /pulsar/docs .
