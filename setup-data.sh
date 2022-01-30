#!/bin/bash

mkdir -p ./data/zilionis-lung
wget https://github.com/clusterfork/random-test-files/releases/download/zilionis-lung-v1.0.0/matrix.mtx.gz -P ./data/zilionis-lung
wget https://github.com/clusterfork/random-test-files/releases/download/zilionis-lung-v1.0.0/features.tsv.gz -P ./data/zilionis-lung

mkdir -p ./data/zeisel-brain
wget https://github.com/clusterfork/random-test-files/releases/download/zeisel-brain-v1.0.0/matrix.mtx.gz -P ./data/zeisel-brain
wget https://github.com/clusterfork/random-test-files/releases/download/zeisel-brain-v1.0.0/features.tsv.gz -P ./data/zeisel-brain

mkdir -p ./data/paul-hsc
wget https://github.com/clusterfork/random-test-files/releases/download/paul-hsc-v1.0.0/matrix.mtx.gz -P ./data/paul-hsc
wget https://github.com/clusterfork/random-test-files/releases/download/paul-hsc-v1.0.0/features.tsv.gz -P ./data/paul-hsc

mkdir ./data/ernst-sperm
wget https://github.com/clusterfork/random-test-files/releases/download/ernst-sperm-v1.0.0/matrix.mtx.gz -P ./data/ernst-sperm
wget https://github.com/clusterfork/random-test-files/releases/download/ernst-sperm-v1.0.0/features.tsv.gz -P ./data/ernst-sperm

mkdir -p ./data/bacher-tcell
wget https://github.com/clusterfork/random-test-files/releases/download/bacher-tcell-v1.0.0/matrix.mtx.gz -P ./data/bacher-tcell
wget https://github.com/clusterfork/random-test-files/releases/download/bacher-tcell-v1.0.0/features.tsv.gz -P ./data/bacher-tcell

mkdir -p ./data/bach-mammary
wget https://github.com/clusterfork/random-test-files/releases/download/bach-mammary-v1/matrix.mtx.gz -P ./data/bach-mammary
wget https://github.com/clusterfork/random-test-files/releases/download/bach-mammary-v1/features.tsv.gz -P ./data/bach-mammary
