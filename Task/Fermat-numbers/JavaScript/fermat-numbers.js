// Fermat Numbers Calculator and Factorizer

const TWO = 2n;

// Calculate Fermat number F[n] = 2^(2^n) + 1
function fermat(n) {
    return TWO ** (2n ** BigInt(n)) + 1n;
}

// Pollard's Rho algorithm helper function
function pollardRhoG(x, n) {
    return (x * x + 1n) % n;
}

// Fast variant of Pollard's Rho algorithm
// Performs 100 multiplications before computing GCD
function pollardRhoFast(n) {
    const start = Date.now();
    let x = 2n;
    let y = 2n;
    let d = 1n;
    let count = 0;
    let z = 1n;

    while (true) {
        x = pollardRhoG(x, n);
        y = pollardRhoG(pollardRhoG(y, n), n);
        d = (x - y > 0n ? x - y : y - x);
        z = (z * d) % n;
        count++;

        if (count === 100) {
            d = gcd(z, n);
            if (d !== 1n) {
                break;
            }
            z = 1n;
            count = 0;
        }
    }

    const end = Date.now();
    console.log(`    Pollard rho try factor ${n} elapsed time = ${end - start} ms (factor = ${d}).`);

    if (d === n) {
        return 0n;
    }
    return d;
}

// Calculate GCD using Euclidean algorithm
function gcd(a, b) {
    a = a > 0n ? a : -a;
    b = b > 0n ? b : -b;
    while (b !== 0n) {
        const temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Miller-Rabin primality test
function isProbablePrime(n, iterations = 100) {
    if (n < 2n) return false;
    if (n === 2n || n === 3n) return true;
    if (n % 2n === 0n) return false;

    // Write n-1 as 2^r * d
    let d = n - 1n;
    let r = 0n;
    while (d % 2n === 0n) {
        d /= 2n;
        r++;
    }

    // Witness loop
    const witnesses = [2n, 3n, 5n, 7n, 11n, 13n, 17n, 19n, 23n, 29n];
    for (let i = 0; i < Math.min(iterations, witnesses.length); i++) {
        const a = witnesses[i];
        if (a >= n) continue;

        let x = modPow(a, d, n);
        if (x === 1n || x === n - 1n) continue;

        let continueWitnessLoop = false;
        for (let j = 0n; j < r - 1n; j++) {
            x = (x * x) % n;
            if (x === n - 1n) {
                continueWitnessLoop = true;
                break;
            }
        }
        if (!continueWitnessLoop) return false;
    }
    return true;
}

// Modular exponentiation
function modPow(base, exp, mod) {
    let result = 1n;
    base = base % mod;
    while (exp > 0n) {
        if (exp % 2n === 1n) {
            result = (result * base) % mod;
        }
        exp = exp / 2n;
        base = (base * base) % mod;
    }
    return result;
}

// Known composite prefixes for large Fermat numbers
const COMPOSITE = {
    9: "5529",
    10: "6078",
    11: "1037",
    12: "5488",
    13: "2884"
};

// Factor a Fermat number
function getFactors(fermatIndex, n) {
    const factors = [];

    while (true) {
        if (isProbablePrime(n)) {
            factors.push(n);
            break;
        } else {
            if (COMPOSITE[fermatIndex]) {
                const stop = COMPOSITE[fermatIndex];
                if (n.toString().startsWith(stop)) {
                    factors.push(-BigInt(n.toString().length));
                    break;
                }
            }
            const factor = pollardRhoFast(n);
            if (factor === 0n) {
                factors.push(n);
                break;
            } else {
                factors.push(factor);
                n = n / factor;
            }
        }
    }

    return factors;
}

// Format factors as a string
function getString(factors) {
    if (factors.length === 1) {
        return `${factors[0]} (PRIME)`;
    }
    return factors.map(v => {
        const s = v.toString();
        return s.startsWith('-') ? `(C${s.substring(1)})` : s;
    }).join(' * ');
}

// Main execution
console.log("First 10 Fermat numbers:");
for (let i = 0; i < 10; i++) {
    console.log(`F[${i}] = ${fermat(i)}`);
}

console.log("\nFirst 12 Fermat numbers factored:");
for (let i = 0; i < 13; i++) {
    console.log(`F[${i}] = ${getString(getFactors(i, fermat(i)))}`);
}
