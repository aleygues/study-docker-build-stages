FROM cypress/base:14

WORKDIR /app
RUN npm i -g http-server
COPY package.json package.json
RUN npm i
COPY tsconfig.json tsconfig.json
COPY cypress.json cypress.json
COPY cypress cypress
COPY public public
COPY src src
RUN npm run build

CMD http-server ./build -c-1