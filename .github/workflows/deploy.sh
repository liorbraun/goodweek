#!/bin/bash

# בקשת שם הריפוזיטורי ושם המשתמש ב-GitHub
echo "Enter your GitHub username:"
read USERNAME
echo "Enter your repository name:"
read REPO_NAME

echo "Enter your project folder name (or press Enter for 'my-app'):"
read APP_NAME
APP_NAME=${APP_NAME:-my-app}

# יצירת פרויקט React
if [ ! -d "$APP_NAME" ]; then
  echo "Creating React app..."
  npx create-react-app $APP_NAME
else
  echo "React app already exists. Skipping creation."
fi

cd $APP_NAME

echo "Initializing Git repository..."
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/$USERNAME/$REPO_NAME.git
git push -u origin main

# התקנת gh-pages
npm install gh-pages --save-dev

# הוספת homepage ל-package.json
HOMEPAGE_URL="https://$USERNAME.github.io/$REPO_NAME"
jq --arg url "$HOMEPAGE_URL" '. + {homepage: $url}' package.json > temp.json && mv temp.json package.json

# הוספת סקריפטים ל-package.json
jq '.scripts += {"predeploy": "npm run build", "deploy": "gh-pages -d build"}' package.json > temp.json && mv temp.json package.json

# פריסה ל-GitHub Pages
echo "Deploying to GitHub Pages..."
npm run deploy

echo "Deployment complete! Your site is live at: $HOMEPAGE_URL"
