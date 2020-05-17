#!/usr/bin/env /usr/local/bin/node
import { request } from 'https';

const opts = {
  hostname: "api.kraken.com",
  path: "/0/public/Ticker?pair=XBTUSD,XBTEUR,XBTGBP,XLMXBT,XLMUSD",
  method: "GET",
  headers: {
    "User-Agent": "Node.js/14.1.0"
  }
}

const req = request(opts, (res) => {
  let json = "";
  
  res.setEncoding('utf8');

  res.on('data', (chunk) => {
    json += chunk;
  });
  
  res.on('end', () => {
    const d = JSON.parse(json);
    const res = d.result;

    // console.log(typeof res.XXBTZUSD.c[0])
    
    console.log(`\u20bf-$: ${res.XXBTZUSD.c[0].slice(0, -3)}`);
    console.log(`---`);
    console.log(`\u20bf-€: ${res.XXBTZEUR.c[0].slice(0, -3)}`);
    console.log(`\u20bf-£: ${res.XXBTZGBP.c[0].slice(0, -3)}`);
    console.log(`XLM-\u20bf: ${res.XXLMXXBT.c[0]}`);
    console.log(`XLM-$: ${res.XXLMZUSD.c[0].slice(0, -3)}`);
  })
  
})

req.on('error', (e) => {
  console.error(e)
});


req.end();
