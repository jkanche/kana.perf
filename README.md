# Performance metrics for [kana](http://github.com/jkanche/kana) & [scran-cli](http://github.com/ltla/scran-cli)

This repository measures timing and performance metrics for `kana` & `scran-cli` on [various single-cell RNA-seq datasets](https://github.com/clusterfork/random-test-files/releases). 

To download the datasets

```
bash setup-data.sh
```

The repo assumes you have node, cmake and relevant dependencies.

## `Kana`

We use puppeteer (may switch to playwright later) to simulate user behaviour programmatically, we slightly modified the behavior of Kana application -

- Measure analysis run time: Puppeteer provides a way to measure the total run time since the launch of the app in the browser (headless). To accurately measure only analysis time, we added custom logic from the time files are imported into the app until their reduced dimensions are calculated (t-SNE & UMAP).

- When to stop the session: we don't programmatically know how long puppeteer should track metrics & end the session. So we fire a custom event: `kana-done` after t-SNE & UMAP coordinates are received by Kana.

    reference to wait for custom events: https://github.com/puppeteer/puppeteer/issues/2455

These changes are made in the [perf branch](https://github.com/jkanche/kana/tree/perf/src) of Kana.

### Run the benchmarks

1. Clone the repo and install the dependencies

```
git clone http://github.com/jkanche/kana.perf
npm install
```

2. Install dependencies and run the kana app

```
bash serve-app.sh
```

3. run the benchmark script (in a different terminal)

```
node benchmark-app.js
```

***Note: Modify the list of datasets needed to run in benchmark.js***

For every dataset, the session generates two files, 

- the metrics tracked by puppeteer and the custom analysis total time tracked in the app
- a screenshot before ending the session

## `scran-cli`

This downloads and sets up the `scran-cli` package and its dependencies.

### Run the benchmarks

```
bash setup-cli.sh
```

```
bash benchmark-cli.sh
```


***Note: Modify the list of datasets needed to run in benchmark.js***

For every dataset, the session generates two files, 

- the metrics tracked by puppeteer and the custom analysis total time tracked in the app
- a screenshot before ending the session

Have fun analyzing!!