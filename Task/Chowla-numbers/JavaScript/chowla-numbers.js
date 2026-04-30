// Chowla function: calculates sum of proper divisors of n (excluding n itself)
function chowla(n) {
    let sum = 0;
    for (let i = 2; i * i <= n; i++) {
        if (n % i === 0) {
            const j = n / i;
            sum += i + (i === j ? 0 : j);
        }
    }
    return sum;
}

// Sieve function: returns array where true denotes composite, false denotes prime
// Only interested in odd numbers >= 3
function sieve(limit) {
    // True denotes composite, false denotes prime
    const c = new Array(limit).fill(false);

    for (let i = 3; i * 3 < limit; i += 2) {
        if (!c[i] && chowla(i) === 0) {
            for (let j = 3 * i; j < limit; j += 2 * i) {
                c[j] = true;
            }
        }
    }
    return c;
}

// Main execution
function main() {
    // Part 1: Print chowla values for 1-37
    console.log("Chowla function values for 1-37:");
    for (let i = 1; i <= 37; i++) {
        console.log(`chowla(${i}) = ${chowla(i)}`);
    }
    console.log("\n");

    // Part 2: Count primes up to powers of 10
    console.log("Prime counting using Chowla's sieve:");
    let count = 1;
    const limit = 10000000; // 1e7
    let power = 100;

    const c = sieve(limit);

    for (let i = 3; i < limit; i += 2) {
        if (!c[i]) count++;

        if (i === power - 1) {
            console.log(`Count of primes up to ${power.toLocaleString()} = ${count.toLocaleString()}`);
            power *= 10;
        }
    }
    console.log("\n");

    // Part 3: Find perfect numbers
    console.log("Perfect numbers <= 35,000,000:");
    count = 0;
    const perfectLimit = 35000000;

    let k = 2, kk = 3, p;
    for (let i = 2; ; i++) {
        p = k * kk;
        if (p > perfectLimit) break;

        if (chowla(p) === p - 1) {
            console.log(`${p.toLocaleString()} is a perfect number`);
            count++;
        }

        k = kk + 1;
        kk += k;
    }

    console.log(`\nThere are ${count} perfect numbers <= 35,000,000`);
}

// Execute the main function
main();
