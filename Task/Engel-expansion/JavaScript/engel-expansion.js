// Helper function to calculate GCD for BigInt values
function gcd(a, b) {
    a = a < 0n ? -a : a;
    b = b < 0n ? -b : b;
    while (b !== 0n) {
        const temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

class Rational {
    constructor(numerator, denominator = 1) {
        if (typeof numerator === 'string') {
            // Handle decimal string input
            const decimalIndex = numerator.indexOf('.');
            if (decimalIndex === -1) {
                this.numerator = BigInt(numerator);
                this.denominator = BigInt(1);
            } else {
                const decimalPlaces = numerator.length - 1 - decimalIndex;
                const numer = BigInt(numerator.replace('.', ''));
                const denom = BigInt(10) ** BigInt(decimalPlaces);
                const gcdValue = gcd(numer, denom);
                this.numerator = numer / gcdValue;
                this.denominator = denom / gcdValue;
            }
        } else {
            this.numerator = BigInt(numerator);
            this.denominator = BigInt(denominator);
            if (this.denominator === 0n) {
                throw new Error("Denominator cannot be zero");
            }
            const gcdValue = gcd(this.numerator, this.denominator);
            this.numerator /= gcdValue;
            this.denominator /= gcdValue;
        }
    }

    toDecimal(decimalPlaces = 10) {
        let result = '';
        let numer = this.numerator;
        let denom = this.denominator;
        let quotient = numer / denom;

        for (let i = 0; i <= decimalPlaces; i++) {
            result += quotient.toString();
            numer -= denom * quotient;
            if (numer === 0n) {
                break;
            }
            numer *= 10n;
            quotient = numer / denom;
            if (i === 0) {
                result += '.';
            }
        }
        return result;
    }

    equals(other) {
        return this.numerator === other.numerator && this.denominator === other.denominator;
    }

    add(other) {
        const numer = (this.numerator * other.denominator) + (this.denominator * other.numerator);
        const denom = this.denominator * other.denominator;
        return new Rational(numer, denom);
    }

    subtract(other) {
        const numer = (this.numerator * other.denominator) - (this.denominator * other.numerator);
        const denom = this.denominator * other.denominator;
        return new Rational(numer, denom);
    }

    multiply(other) {
        return new Rational(this.numerator * other.numerator, this.denominator * other.denominator);
    }

    inverse() {
        return new Rational(this.denominator, this.numerator);
    }

    ceiling() {
        return (this.numerator % this.denominator === 0n) ?
            this.numerator / this.denominator :
            this.numerator / this.denominator + 1n;
    }
}

const RATIONAL_ZERO = new Rational(0, 1);
const RATIONAL_ONE = new Rational(1, 1);

function toEngel(decimal) {
    const engel = [];
    let rational = new Rational(decimal);

    while (!rational.equals(RATIONAL_ZERO)) {
        const term = rational.inverse().ceiling();
        engel.push(Number(term));
        rational = rational.multiply(new Rational(term)).subtract(RATIONAL_ONE);
    }

    return engel;
}

function fromEngel(engel) {
    let sum = RATIONAL_ZERO;
    let product = RATIONAL_ONE;

    for (const element of engel) {
        const rational = new Rational(element).inverse();
        product = product.multiply(rational);
        sum = sum.add(product);
    }

    return sum;
}

function main() {
    const rationals = ["3.14159265358979", "2.71828182845904", "1.414213562373095"];

    for (const rational of rationals) {
        const engel = toEngel(rational);
        console.log(`Rational number : ${rational}`);
        console.log(`Engel expansion : ${engel.join(' ')}`);
        console.log(`Number of terms : ${engel.length}`);

        // Due to precision limits, we'll use a reduced set of terms
        const decimalPlaces = rational.length - rational.indexOf('.') - 1;
        const reducedEngel = engel.slice(0, 9);
        console.log(`Back to rational: ${fromEngel(reducedEngel).toDecimal(Math.floor(decimalPlaces / 2))}`);
        console.log('');
    }
}

// Run the main function
main();
