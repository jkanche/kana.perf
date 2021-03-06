#!/bin/bash

# clone the perf branch of the repo
branch="perf"

mkdir -p ./app-results

if [ ! -d "./kana" ]; then
    git clone http://github.com/jkanche/kana -b $branch
fi

cd kana

# make sure its upto date
git pull origin $branch

# install npm dependencies
npm install

# generate builds
npm run build

# run the app from the build directory
npx serve -s build