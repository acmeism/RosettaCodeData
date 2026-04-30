class SegmentedPrimeIterator {
    constructor(limit) {
        this.squareRoot = Math.floor(Math.sqrt(limit));
        this.low = 0;
        this.high = this.squareRoot;
        this.index = 0;
        this.primes = [];
        this.smallPrimes = [];
        this.smallSieve(this.squareRoot);
    }

    next() {
        if (this.index === this.primes.length) {
            this.index = 0;
            this.segmentedSieve();
        }
        return this.primes[this.index++];
    }

    segmentedSieve() {
        this.low += this.squareRoot;
        this.high += this.squareRoot;

        const markedPrime = new Array(this.squareRoot).fill(true);

        for (let i = 0; i < this.smallPrimes.length; i++) {
            let lowLimit = Math.floor(this.low / this.smallPrimes[i]) * this.smallPrimes[i];
            if (lowLimit < this.low) {
                lowLimit += this.smallPrimes[i];
            }

            for (let j = lowLimit; j < this.high; j += this.smallPrimes[i]) {
                markedPrime[j - this.low] = false;
            }
        }

        this.primes = [];
        for (let i = this.low; i < this.high; i++) {
            if (markedPrime[i - this.low]) {
                this.primes.push(i);
            }
        }
    }

    smallSieve(squareRoot) {
        const markedPrime = new Array(squareRoot + 1).fill(true);

        for (let p = 2; p * p <= squareRoot; p++) {
            if (markedPrime[p]) {
                for (let i = p * p; i <= squareRoot; i += p) {
                    markedPrime[i] = false;
                }
            }
        }

        for (let p = 2; p <= squareRoot; p++) {
            if (markedPrime[p]) {
                this.primes.push(p);
            }
        }
        this.smallPrimes = [...this.primes];
    }
}

class SisyphusIterator {
    constructor(limit) {
        this.previous = 2;
        this.prime = 0;
        this.primeIterator = new SegmentedPrimeIterator(limit);
    }

    next() {
        if ((this.previous & 1) === 0) {
            this.previous >>= 1;
        } else {
            this.prime = this.primeIterator.next();
            this.previous += this.prime;
        }
        return this.previous;
    }

    getPrime() {
        return this.prime;
    }
}

function display(found, search, target, prefix, suffix) {
    console.log();
    console.log(prefix + target + " terms:");
    const results = [];
    for (let i = 1; i < found.length; i++) {
        if (found[i] === search) {
            results.push(i);
        }
    }
    console.log(results.join("  ") + (suffix ? "  " + suffix : ""));
}

function main() {
    const limit = 100_000_000;
    const iterator = new SisyphusIterator(1_000_000_000_000);

    console.log("The first 100 members of the Sisyphus sequence are:");
    const found = new Array(250).fill(0);
    let next = 0;
    let count = 0;
    let target = 1_000;

    while (target <= limit) {
        count += 1;
        next = iterator.next();

        if (next < 250) {
            found[next]++;
        }

        if (count <= 100) {
            process.stdout.write(next.toString().padStart(3) + (count % 10 === 0 ? "\n" : " "));
            if (count === 100) {
                console.log();
            }
        } else if (count === target) {
            target *= 10;
            console.log(`${target.toString().padStart(11)}th member is ${next.toString().padStart(11)} and highest prime needed is ${iterator.getPrime().toString().padStart(10)}`);
        }
    }

    display(found, 0, target, "These numbers under 250 occur the most in the first ", "");

    const max = Math.max(...found);
    display(found, max, target,
        "These numbers under 250 occur the most in the first ",
        "all occur " + max + " times");

    while (next !== 36) {
        count += 1;
        next = iterator.next();
    }

    console.log();
    console.log(count + "th member is " + next + " and highest prime needed is " + iterator.getPrime());
}

main();
