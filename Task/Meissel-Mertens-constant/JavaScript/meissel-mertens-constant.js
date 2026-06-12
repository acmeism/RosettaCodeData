function main() {
    // Use a smaller limit to avoid memory issues
    // For demonstration, using 10 million instead of 1 billion
    const limit = 10_000_000;
    const primeReciprocals = listPrimeReciprocals(limit);
    const euler = 0.577215664901532861;
    let sum = 0.0;

    for (const reciprocal of primeReciprocals) {
        sum += reciprocal + Math.log(1.0 - reciprocal);
    }

    const meisselMertens = euler + sum;
    console.log(`The Meissel-Mertens constant = ${meisselMertens.toFixed(9)}`);
    console.log(`Calculated with primes up to: ${limit.toLocaleString()}`);
}

function listPrimeReciprocals(limit) {
    const segmentSize = Math.min(1_000_000, limit); // Process in 1M chunks
    const result = [];

    // First, find all primes up to sqrt(limit) for marking composites
    const sqrtLimit = Math.floor(Math.sqrt(limit));
    const basePrimes = sieveOfEratosthenes(sqrtLimit);

    // Process the range in segments
    for (let segStart = 2; segStart <= limit; segStart += segmentSize) {
        const segEnd = Math.min(segStart + segmentSize - 1, limit);
        const segmentPrimes = segmentedSieve(segStart, segEnd, basePrimes);

        // Add reciprocals of primes found in this segment
        for (const prime of segmentPrimes) {
            result.push(1.0 / prime);
        }
    }

    return result;
}

function sieveOfEratosthenes(limit) {
    const sieve = new Array(limit + 1).fill(true);
    sieve[0] = sieve[1] = false;

    for (let i = 2; i * i <= limit; i++) {
        if (sieve[i]) {
            for (let j = i * i; j <= limit; j += i) {
                sieve[j] = false;
            }
        }
    }

    const primes = [];
    for (let i = 2; i <= limit; i++) {
        if (sieve[i]) {
            primes.push(i);
        }
    }

    return primes;
}

function segmentedSieve(segStart, segEnd, basePrimes) {
    const segmentSize = segEnd - segStart + 1;
    const sieve = new Array(segmentSize).fill(true);

    // Mark multiples of each base prime in this segment
    for (const prime of basePrimes) {
        // Find the first multiple of prime >= segStart
        let start = Math.max(prime * prime, Math.ceil(segStart / prime) * prime);

        // Mark all multiples in this segment
        for (let j = start; j <= segEnd; j += prime) {
            sieve[j - segStart] = false;
        }
    }

    // Collect primes from this segment
    const primes = [];
    for (let i = 0; i < segmentSize; i++) {
        if (sieve[i] && (segStart + i) >= 2) {
            primes.push(segStart + i);
        }
    }

    return primes;
}

// Alternative version with even more memory efficiency
function mainMemoryEfficient() {
    const limit = 100_000_000; // Can handle larger limits
    const euler = 0.577215664901532861;
    let sum = 0.0;
    let primeCount = 0;

    // Process primes incrementally without storing them all
    processPrimesInSegments(limit, (prime) => {
        const reciprocal = 1.0 / prime;
        sum += reciprocal + Math.log(1.0 - reciprocal);
        primeCount++;

        // Progress indicator for large calculations
        if (primeCount % 100000 === 0) {
            console.log(`Processed ${primeCount.toLocaleString()} primes...`);
        }
    });

    const meisselMertens = euler + sum;
    console.log(`The Meissel-Mertens constant = ${meisselMertens.toFixed(9)}`);
    console.log(`Calculated with ${primeCount.toLocaleString()} primes up to: ${limit.toLocaleString()}`);
}

function processPrimesInSegments(limit, callback) {
    const segmentSize = 1_000_000;
    const sqrtLimit = Math.floor(Math.sqrt(limit));
    const basePrimes = sieveOfEratosthenes(sqrtLimit);

    // Process first segment (includes base primes)
    for (const prime of basePrimes) {
        callback(prime);
    }

    // Process remaining segments
    for (let segStart = sqrtLimit + 1; segStart <= limit; segStart += segmentSize) {
        const segEnd = Math.min(segStart + segmentSize - 1, limit);
        const segmentPrimes = segmentedSieve(segStart, segEnd, basePrimes);

        for (const prime of segmentPrimes) {
            callback(prime);
        }
    }
}

// Run the memory-efficient version
console.log("Running memory-efficient version...");
mainMemoryEfficient();
