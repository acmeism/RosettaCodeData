class ErdosSelfridge {
    constructor(limit) {
        this.primes = this.generatePrimes(limit);
        this.category = new Array(this.primes.length).fill(0);
    }

    generatePrimes(limit) {
        // Simple prime generator for demonstration
        // Note: This is a naive implementation; for large limits, use a more efficient algorithm
        const primes = [];
        let num = 2;
        while (primes.length < limit) {
            if (this.isPrime(num)) {
                primes.push(num);
            }
            num++;
        }
        return primes;
    }

    isPrime(n) {
        if (n <= 1) return false;
        for (let i = 2; i * i <= n; i++) {
            if (n % i === 0) return false;
        }
        return true;
    }

    getPrimesByCategory(limit) {
        const result = new Map();
        for (let i = 0; i < limit; i++) {
            const cat = this.getCategory(i);
            if (!result.has(cat)) {
                result.set(cat, []);
            }
            result.get(cat).push(this.primes[i]);
        }
        return result;
    }

    getCategory(index) {
        if (this.category[index] !== 0) {
            return this.category[index];
        }
        let maxCategory = 0;
        let n = this.primes[index] + 1;
        for (let i = 0; n > 1; i++) {
            const p = this.primes[i];
            if (p * p > n) break;
            let count = 0;
            while (n % p === 0) {
                n /= p;
                count++;
            }
            if (count !== 0) {
                const cat = (p <= 3) ? 1 : 1 + this.getCategory(i);
                maxCategory = Math.max(maxCategory, cat);
            }
        }
        if (n > 1) {
            const cat = (n <= 3) ? 1 : 1 + this.getCategory(this.getIndex(n));
            maxCategory = Math.max(maxCategory, cat);
        }
        this.category[index] = maxCategory;
        return maxCategory;
    }

    getIndex(prime) {
        // Binary search for the prime in the array
        let left = 0;
        let right = this.primes.length - 1;
        while (left <= right) {
            const mid = Math.floor((left + right) / 2);
            if (this.primes[mid] === prime) {
                return mid;
            } else if (this.primes[mid] < prime) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1;
    }
}

// Example usage:
const es = new ErdosSelfridge(1000000);
console.log("First 200 primes:");
const first200 = es.getPrimesByCategory(200);
for (const [category, primes] of first200) {
    console.log(`Category ${category}:`);
    for (let i = 0; i < primes.length; i++) {
        process.stdout.write(`${primes[i].toString().padStart(4)}${(i + 1) % 15 === 0 ? '\n' : ' '}`);
    }
    console.log('\n');
}

console.log("First 1,000,000 primes:");
const first1M = es.getPrimesByCategory(1000000);
for (const [category, primes] of first1M) {
    console.log(`Category ${category.toString().padStart(2)}: first = ${primes[0].toString().padStart(7)}  last = ${primes[primes.length - 1].toString().padStart(8)}  count = ${primes.length}`);
}
