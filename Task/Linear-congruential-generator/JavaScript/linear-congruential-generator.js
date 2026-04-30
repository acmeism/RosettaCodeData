const mask = (1 << 31) - 1;

function* randBSD(seed) {
    let s = seed;
    while (true) {
        s = (s * 1103515245 + 12345) & mask;
        yield s;
    }
}

function* randMS(seed) {
    let s = seed;
    while (true) {
        s = (s * 214013 + 2531011) & mask;
        yield s >> 16;
    }
}

function take(generator, n) {
    const result = [];
    let count = 0;
    for (const value of generator) {
        if (count >= n) break;
        result.push(value);
        count++;
    }
    return result;
}

// Main execution
console.log("BSD:");
const bsdNumbers = take(randBSD(0), 10);
for (const num of bsdNumbers) {
    console.log(num);
}

console.log("\nMS:");
const msNumbers = take(randMS(0), 10);
for (const num of msNumbers) {
    console.log(num);
}
