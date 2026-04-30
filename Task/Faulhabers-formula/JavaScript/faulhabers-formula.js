function gcd(a, b) {
    if (b === 0) {
        return a;
    }
    return gcd(b, a % b);
}

class Frac {
    constructor(n, d) {
        if (d === 0) throw new Error("d must not be zero");
        let nn = n;
        let dd = d;
        if (nn === 0) {
            dd = 1;
        } else if (dd < 0) {
            nn = -nn;
            dd = -dd;
        }
        const g = Math.abs(gcd(nn, dd));
        if (g > 1) {
            nn = Math.floor(nn / g);
            dd = Math.floor(dd / g);
        }
        this.num = nn;
        this.denom = dd;
    }

    plus(rhs) {
        return new Frac(this.num * rhs.denom + this.denom * rhs.num, rhs.denom * this.denom);
    }

    unaryMinus() {
        return new Frac(-this.num, this.denom);
    }

    minus(rhs) {
        return this.plus(rhs.unaryMinus());
    }

    times(rhs) {
        return new Frac(this.num * rhs.num, this.denom * rhs.denom);
    }

    compareTo(o) {
        const diff = this.toDouble() - o.toDouble();
        return Math.sign(diff);
    }

    equals(obj) {
        return obj !== null && obj instanceof Frac && this.compareTo(obj) === 0;
    }

    toString() {
        if (this.denom === 1) {
            return this.num.toString();
        }
        return `${this.num}/${this.denom}`;
    }

    toDouble() {
        return this.num / this.denom;
    }
}

Frac.ZERO = new Frac(0, 1);
Frac.ONE = new Frac(1, 1);

function bernoulli(n) {
    if (n < 0) throw new Error("n may not be negative or zero");
    const a = new Array(n + 1).fill(null).map(() => Frac.ZERO);
    for (let m = 0; m <= n; m++) {
        a[m] = new Frac(1, m + 1);
        for (let j = m; j >= 1; j--) {
            a[j - 1] = a[j - 1].minus(a[j]).times(new Frac(j, 1));
        }
    }
    // returns 'first' Bernoulli number
    if (n !== 1) return a[0];
    return a[0].unaryMinus();
}

function binomial(n, k) {
    if (n < 0 || k < 0 || n < k) throw new Error("Invalid arguments");
    if (n === 0 || k === 0) return 1;

    let num = 1;
    for (let i = k + 1; i <= n; i++) {
        num *= i;
    }

    let den = 1;
    for (let i = 2; i <= n - k; i++) {
        den *= i;
    }

    return Math.floor(num / den);
}

function faulhaber(p) {
    let output = `${p} : `;
    const q = new Frac(1, p + 1);
    let sign = -1;

    for (let j = 0; j <= p; j++) {
        sign *= -1;
        const coeff = q.times(new Frac(sign, 1))
                       .times(new Frac(binomial(p + 1, j), 1))
                       .times(bernoulli(j));

        if (Frac.ZERO.equals(coeff)) continue;

        if (j === 0) {
            if (!Frac.ONE.equals(coeff)) {
                if (Frac.ONE.unaryMinus().equals(coeff)) {
                    output += "-";
                } else {
                    output += coeff.toString();
                }
            }
        } else {
            if (Frac.ONE.equals(coeff)) {
                output += " + ";
            } else if (Frac.ONE.unaryMinus().equals(coeff)) {
                output += " - ";
            } else if (coeff.compareTo(Frac.ZERO) > 0) {
                output += ` + ${coeff.toString()}`;
            } else {
                output += ` - ${coeff.unaryMinus().toString()}`;
            }
        }

        const pwr = p + 1 - j;
        if (pwr > 1) {
            output += `n^${pwr}`;
        } else {
            output += "n";
        }
    }

    console.log(output);
}

// Main execution
for (let i = 0; i <= 9; i++) {
    faulhaber(i);
}
