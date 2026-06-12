let primes = [];
let fibonacciCache = new Map();
let factorialCache = new Map();

function sievePrimes(limit) {
    primes.push(2);
    const halfLimit = Math.floor((limit + 1) / 2);
    let composite = new Array(halfLimit).fill(false);

    for (let i = 1, p = 3; i < halfLimit; p += 2, ++i) {
        if (!composite[i]) {
            primes.push(p);
            for (let a = i + p; a < halfLimit; a += p) {
                composite[a] = true;
            }
        }
    }
}

function oneOne(number) {
    return (number === 0) ? 1 : 0;
}

function allOnes(number) {
    return 1;
}

function alternating(number) {
    return (number % 2 === 0) ? +1 : -1;
}

function prime(number) {
    return primes[number];
}

function fibonacci(number) {
    if (!fibonacciCache.has(number)) {
        if (number === 0 || number === 1) {
            fibonacciCache.set(number, 1);
        } else {
            fibonacciCache.set(number, fibonacci(number - 2) + fibonacci(number - 1));
        }
    }
    return fibonacciCache.get(number);
}

function factorial(number) {
    if (!factorialCache.has(number)) {
        let value = 1;
        for (let i = 2; i <= number; ++i) {
            value *= i;
        }
        factorialCache.set(number, value);
    }
    return factorialCache.get(number);
}

class BoustrophedonIterator {
    constructor(sequence) {
        this.sequence = sequence;
        this.index = -1;
        this.cache = new Map();
    }

    next() {
        this.index += 1;
        return this.transform(this.index, this.index);
    }

    transform(k, n) {
        if (n === 0) {
            return this.sequence(k);
        }

        if (!this.cache.has(k)) {
            this.cache.set(k, new Map());
        }

        const kCache = this.cache.get(k);

        if (!kCache.has(n)) {
            const value = this.transform(k, n - 1) + this.transform(k - 1, k - n);
            kCache.set(n, value);
        }

        return kCache.get(n);
    }
}

function display(title, sequence) {
    console.log(title);
    const iterator = new BoustrophedonIterator(sequence);
    const results = [];

    for (let i = 1; i <= 15; ++i) {
        results.push(iterator.next());
    }

    console.log(results.join(' '));
    console.log();
}

function main() {
    sievePrimes(8000);

    display("One followed by an infinite series of zeros -> A000111", oneOne);
    display("An infinite series of ones -> A000667", allOnes);
    display("(-1)^n: alternating 1, -1, 1, -1 -> A062162", alternating);
    display("Sequence of prime numbers -> A000747", prime);
    display("Sequence of Fibonacci numbers -> A000744", fibonacci);
    display("Sequence of factorial numbers -> A230960", factorial);
}

main();
