var fs = require('fs');
require('util').pump(fs.createReadStream('input.txt', {flags:'r'}), fs.createWriteStream('output.txt', {flags:'w+'}));
