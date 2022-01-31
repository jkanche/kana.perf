#!/bin/bash

if [ ! -d "./scran-cli" ]; then
    git clone http://github.com/ltla/scran-cli
fi

cd scran-cli

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build

mkdir -p ./cli-results
