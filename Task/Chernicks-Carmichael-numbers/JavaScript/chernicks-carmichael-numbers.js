const bigInt = require('big-integer');
class ChernicksCarmichaelNumbers {
    static main() {
        for (let n = 3; n < 10; n++) {
            let m = bigInt(0);
            let foundComposite = true;
            let factors = [];
            while (foundComposite) {
                const increment = (n <= 4)
                    ? bigInt(1)
                    : bigInt(2).pow(n - 4).times(5);
                m = m.add(increment);
                factors = this.U(n, m);
                foundComposite = false;
                for (let i = 0; i < factors.length; i++) {
                    if (!this.isPrime(factors[i])) {
                        foundComposite = true;
                        break;
                    }
                }
            }
            console.log(`U(${n}, ${m}) = ${this.display(factors)} = ${this.multiply(factors)}`);
        }
    }
    static display(factors) {
        return factors.map(f => f.toString()).join(" * ");
    }
    static multiply(factors) {
        return factors.reduce((acc, val) => acc.times(val), bigInt(1));
    }
    static U(n, m) {
        const factors = [];
        factors.push(bigInt(6).times(m).add(1));
        factors.push(bigInt(12).times(m).add(1));
        for (let i = 1; i <= n - 2; i++) {
            factors.push(bigInt(2).pow(i).times(9).times(m).add(1));
        }
        return factors;
    }
    static MAX = 100000;
    static primes = new Array(ChernicksCarmichaelNumbers.MAX);
    static SIEVE_COMPLETE = false;
    static isPrimeTrivial(test) {
        const num = test.toJSNumber();
        if (!ChernicksCarmichaelNumbers.SIEVE_COMPLETE) {
            ChernicksCarmichaelNumbers.sieve();
            ChernicksCarmichaelNumbers.SIEVE_COMPLETE = true;
        }
        return ChernicksCarmichaelNumbers.primes[num];
    }
    static sieve() {
        for (let i = 2; i < ChernicksCarmichaelNumbers.MAX; i++) {
            ChernicksCarmichaelNumbers.primes[i] = true;
        }
        for (let i = 2; i * i < ChernicksCarmichaelNumbers.MAX; i++) {
            if (ChernicksCarmichaelNumbers.primes[i]) {
                for (let j = i * i; j < ChernicksCarmichaelNumbers.MAX; j += i) {
                    ChernicksCarmichaelNumbers.primes[j] = false;
                }
            }
        }
    }
    static isPrime(testValue) {
        if (testValue.equals(2)) return true;
        if (testValue.isEven()) return false;
        if (testValue.lesser(ChernicksCarmichaelNumbers.MAX)) return ChernicksCarmichaelNumbers.isPrimeTrivial(testValue);
        let d = testValue.minus(1);
        let s = 0;
        while (d.isEven()) {
            s += 1;
            d = d.divide(2);
        }
        const valNum = testValue.toJSNumber();
        if (testValue.lesser(1373653)) {
            if (!ChernicksCarmichaelNumbers.aSrp(2, s, d, testValue)) return false;
            if (!ChernicksCarmichaelNumbers.aSrp(3, s, d, testValue)) return false;
            return true;
        }
        if (testValue.lesser(4759123141)) {
            if (!ChernicksCarmichaelNumbers.aSrp(2, s, d, testValue)) return false;
            if (!ChernicksCarmichaelNumbers.aSrp(7, s, d, testValue)) return false;
            if (!ChernicksCarmichaelNumbers.aSrp(61, s, d, testValue)) return false;
            return true;
        }
        if (testValue.lesser("10000000000000000")) {
            if (!ChernicksCarmichaelNumbers.aSrp(3, s, d, testValue)) return false;
            if (!ChernicksCarmichaelNumbers.aSrp(24251, s, d, testValue)) return false;
            return true;
        }
        // Try 5 "random" primes
        if (!ChernicksCarmichaelNumbers.aSrp(37, s, d, testValue)) return false;
        if (!ChernicksCarmichaelNumbers.aSrp(47, s, d, testValue)) return false;
        if (!ChernicksCarmichaelNumbers.aSrp(61, s, d, testValue)) return false;
        if (!ChernicksCarmichaelNumbers.aSrp(73, s, d, testValue)) return false;
        if (!ChernicksCarmichaelNumbers.aSrp(83, s, d, testValue)) return false;
        return true;
    }
    static aSrp(a, s, d, n) {
        let modPow = ChernicksCarmichaelNumbers.modPow(bigInt(a), d, n);
        if (modPow.equals(1)) {
            return true;
        }
        let twoExpR = bigInt(1);
        for (let r = 0; r < s; r++) {
            if (ChernicksCarmichaelNumbers.modPow(modPow, twoExpR, n).equals(n.minus(1))) {
                return true;
            }
            twoExpR = twoExpR.times(2);
        }
        return false;
    }
    static SQRT = bigInt(3037000499); // Approximate sqrt of MAX_SAFE_INTEGER
    static modPow(base, exponent, modulus) {
        let result = bigInt(1);
        let b = bigInt(base);
        let e = bigInt(exponent);
        while (e.greater(0)) {
            if (e.isOdd()) {
                if (result.greater(ChernicksCarmichaelNumbers.SQRT) || b.greater(ChernicksCarmichaelNumbers.SQRT)) {
                    result = ChernicksCarmichaelNumbers.multiplyInternal(result, b, modulus);
                } else {
                    result = result.times(b).mod(modulus);
                }
            }
            e = e.shiftRight(1);
            if (b.greater(ChernicksCarmichaelNumbers.SQRT)) {
                b = ChernicksCarmichaelNumbers.multiplyInternal(b, b, modulus);
            } else {
                b = b.times(b).mod(modulus);
            }
        }
        return result;
    }
    static multiplyInternal(a, b, modulus) {
        let x = bigInt(0);
        let y = a.mod(modulus);
        let bInt = bigInt(b);
        while (bInt.greater(0)) {
            if (bInt.isOdd()) {
                x = x.add(y);
                if (x.greaterOrEquals(modulus)) {
                    x = x.minus(modulus);
                }
            }
            y = y.shiftLeft(1);
            if (y.greaterOrEquals(modulus)) {
                y = y.minus(modulus);
            }
            bInt = bInt.shiftRight(1);
        }
        return x.mod(modulus);
    }
}
ChernicksCarmichaelNumbers.main();
