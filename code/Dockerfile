# syntax=docker/dockerfile:1

FROM node:19-alpine

LABEL maintainer="Franklin D <devsecfranklin@duck.com>"

ENV NODE_ENV=production

COPY ["app.js", "package.json", "package-lock.json", "./"]

RUN npm install --production

COPY . .

ENTRYPOINT ["node", "app.js"]
