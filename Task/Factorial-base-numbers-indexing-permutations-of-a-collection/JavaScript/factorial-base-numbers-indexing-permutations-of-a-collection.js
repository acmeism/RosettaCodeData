// Helper function to convert values to strings
function stringify(text) {
    return text;
}

function stringifyNumber(number) {
    return String(number);
}

// Join array elements with delimiter
function toStringArray(factoradic, delimiter) {
    let result = "";
    for (let i = 0; i < factoradic.length - 1; i++) {
        result += stringifyNumber(factoradic[i]) + delimiter;
    }
    result += stringifyNumber(factoradic[factoradic.length - 1]);
    return result;
}

// Calculate factorial
function factorial(n) {
    let result = 1;
    for (let i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

// Increment factoradic number
function increment(factoradic) {
    let index = factoradic.length - 1;
    while (index >= 0 && factoradic[index] === factoradic.length - index) {
        factoradic[index] = 0;
        index -= 1;
    }
    if (index >= 0) {
        factoradic[index] += 1;
    }
}

// Split string by delimiter
function splitString(text, delimiter) {
    const lines = [];
    let start = 0;
    let end = text.indexOf(delimiter);

    while (end !== -1) {
        const line = text.substring(start, end);
        if (line !== "") {
            lines.push(line);
        }
        start = end + 1;
        end = text.indexOf(delimiter, start);
    }

    const lastLine = text.substring(start);
    if (lastLine !== "") {
        lines.push(lastLine);
    }

    return lines;
}

// Convert "a.b.c" format to array of integers
function convertToVectorOfInteger(text) {
    const result = [];
    const numbers = splitString(text, '.');
    for (const number of numbers) {
        result.push(parseInt(number, 10));
    }
    return result;
}

// Generate permutation from elements and factoradic representation
function permutation(elements, factoradic) {
    const result = [...elements];
    let m = 0;

    for (const g of factoradic) {
        const element = result[m + g];
        result.splice(m + g, 1);
        result.splice(m, 0, element);
        m += 1;
    }

    return result;
}

// Main execution
function main() {
    // Part 1
    console.log("Part 1: Permutations of 4 elements");
    console.log("=".repeat(50));

    let elements = convertToVectorOfInteger("0.1.2.3");
    let factoradic = convertToVectorOfInteger("0.0.0");

    for (let i = 0; i < factorial(4); i++) {
        const rotated = permutation(elements, factoradic);
        console.log(toStringArray(factoradic, '.') + " --> " + rotated.join(' '));
        increment(factoradic);
    }
    console.log();

    // Part 2
    console.log("Part 2: Permutations of 11 digits");
    console.log("=".repeat(50));

    const limit = factorial(11);
    elements = convertToVectorOfInteger("0.1.2.3.4.5.6.7.8.9.10");
    factoradic = convertToVectorOfInteger("0.0.0.0.0.0.0.0.0.0");

    for (let i = 0; i < limit; i++) {
        const rotated = permutation(elements, factoradic);
        if (i < 3 || i > limit - 4) {
            console.log(toStringArray(factoradic, '.') + " --> " + rotated.join(' '));
        } else if (i === 3) {
            console.log(" [ ... ] ");
        }
        increment(factoradic);
    }
    console.log("Number of permutations is 11! = " + limit);
    console.log();

    // Part 3
    console.log("Part 3: Card shuffling with factoradic representation");
    console.log("=".repeat(50));

    const codes = [
        "39.49.7.47.29.30.2.12.10.3.29.37.33.17.12.31.29.34.17.25.2.4.25.4.1.14.20.6.21.18.1.1.1.4.0.5.15.12.4.3.10.10.9.1.6.5.5.3.0.0.0",
        "51.48.16.22.3.0.19.34.29.1.36.30.12.32.12.29.30.26.14.21.8.12.1.3.10.4.7.17.6.21.8.12.15.15.13.15.7.3.12.11.9.5.5.6.6.3.4.0.3.2.1"
    ];

    const suits = ['♠', '♥', '♦', '♣'];
    const ranks = ['A', 'K', 'Q', 'J', '10', '9', '8', '7', '6', '5', '4', '3', '2'];

    const cards = [];
    for (const suit of suits) {
        for (const rank of ranks) {
            cards.push(rank + suit);
        }
    }

    console.log("Original deck of cards:");
    console.log(cards.join(' '));
    console.log();

    console.log("Task shuffles:");
    for (const code of codes) {
        console.log(code + " --> ");
        factoradic = convertToVectorOfInteger(code);
        const shuffled = permutation(cards, factoradic);
        console.log(shuffled.join(' '));
        console.log();
    }

    console.log("Random shuffle:");
    factoradic = [];
    for (let i = 0; i < cards.length - 1; i++) {
        const randomIndex = Math.floor(Math.random() * (cards.length - i));
        factoradic.push(randomIndex);
    }

    console.log(toStringArray(factoradic, '.') + " --> ");
    const randomShuffled = permutation(cards, factoradic);
    console.log(randomShuffled.join(' '));
}

// Run the program
main();
