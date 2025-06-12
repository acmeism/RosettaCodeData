const readline = require("readline");

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

function askQuestion(query) {
    return new Promise(resolve => rl.question(query, resolve));
}

async function main() {
    while (true) {
        const input = await askQuestion("Type something: ");
        // do whatever you want with the input string
        // remember to break the loop if you need
    }
    rl.close();
}

main();
