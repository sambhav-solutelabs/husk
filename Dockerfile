FROM node:12.13-alpine As development

#Set Working Directory
WORKDIR /usr/src/app

#Copy package.json file
COPY package*.json ./

#Install dev dependencies
RUN npm install --only=development

#Copy all the files
COPY . .

#Build
RUN npm run build

FROM node:12.13-alpine As production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=development /usr/src/app/dist ./dist

#Start the app
CMD ["node", "dist/main"]