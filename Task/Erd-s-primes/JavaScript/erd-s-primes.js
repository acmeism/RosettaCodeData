class ErdosPrimeGenerator {
    constructor() {
        this.primes = new Set();
        this.currentNumber = 2;
    }

    next() {
        let prime;
        while (true) {
            prime = this.nextPrime();
            this.primes.add(prime);
            if (this.isErdos(prime)) {
                break;
            }
        }
        return prime;
    }

    nextPrime() {
        while (true) {
            if (this.isPrime(this.currentNumber)) {
                const prime = this.currentNumber;
                this.currentNumber++;
                return prime;
            }
            this.currentNumber++;
        }
    }

    isPrime(n) {
        if (n < 2) return false;
        if (n === 2) return true;
        if (n % 2 === 0) return false;

        const sqrt = Math.sqrt(n);
        for (let i = 3; i <= sqrt; i += 2) {
            if (n % i === 0) return false;
        }
        return true;
    }

    isErdos(p) {
        let factorial = 1;
        for (let k = 1; factorial < p; k++) {
            factorial *= k;
            if (this.primes.has(p - factorial)) {
                return false;
            }
        }
        return true;
    }
}

function main() {
    const epgen = new ErdosPrimeGenerator();
    const maxPrint = 2500;
    const maxCount = 7875;
    let p;
    let output = `Erdős primes less than ${maxPrint}:\n`;

    const printedPrimes = [];
    for (let count = 1; count <= maxCount; count++) {
        p = epgen.next();
        if (p < maxPrint) {
            printedPrimes.push(p.toString().padStart(6, ' '));
            if (count % 10 === 0) {
                output += printedPrimes.join(' ') + '\n';
                printedPrimes.length = 0;
            }
        }
    }

    if (printedPrimes.length > 0) {
        output += printedPrimes.join(' ') + '\n';
    }

    output += `\n\nThe ${maxCount}th Erdős prime is ${p.toLocaleString()}.\n`;
    console.log(output);
}

main();
