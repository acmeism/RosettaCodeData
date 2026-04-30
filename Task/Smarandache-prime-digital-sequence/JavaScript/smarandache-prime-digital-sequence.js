function getSmarandachePrime(n) {
    if (n < 10) {
        switch (n) {
            case 1: return 2;
            case 2: return 3;
            case 3: return 5;
            case 4: return 7;
        }
    }
    let s = getNextSmarandache(7);
    let result = 0;
    for (let count = 1; count <= n - 4; s = getNextSmarandache(s)) {
        if (isPrime(s)) {
            count++;
            result = s;
        }
    }
    return result;
}

function isPrime(test) {
    if (test % 2 === 0) return false;
    for (let i = 3; i <= Math.sqrt(test); i += 2) {
        if (test % i === 0) {
            return false;
        }
    }
    return true;
}

function getNextSmarandache(n) {
    // If 3, next is 7
    if (n % 10 === 3) {
        return n + 4;
    }
    let retVal = n - 4;

    // Last digit 7. k = largest position from right where we have a 7.
    let k = 0;
    while (n % 10 === 7) {
        k++;
        n = Math.floor(n / 10);
    }

    // Determine first digit from right where digit != 7.
    const digit = n % 10;

    // Digit is 2, 3, or 5. 3-2 = 1, 5-3 = 2, 7-5 = 2, so digit = 2, coefficient = 1, otherwise 2.
    const coeff = (digit === 2 ? 1 : 2);

    // Compute next value
    retVal += coeff * Math.pow(10, k);

    // Subtract values for digit = 7.
    while (k > 1) {
        retVal -= 5 * Math.pow(10, k - 1);
        k--;
    }

    // Even works for 777..777 --> 2222...223
    return retVal;
}

// Main execution
let s = getNextSmarandache(7);
console.log("First 25 Smarandache prime-digital sequence numbers:");
process.stdout.write("2 3 5 7 ");
for (let count = 1; count <= 21; s = getNextSmarandache(s)) {
    if (isPrime(s)) {
        process.stdout.write(`${s} `);
        count++;
    }
}
console.log("\n");

for (let i = 2; i <= 5; i++) {
    const n = Math.pow(10, i);
    console.log(`${n.toLocaleString()}th Smarandache prime-digital sequence number = ${getSmarandachePrime(n)}`);
}
