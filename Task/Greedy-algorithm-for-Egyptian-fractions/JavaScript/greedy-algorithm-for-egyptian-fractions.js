// Egyptian Fractions implementation in JavaScript
// Using BigInt for arbitrary precision integers

function gcd(a, b) {
    if (b === 0n) {
        return a;
    }
    return gcd(b, a % b);
}

class Frac {
    constructor(n, d) {
        // Handle different input types (number or BigInt)
        const num = typeof n === 'number' ? BigInt(n) : n;
        const denom = typeof d === 'number' ? BigInt(d) : d;

        if (denom === 0n) {
            throw new Error("Parameter d may not be zero.");
        }

        let nn = num;
        let dd = denom;

        if (nn === 0n) {
            dd = 1n;
        } else if (dd < 0n) {
            nn = -nn;
            dd = -dd;
        }

        const g = gcd(nn < 0n ? -nn : nn, dd).valueOf();

        if (g > 0n) {
            nn = nn / g;
            dd = dd / g;
        }

        this.num = nn;
        this.denom = dd;
    }

    plus(rhs) {
        return new Frac(
            this.num * rhs.denom + this.denom * rhs.num,
            this.denom * rhs.denom
        );
    }

    unaryMinus() {
        return new Frac(-this.num, this.denom);
    }

    minus(rhs) {
        return this.plus(rhs.unaryMinus());
    }

    compareTo(rhs) {
        // We'll compare by cross multiplication to avoid floating point issues
        const leftSide = this.num * rhs.denom;
        const rightSide = rhs.num * this.denom;

        if (leftSide < rightSide) return -1;
        if (leftSide > rightSide) return 1;
        return 0;
    }

    equals(obj) {
        if (!(obj instanceof Frac)) {
            return false;
        }
        return this.compareTo(obj) === 0;
    }

    toString() {
        if (this.denom === 1n) {
            return this.num.toString();
        }
        return `${this.num}/${this.denom}`;
    }

    toNumber() {
        // Convert fraction to a regular number (potentially with loss of precision)
        return Number(this.num) / Number(this.denom);
    }

    toEgyptian() {
        if (this.num === 0n) {
            return [this];
        }

        const fracs = [];

        if ((this.num < 0n ? -this.num : this.num) >= (this.denom < 0n ? -this.denom : this.denom)) {
            // Handle improper fractions
            const div = new Frac(this.num / this.denom, 1n);
            const rem = this.minus(div);
            fracs.push(div);
            this._toEgyptian(rem.num, rem.denom, fracs);
        } else {
            this._toEgyptian(this.num, this.denom, fracs);
        }

        return fracs;
    }

    _toEgyptian(n, d, fracs) {
        if (n === 0n) {
            return;
        }

        // Calculate ceiling of d/n
        let div = d / n;
        if (d % n !== 0n) {
            div = div + 1n;
        }

        fracs.push(new Frac(1n, div));

        // Calculate next fraction's numerator and denominator
        let n3 = -(d % n);
        if (n3 < 0n) {
            n3 = n3 + n;
        }

        const d3 = d * div;
        const f = new Frac(n3, d3);

        if (f.num === 1n) {
            fracs.push(f);
            return;
        }

        this._toEgyptian(f.num, f.denom, fracs);
    }
}

// Main function
function main() {
    const fracs = [
        new Frac(43, 48),
        new Frac(5, 121),
        new Frac(2014, 59)
    ];

    for (const frac of fracs) {
        const list = frac.toEgyptian();
        const first = list[0];

        if (first.denom === 1n) {
            process.stdout.write(`${frac} -> [${first}] + `);
        } else {
            process.stdout.write(`${frac} -> ${first}`);
        }

        for (let i = 1; i < list.length; ++i) {
            process.stdout.write(` + ${list[i]}`);
        }

        console.log();
    }

    for (const r of [98, 998]) {
        if (r === 98) {
            console.log("\nFor proper fractions with 1 or 2 digits:");
        } else {
            console.log("\nFor proper fractions with 1, 2 or 3 digits:");
        }

        let maxSize = 0;
        let maxSizeFracs = [];
        let maxDen = 0n;
        let maxDenFracs = [];

        // Create sieve array
        const sieve = Array(r + 1).fill().map(() => Array(r + 2).fill(false));

        for (let i = 1; i < r; ++i) {
            for (let j = i + 1; j < r + 1; ++j) {
                if (sieve[i][j]) continue;

                const f = new Frac(i, j);
                const list = f.toEgyptian();
                const listSize = list.length;

                if (listSize > maxSize) {
                    maxSize = listSize;
                    maxSizeFracs = [f];
                } else if (listSize === maxSize) {
                    maxSizeFracs.push(f);
                }

                const listDen = list[list.length - 1].denom;

                if (listDen > maxDen) {
                    maxDen = listDen;
                    maxDenFracs = [f];
                } else if (listDen === maxDen) {
                    maxDenFracs.push(f);
                }

                if (i < r / 2) {
                    let k = 2;
                    while (true) {
                        if (j * k > r + 1) break;
                        sieve[i * k][j * k] = true;
                        k++;
                    }
                }
            }
        }

        console.log(`  largest number of items = ${maxSize}`);
        console.log(`fraction(s) with this number : ${maxSizeFracs}`);

        const md = maxDen.toString();
        console.log(`  largest denominator = ${md.length} digits, ${md.substring(0, 20)}...${md.substring(md.length - 20)}`);
        console.log(`fraction(s) with this denominator : ${maxDenFracs}`);
    }
}

// Run the main function
main();
