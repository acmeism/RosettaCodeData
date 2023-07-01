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

let sep = "";
readInterface.on("line", (line) => {
    if (line.startsWith(">")) {
        process.stdout.write(sep);
        sep = "\n";
        process.stdout.write(line.substring(1) + ": ");
    } else {
        process.stdout.write(line);
    }
});

readInterface.on("close", () => process.stdout.write("\n"));
