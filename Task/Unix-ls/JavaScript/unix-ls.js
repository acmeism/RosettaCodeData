const fs = require('fs');
fs.readdir('.', (err, names) => names.sort().map( name => console.log(name) ));
