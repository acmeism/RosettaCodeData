const MAX = 1400000;
const primes = new Array(MAX);

function preCompute() {
    // Initialize sieve
    for (let i = 2; i < MAX; i++) {
        primes[i] = true;
    }

    // Sieve of Eratosthenes
    for (let i = 2; i < MAX; i++) {
        if (primes[i]) {
            for (let j = 2 * i; j < MAX; j += i) {
                primes[j] = false;
            }
        }
    }
}

function isPrime(n) {
    if (n < MAX) {
        return primes[n];
    }
    const max = Math.floor(Math.sqrt(n));
    for (let i = 3; i <= max; i++) {
        if (primes[i] && n % i === 0) {
            return false;
        }
    }
    return true;
}

function cubanPrime(n, display) {
    let count = 0;
    let result = 0;
    let output = '';

    for (let i = 0; count < n; i++) {
        const test = 1 + 3 * i * (i + 1);
        if (isPrime(test)) {
            count++;
            result = test;
            if (display) {
                const formatted = test.toLocaleString('en-US').padStart(10);
                output += formatted + (count % 10 === 0 ? '\n' : '');
            }
        }
    }

    if (display) {
        console.log(output);
    }
    return result;
}

// Main execution
preCompute();

// First 200 Cuban primes
cubanPrime(200, true);
console.log();

// Specific Cuban primes
for (let i = 1; i <= 5; i++) {
    const max = Math.pow(10, i);
    const prime = cubanPrime(max, false);
    console.log(`${max.toLocaleString('en-US')}-th cuban prime = ${prime.toLocaleString('en-US')}`);
}
