###############################################################################
# build environment                                                           #
###############################################################################
FROM node:lts-alpine as build

WORKDIR /app
COPY client/package*.json ./
RUN npm install --only=prod

COPY client/ ./
RUN npm run build
RUN ls

###############################################################################
# deployable environment                                                      #
###############################################################################
FROM node:lts-alpine as deployable
# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY server/package*.json ./


RUN npm install --only=prod

# Bundle app source
COPY server/ ./
COPY --from=build /app/build/ /usr/src/app/public/

EXPOSE 8080
CMD [ "node", "./bin/www" ]
