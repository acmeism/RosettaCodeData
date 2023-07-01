// Node.js v14.15.4
const { readdirSync } = require("fs");
const emptydir = (path) => readdirSync(path).length == 0;

// tests, run like node emptydir.js [directories]
for (let i = 2; i < process.argv.length; i ++) {
  let dir = process.argv[i];
  console.log(`${dir}: ${emptydir(dir) ? "" : "not "}empty`)
}
