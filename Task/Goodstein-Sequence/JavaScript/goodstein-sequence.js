// Goodstein Sequence implementation in JavaScript

function main() {
    console.log("The Goodstein(n) sequence, up to the first 10 terms, for values of n from 0 to 7:");
    for (let i = 0; i <= 7; i++) {
        console.log(`Goodstein of ${i}: ${goodstein(i, 10).join(', ')}`);
    }

    console.log("\nThe nth term, zero based, of Goodstein(n), for values of n from 0 to 16:");
    for (let i = 0; i <= 16; i++) {
        const sequence = goodstein(i, i + 1);
        console.log(`Term ${i.toString().padStart(2)} of Goodstein(${i.toString().padStart(2)}): ${sequence[i]}`);
    }
}

function goodstein(number, maxTerms) {
    let current = BigInt(number);
    const result = [current];
    let term = 1;

    while (term < maxTerms && current > 0n) {
        current = bump(current, term + 1) - 1n;
        result.push(current);
        term += 1;
    }

    return result;
}

function bump(number, base) {
    const bigBase = BigInt(base);
    let result = 0n;
    let i = 0;

    while (number > 0n) {
        const remainder = number % bigBase;
        number = number / bigBase;

        if (remainder > 0n) {
            const exponent = Number(bump(BigInt(i), base));
            result = result + remainder * (bigBase + 1n) ** BigInt(exponent);
        }
        i += 1;
    }

    return result;
}

// Run the main function
main();
