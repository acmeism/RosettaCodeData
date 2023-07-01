var fs = require("fs");

var readFile = function(path) {
    return fs.readFileSync(path).toString();
};

console.log(readFile('file.txt'));
