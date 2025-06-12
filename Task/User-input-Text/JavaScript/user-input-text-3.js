const readline = require("readline");

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.question("Enter a string: ", (str) => {
    console.log(str);
    rl.close();
});

rl.question("Enter a number: ", (n) => {
    console.log(parseInt(n));
    rl.close();
});
