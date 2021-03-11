const puppeteer = require('puppeteer');

(async () => {
    console.log("Launching browser...");
    const browser = await puppeteer.launch({
        headless: true,
        args: ['--no-sandbox'],
        ignoreDefaultArgs: ['--disable-extensions'],
    });
    
    console.log("Openning URL...");
    const page = await browser.newPage();
    await page.goto('https://example.com');
    
    console.log("Printing page info...");
    console.log(await page.cookies());

    await browser.close();
})();