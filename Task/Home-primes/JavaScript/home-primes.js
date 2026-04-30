/**
 * Home Primes calculator - JavaScript version
 * Finds the home prime for a given number by repeatedly factorizing and concatenating
 */

const CERTAINTY_LEVEL = 20;
const PRIME_LIMIT = 10000;

class HomePrimes {
    constructor() {
        this.primes = [];
        this.listPrimes(PRIME_LIMIT);
    }

    /**
     * Main function to calculate home primes for test values
     */
    main() {
        const values = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 65];

        for (const value of values) {
            let number = BigInt(value);
            const previousNumbers = [number];
            let searching = true;

            while (searching) {
                number = this.concatenate(this.primeFactors(number));
                previousNumbers.push(number);

                if (this.isProbablePrime(number, CERTAINTY_LEVEL)) {
                    const lastIndex = previousNumbers.length - 1;
                    let output = '';
                    for (let k = lastIndex; k >= 1; k--) {
                        output += `HP${previousNumbers[lastIndex - k]}(${k}) = `;
                    }
                    output += previousNumbers[lastIndex];
                    console.log(output);
                    searching = false;
                }
            }
        }
    }

    /**
     * Get prime factors of a number using trial division or Pollard's Rho
     */
    primeFactors(num) {
        if (num <= BigInt(PRIME_LIMIT * PRIME_LIMIT)) {
            return this.smallPrimeFactors(num);
        }

        if (this.isProbablePrime(num, CERTAINTY_LEVEL)) {
            return [num];
        }

        const divisor = this.pollardRho(num);
        const result = [
            ...this.primeFactors(divisor),
            ...this.primeFactors(num / divisor)
        ];
        return result.sort((a, b) => (a < b ? -1 : a > b ? 1 : 0));
    }

    /**
     * Trial division for smaller numbers
     */
    smallPrimeFactors(num) {
        let number = Number(num);
        const result = [];

        for (let i = 0; i < this.primes.length && number > 1; i++) {
            while (number % this.primes[i] === 0) {
                result.push(BigInt(this.primes[i]));
                number = Math.floor(number / this.primes[i]);
            }
        }

        if (number > 1) {
            result.push(BigInt(number));
        }
        return result;
    }

    /**
     * Pollard's Rho algorithm for integer factorization
     */
    pollardRho(num) {
        // Check if even
        if ((num & BigInt(1)) === BigInt(0)) {
            return BigInt(2);
        }

        const bitLength = num.toString(2).length;
        const constant = this.randomBigInt(bitLength);
        let x = this.randomBigInt(bitLength);
        let y = x;
        let divisor = BigInt(1);

        while (divisor === BigInt(1)) {
            x = (x * x + constant) % num;
            y = (y * y + constant) % num;
            y = (y * y + constant) % num;
            divisor = this.gcd(x > y ? x - y : y - x, num);
        }

        return divisor;
    }

    /**
     * Concatenate list of BigInts into a single BigInt
     */
    concatenate(list) {
        const str = list.map(n => n.toString()).join('');
        return BigInt(str);
    }

    /**
     * Sieve of Eratosthenes to generate primes up to limit
     */
    listPrimes(limit) {
        const sieve = new Array(limit + 1).fill(true);
        sieve[0] = false;
        sieve[1] = false;

        for (let i = 2; i * i <= limit; i++) {
            if (sieve[i]) {
                for (let j = i * i; j <= limit; j += i) {
                    sieve[j] = false;
                }
            }
        }

        this.primes = [];
        for (let i = 2; i <= limit; i++) {
            if (sieve[i]) {
                this.primes.push(i);
            }
        }
    }

    /**
     * Miller-Rabin primality test
     */
    isProbablePrime(n, k) {
        if (n === BigInt(2) || n === BigInt(3)) return true;
        if (n <= BigInt(1) || (n & BigInt(1)) === BigInt(0)) return false;

        // Write n-1 as d * 2^r
        let d = n - BigInt(1);
        let r = 0;
        while ((d & BigInt(1)) === BigInt(0)) {
            d >>= BigInt(1);
            r++;
        }

        // Witness loop
        for (let i = 0; i < k; i++) {
            const a = this.randomBigIntRange(BigInt(2), n - BigInt(2));
            let x = this.modPow(a, d, n);

            if (x === BigInt(1) || x === n - BigInt(1)) continue;

            let composite = true;
            for (let j = 0; j < r - 1; j++) {
                x = this.modPow(x, BigInt(2), n);
                if (x === n - BigInt(1)) {
                    composite = false;
                    break;
                }
            }

            if (composite) return false;
        }

        return true;
    }

    /**
     * Modular exponentiation: (base^exp) % mod
     */
    modPow(base, exp, mod) {
        let result = BigInt(1);
        base = base % mod;

        while (exp > BigInt(0)) {
            if ((exp & BigInt(1)) === BigInt(1)) {
                result = (result * base) % mod;
            }
            exp >>= BigInt(1);
            base = (base * base) % mod;
        }

        return result;
    }

    /**
     * Euclidean algorithm for GCD
     */
    gcd(a, b) {
        a = a < BigInt(0) ? -a : a;
        b = b < BigInt(0) ? -b : b;

        while (b !== BigInt(0)) {
            const temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    /**
     * Generate random BigInt with specified bit length
     */
    randomBigInt(bits) {
        const bytes = Math.ceil(bits / 8);
        const hex = Array(bytes)
            .fill(0)
            .map(() => Math.floor(Math.random() * 256).toString(16).padStart(2, '0'))
            .join('');
        const num = BigInt('0x' + hex);
        return num >> BigInt(bytes * 8 - bits); // Trim to exact bit length
    }

    /**
     * Generate random BigInt in range [min, max]
     */
    randomBigIntRange(min, max) {
        const range = max - min + BigInt(1);
        const bits = range.toString(2).length;
        let result;
        do {
            result = this.randomBigInt(bits);
        } while (result >= range);
        return result + min;
    }
}

// Run the program
const hp = new HomePrimes();
hp.main();
