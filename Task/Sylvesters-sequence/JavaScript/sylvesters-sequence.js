class BigRational {
    constructor(numerator, denominator) {
        this.numerator = BigInt(numerator);
        this.denominator = BigInt(denominator);

        const gcd = this.gcd(this.numerator, this.denominator);
        this.numerator = this.numerator / gcd;
        this.denominator = this.denominator / gcd;
    }

    gcd(a, b) {
        a = a < 0n ? -a : a;
        b = b < 0n ? -b : b;
        while (b !== 0n) {
            const temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    add(other) {
        const numer = this.numerator * other.denominator + this.denominator * other.numerator;
        const denom = this.denominator * other.denominator;
        return new BigRational(numer, denom);
    }

    toDecimal(decimalPlaces) {
        // Scale up the numerator to get the desired precision
        const scale = BigInt(10) ** BigInt(decimalPlaces + 10);
        const scaledNumerator = this.numerator * scale;
        const quotient = scaledNumerator / this.denominator;

        // Convert to string and insert decimal point
        let str = quotient.toString();
        const totalDigits = str.length;
        const integerDigits = totalDigits - decimalPlaces - 10;

        if (integerDigits <= 0) {
            str = '0.' + '0'.repeat(-integerDigits) + str;
        } else {
            str = str.slice(0, integerDigits) + '.' + str.slice(integerDigits);
        }

        // Round and truncate to the desired decimal places
        const dotIndex = str.indexOf('.');
        return str.slice(0, dotIndex + decimalPlaces + 1);
    }

    toString() {
        return `${this.numerator} / ${this.denominator}`;
    }

    static get ZERO() {
        return new BigRational(0n, 1n);
    }
}

function main() {
    console.log("The first 10 terms in Sylvester's sequence are:");
    let term = 2n;
    let sum = BigRational.ZERO;

    for (let i = 1; i <= 10; i++) {
        console.log(term.toString());
        sum = sum.add(new BigRational(1n, term));
        term = term * term - term + 1n;
    }
    console.log();

    console.log("The sum of their reciprocals as a rational number is:");
    console.log(sum.toString() + '\n');

    console.log("The sum of their reciprocals as a decimal number, to 235 decimal places, is:");
    console.log(sum.toDecimal(235));
}

main();
