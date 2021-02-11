FROM node:12.14.1 As development

#Set Working Directory
WORKDIR /usr/src/app

#Copy package.json file
COPY package.json package.json

#Install dev dependencies
RUN npm install --only=development

#Copy all the files
COPY . .

#Build
RUN npm run prebuild

RUN npm run build

FROM node:12.14.1 As production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

COPY --from=development /usr/src/app/dist ./dist

#Start the app
CMD ["node", "dist/main"]