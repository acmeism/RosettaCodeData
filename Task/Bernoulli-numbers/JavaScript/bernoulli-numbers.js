class Fraction {
    constructor(numerator, denominator = 1) {
        if (denominator === 0) throw new Error("Denominator cannot be zero");

        // Convert to BigInt
        this.numerator = BigInt(numerator);
        this.denominator = BigInt(denominator);

        // Handle negative denominator
        if (this.denominator < 0n) {
            this.numerator = -this.numerator;
            this.denominator = -this.denominator;
        }

        // Simplify
        const gcdVal = this.gcd(this.abs(this.numerator), this.abs(this.denominator));
        this.numerator = this.numerator / gcdVal;
        this.denominator = this.denominator / gcdVal;
    }

    abs(n) {
        return n < 0n ? -n : n;
    }

    gcd(a, b) {
        while (b !== 0n) {
            const temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    subtract(other) {
        const num = this.numerator * other.denominator - other.numerator * this.denominator;
        const den = this.denominator * other.denominator;
        return new Fraction(num, den);
    }

    multiply(other) {
        const num = this.numerator * other.numerator;
        const den = this.denominator * other.denominator;
        return new Fraction(num, den);
    }

    equals(other) {
        return this.numerator === other.numerator && this.denominator === other.denominator;
    }

    toString() {
        if (this.denominator === 1n) {
            return this.numerator.toString();
        }
        return `${this.numerator} / ${this.denominator}`;
    }
}

function bernoulli(n) {
    const A = new Array(n + 1);
    for (let m = 0; m <= n; m++) {
        A[m] = new Fraction(1, m + 1);
        for (let j = m; j >= 1; j--) {
            A[j - 1] = A[j - 1].subtract(A[j]).multiply(new Fraction(j));
        }
    }
    return A[0];
}

// Main execution
const ZERO = new Fraction(0);
for (let n = 0; n <= 60; n++) {
    const b = bernoulli(n);
    if (!b.equals(ZERO)) {
        console.log(`B(${n.toString().padEnd(2)}) = ${b}`);
    }
}
