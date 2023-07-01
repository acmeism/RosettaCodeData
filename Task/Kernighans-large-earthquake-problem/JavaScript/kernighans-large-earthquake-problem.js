const fs = require("fs");
const readline = require("readline");

const args = process.argv.slice(2);
if (!args.length) {
    console.error("must supply file name");
    process.exit(1);
}

const fname = args[0];

const readInterface = readline.createInterface({
    input: fs.createReadStream(fname),
    console: false,
});

readInterface.on("line", (line) => {
    const fields = line.split(/\s+/);
    if (+fields[fields.length - 1] > 6) {
        console.log(line);
    }
});
