// This example runs on Node.js
var fs = require('fs');
// Assuming lp is at /dev/lp0
var lp = fs.openSync('/dev/lp0', 'w');
fs.writeSync(lp, 'Hello, world!\n');
fs.close(lp);
