const http = require('http');

http.get('http://rosettacode.org', (resp) => {

  let data = '';

  // A chunk of data has been recieved.
  resp.on('data', (chunk) => {
    data += chunk;
  });

  // The whole response has been received. Print out the result.
  resp.on('end', () => {
    console.log("Data:", data);
  });

}).on("error", (err) => {
  console.log("Error: " + err.message);
});
