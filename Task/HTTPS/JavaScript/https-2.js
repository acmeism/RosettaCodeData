const https = require('https');

https.get("https://sourceforge.net", (resp) => {
  let content = '';

  // A chunk of data has been recieved.
  resp.on('data', (chunk) => {
    content += chunk;
  });

  // The whole response has been received. Print out the result.
  resp.on('end', () => {
    console.log(content);
  });

}).on("error", (err) => {
  console.error("Error: " + err.message);
});
