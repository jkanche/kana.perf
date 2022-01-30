#!/bin/bash

if [ ! -d "./scran-cli" ]; then
    git clone http://github.com/ltla/scran-cli
fi

cd scran-cli

cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build

run_dataset () {
    echo "dataset : $1"
    path="./data/$1"
    echo "path: $path"
    mkdir -p $1
    for i in {1..3}; do
        echo "run $i" 
        /usr/bin/time -v ./build/scran -t 8 --skip-output $path/matrix.mtx.gz $path/features.tsv.gz > "./cli-results/$1/$i.log" 2>&1 
    done
}

mkdir -p ./cli-results

run_dataset "zeisel-brain"
run_dataset "zilionis-lung"
run_dataset "paul-hsc"
run_dataset "ernst-sperm"
run_dataset "bacher-tcell"
run_dataset "bach-mammary"