const bigInt = require('big-integer');
class GiugaNumbers {
    static main() {
        // Initialize static lists here to ensure they exist before use
        GiugaNumbers.primes = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59];
        GiugaNumbers.results = [];
        const primeCounts = [3, 4, 5];
        for (const primeCount of primeCounts) {
            GiugaNumbers.primeFactors = new Array(primeCount).fill(0);
            GiugaNumbers.combinations(primeCount, 0, 0);
        }
        GiugaNumbers.results.sort((a, b) => a.minus(b).toJSNumber());
        console.log("Found Giuga numbers: " + GiugaNumbers.results.map(n => n.toString()).join(", "));
    }
    static checkIfGiugaNumber(aPrimeFactors) {
        const product = aPrimeFactors.reduce((acc, val) => acc.multiply(val), bigInt(1));
        for (const factor of aPrimeFactors) {
            const divisor = factor.multiply(factor);
            const numerator = product.minus(factor);
            if (numerator.mod(divisor).notEquals(0)) {
                return;
            }
        }
        GiugaNumbers.results.push(product);
    }
    static combinations(aPrimeCount, aIndex, aLevel) {
        if (aLevel === aPrimeCount) {
            GiugaNumbers.checkIfGiugaNumber(GiugaNumbers.primeFactors);
            return;
        }
        for (let i = aIndex; i < GiugaNumbers.primes.length; i++) {
            GiugaNumbers.primeFactors[aLevel] = bigInt(GiugaNumbers.primes[i]);
            GiugaNumbers.combinations(aPrimeCount, i + 1, aLevel + 1);
        }
    }
}
GiugaNumbers.main();
