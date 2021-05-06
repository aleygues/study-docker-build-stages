FROM node:alpine AS dev
WORKDIR /app
COPY package.json package.json
RUN npm i
COPY tsconfig.json tsconfig.json
COPY public public
COPY src src
RUN npm run build
CMD npm start

FROM cypress/included:6.5.0 AS test
WORKDIR /app
RUN npm i -g http-server
COPY --from=dev /app/node_modules node_modules
COPY --from=dev /app/build build
COPY package.json package.json
COPY cypress.json cypress.json
COPY cypress cypress
CMD npx concurrently "http-server ./build -c-1" "npx cypress run --config baseUrl=http://localhost:8080"

FROM node:alpine AS prod
WORKDIR /app
RUN npm i -g http-server
COPY --from=dev /app/build build
CMD http-server ./build -c-1
