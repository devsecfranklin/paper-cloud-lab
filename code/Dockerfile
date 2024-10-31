# THIS IS AN EXAMPLE Dockerfile

FROM node:22-alpine

LABEL maintainer="Franklin D <devsecfranklin@duck.com>"
LABEL org.opencontainers.image.source=https://github.com/devsecfranklin/paper-cloud-lab
LABEL org.opencontainers.image.description="Cloudlab Paper"
LABEL org.opencontainers.image.licenses=MIT

ENV NODE_ENV=production

COPY ["app.js", "package.json", "package-lock.json", "./"]

RUN npm install --production

COPY . .

ENTRYPOINT ["node", "app.js"]
