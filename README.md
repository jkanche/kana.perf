# Performance testing [KANA](http://github.com/jkanche/kana)

This repository uses puppeteer (may be switch to playwright later) to measure timing and performance metrics for Kana on [various single-cell RNA-seq datasets](https://github.com/clusterfork/random-test-files/releases). 

Since we use puppeteer to simulate user behaviour programmatically, we slightly modified the behavior of Kana application -

- Measure analysis run time: Puppeteer provides a way to measure the total run time since the launch of the app in the browser (headless). To accurately measure only analysis time, we added custom logic from the time files are imported into the app until their reduced dimensions are calculated (t-SNE & UMAP).

- When to stop the session: we don't programmatically know how long puppeteer should track metrics & end the session. So we fire a custom event: `kana-done` after t-SNE & UMAP coordinates are received by KANA.

    reference to wait for custom events: https://github.com/puppeteer/puppeteer/issues/2455

These changes are made in the [perf branch](https://github.com/jkanche/kana/tree/perf/src) of Kana.

# Run the benchmarks

1. Clone the repo and install the dependencies

```
git clone http://github.com/jkanche/kana.perf
npm install
```

2. Install dependencies and run the kana app

```
bash serve.sh
```

3. run the benchmark script (in a different terminal)

```
node benchmark.js
```

***Note: Modify the list of datasets needed to run in benchmark.js***

For every dataset, the session generates two files, 

- the metrics tracked by puppeteer and the custom analysis total time tracked in the app
- a screenshot before ending the session

Have fun analyzing!!