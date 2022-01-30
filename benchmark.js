const puppeteer = require('puppeteer');
const fs = require('fs');

// modified from https://github.com/epiviz/epiviz-chart/blob/master/performance/benchmarks.js
// const files = ["zeisel.matrix.mtx.gz"];
const files = ["bach_mammary.matrix.mtx.gz"];

async function track_metrics(file) {

    console.log("FILE: ", file);

    // headless: true to run in headless mode, otherwise this will 
    // open a browser and perform the actions. 
    // also requires shared array buffers to be enabled.
    let launchOptions = {
        headless: false,
        args: ['--start-maximized', "--enable-features=SharedArrayBuffer"]
    };

    const browser = await puppeteer.launch(launchOptions);
    const page = await browser.newPage();
    var analysisTime = "123456";

    // print all log messages; one of the logs is the analysis time
    // page.on('console', msg => { 
    //     console.log('PAGE LOG:', msg.text()) 
    // });

    // set viewport and user agent (just in case for nice viewing)
    await page.setViewport({ width: 1200, height: 800 });

    // whatever port serve says when you run
    await page.goto('http://localhost:3000');

    // App starts with the intro modal, continue to upload dataset
    await page.waitForSelector('#introSubmit');
    await page.waitForTimeout(100);
    await page.evaluate(() => document.getElementById('introSubmit').click());

    // Choose the 10x tab
    // await page.evaluate(() => document.getElementById('bp3-tab-title_undefined_tenx').click());
    // await page.waitForTimeout(100);

    // Choose the input element and upload a sample H5 file
    const mtx_input_sel = "#bp3-tab-panel_undefined_mtx > div > label:nth-child(1) > label > input[type=file]";
    const h5_input_sel = "#bp3-tab-panel_undefined_tenx > div > label > label > input[type=file]"
    const inputUploadHandle = await page.$(mtx_input_sel);
    inputUploadHandle.uploadFile(file);
    await page.waitForTimeout(100);

    // Start the analysis
    await page.evaluate(() => document.getElementById('analysisSubmit').click());

    async function waitForEvent(page, eventName, seconds) {
        return Promise.race([
            page.evaluate(eventName =>
                new Promise((resolve) => {
                    document.addEventListener(eventName, (e) => {
                        resolve(JSON.stringify(e.detail));
                    }, { once: true });
                }), eventName),

            page.waitForTimeout(seconds * 1000)
        ]);
    }

    console.log("waiting for the kana-done event...");
    let resp = await waitForEvent(page, "kana-done", 50000);
    analysisTime = JSON.parse(resp)["total_time"];
    console.log("done!!!");

    console.log("capture session metrics");
    let metrics = await page.metrics();
    metrics["CustomTotalAnalysisTime"] = analysisTime;
    // console.log(JSON.stringify(metrics));

    fs.writeFileSync(`${file}_metrics.json`, JSON.stringify(metrics));

    console.log("capture screenshot before closing the browser");
    await page.screenshot({ path: `${file}_screenshot.png` });
    console.log(`screenshot stored as ${file}_screenshot.png`);

    // close the browser
    await browser.close();
}


files.forEach(async (f) => {
    await track_metrics(f)
});