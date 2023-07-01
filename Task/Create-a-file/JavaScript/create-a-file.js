const fs = require('fs');

function fct(err) {
  if (err) console.log(err);
}

fs.writeFile("output.txt", "", fct);
fs.writeFile("/output.txt", "", fct);

fs.mkdir("docs", fct);
fs.mkdir("/docs", fct);
