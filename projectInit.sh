#!/bin/bash
echo "Initializing project"

git init
npm init -y
echo "Installing dev dependencies"
npm install nodemon --save-dev
npm install mocha --save-dev
npm install chai --save-dev

echo "Creating appjs"
touch app.js

echo "Creating default dirs and files"
mkdir tests
touch ./tests/test1.js
mkdir helpers
mkdir middleware
mkdir routes
touch README.md

echo "Adding setup to package.json"
node -e "let pkg=require('./package.json'); pkg.scripts.test='mocha';pkg.scripts.dev='nodemon app.js'; require('fs').writeFileSync('package.json', JSON.stringify(pkg, null, 2));"

printf "node_modules/" > .gitignore

echo "Adding docker files"
printf "node_modules \n npm-debug.log">> .dockerignore
printf "FROM node:16\n \n # Working dir\n WORKDIR /usr/src/app\n \n # Install dependencies\n COPY package*.json ./\n \n RUN npm install\n # prod:\n # RUN npm ci --only=production\n \n # Bundle app source\n COPY . .\n \n EXPOSE 8080\n CMD [ \"node\", \"app.js\" ]\n \n" > Dockerfile

git add .
git commit -m "Initialized app"
npm test
npm run dev
