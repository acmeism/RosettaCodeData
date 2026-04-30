class PrimeGenerator {
    constructor(limit, segmentSize) {
        this.limit = limit;
        this.segmentSize = segmentSize;
        this.primes = this.sieve(limit);
        this.currentIndex = 0;
    }

    sieve(limit) {
        if (limit < 2) return [];

        const isPrime = new Array(limit + 1).fill(true);
        isPrime[0] = isPrime[1] = false;

        for (let i = 2; i * i <= limit; i++) {
            if (isPrime[i]) {
                for (let j = i * i; j <= limit; j += i) {
                    isPrime[j] = false;
                }
            }
        }

        const primes = [];
        for (let i = 2; i <= limit; i++) {
            if (isPrime[i]) primes.push(i);
        }
        return primes;
    }

    nextPrime() {
        if (this.currentIndex < this.primes.length) {
            return this.primes[this.currentIndex++];
        }
        return -1;
    }
}

function getPrimesByDigits(limit) {
    const primeGen = new PrimeGenerator(100000, 100000);
    const primesByDigits = [];
    let primes = [];
    let p = 10;

    while (p <= limit) {
        const prime = primeGen.nextPrime();
        if (prime === -1) break;

        if (prime > p) {
            primesByDigits.push([...primes]);
            primes = [];
            p *= 10;
        }
        primes.push(prime);
    }

    if (primes.length > 0) {
        primesByDigits.push(primes);
    }

    return primesByDigits;
}

function binarySearch(arr, target) {
    let left = 0;
    let right = arr.length - 1;

    while (left <= right) {
        const mid = Math.floor((left + right) / 2);
        if (arr[mid] === target) return mid;
        if (arr[mid] < target) left = mid + 1;
        else right = mid - 1;
    }

    return -left - 1;
}

function main() {
    const primesByDigits = getPrimesByDigits(100000000);
    console.log("First 100 brilliant numbers:");

    let brilliantNumbers = [];
    for (const primes of primesByDigits) {
        const n = primes.length;
        for (let i = 0; i < n; i++) {
            const prime1 = primes[i];
            for (let j = i; j < n; j++) {
                const prime2 = primes[j];
                brilliantNumbers.push(prime1 * prime2);
            }
        }
        if (brilliantNumbers.length >= 100) break;
    }

    brilliantNumbers.sort((a, b) => a - b);
    brilliantNumbers = brilliantNumbers.slice(0, 100);

    let output = "";
    for (let i = 0; i < 100; i++) {
        const c = (i + 1) % 10 === 0 ? '\n' : ' ';
        output += brilliantNumbers[i].toLocaleString().padStart(5) + c;
    }
    console.log(output);
    console.log();

    let power = 10;
    let count = 0;

    for (let p = 1; p < 2 * primesByDigits.length; p++) {
        const primes = primesByDigits[Math.floor(p / 2)];
        let position = count + 1;
        let minProduct = 0;
        const n = primes.length;

        for (let i = 0; i < n; i++) {
            const prime1 = primes[i];
            const primes2 = primes.slice(i);
            const q = Math.ceil(power / prime1);
            let j = binarySearch(primes2, q);

            if (j < 0) j = -j - 1;
            if (j >= primes2.length) continue;

            const prime2 = primes2[j];
            const product = prime1 * prime2;

            if (minProduct === 0 || product < minProduct) {
                minProduct = product;
            }

            position += j;
            if (prime1 >= prime2) break;
        }

        console.log(`First brilliant number >= 10^${p} is ${minProduct.toLocaleString()} at position ${position.toLocaleString()}`);
        power *= 10;

        if (p % 2 === 1) {
            const size = primes.length;
            count += size * (size + 1) / 2;
        }
    }
}

main();
