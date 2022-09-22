# FROM node:14-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm install && npm cache clean --force
# COPY . .
# CMD node app.js
# EXPOSE 7000

FROM eclipse-temurin:11-jdk-alpine
RUN apk -U upgrade \
  && apk add --repository https://dl-cdn.alpinelinux.org/alpine/v3.14/main/ --no-cache \
    "nodejs<16" \
    npm \
    yarn \
    curl
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
CMD node app.js
EXPOSE 7000