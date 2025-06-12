const MAX_ALL_FACTORS = 100000;
const algorithm = 2;
let divisions = 0;

// Term class
class Term {
    constructor(c, e) {
        this.m_coefficient = c;
        this.m_exponent = e;
    }

    coefficient() {
        return this.m_coefficient;
    }

    degree() {
        return this.m_exponent;
    }

    negated() {
        return new Term(-this.m_coefficient, this.m_exponent);
    }

    multiply(rhs) {
        return new Term(this.m_coefficient * rhs.m_coefficient, this.m_exponent + rhs.m_exponent);
    }

    add(rhs) {
        if (this.m_exponent !== rhs.m_exponent) {
            throw new Error("Exponents not equal");
        }
        return new Term(this.m_coefficient + rhs.m_coefficient, this.m_exponent);
    }

    toString() {
        if (this.m_coefficient === 0) {
            return '0';
        }
        if (this.m_exponent === 0) {
            return this.m_coefficient.toString();
        }
        if (this.m_coefficient === 1) {
            if (this.m_exponent === 1) {
                return 'x';
            }
            return `x^${this.m_exponent}`;
        }
        if (this.m_coefficient === -1) {
            if (this.m_exponent === 1) {
                return "-x";
            }
            return `-x^${this.m_exponent}`;
        }
        if (this.m_exponent === 1) {
            return `${this.m_coefficient}x`;
        }
        return `${this.m_coefficient}x^${this.m_exponent}`;
    }
}

// Polynomial class
class Polynomial {
    constructor(values) {
        this.polynomialTerms = [];

        if (values === undefined) {
            this.polynomialTerms.push(new Term(0, 0));
        } else if (Array.isArray(values) && values.length % 2 === 0) {
            for (let i = 0; i < values.length; i += 2) {
                this.polynomialTerms.push(new Term(values[i], values[i+1]));
            }
            this.polynomialTerms.sort((t, u) => u.degree() - t.degree());
        } else if (Array.isArray(values)) {
            if (values.length === 0) {
                this.polynomialTerms.push(new Term(0, 0));
            } else {
                for (let t of values) {
                    if (t.coefficient() !== 0) {
                        this.polynomialTerms.push(t);
                    }
                }
                if (this.polynomialTerms.length === 0) {
                    this.polynomialTerms.push(new Term(0, 0));
                }
                this.polynomialTerms.sort((t, u) => u.degree() - t.degree());
            }
        }
    }

    leadingCoefficient() {
        return this.polynomialTerms[0].coefficient();
    }

    degree() {
        return this.polynomialTerms[0].degree();
    }

    hasCoefficientAbs(coeff) {
        for (let term of this.polynomialTerms) {
            if (Math.abs(term.coefficient()) === coeff) {
                return true;
            }
        }
        return false;
    }

    addTerm(term) {
        const termList = [];
        let added = false;

        for (let index = 0; index < this.polynomialTerms.length; index++) {
            const currentTerm = this.polynomialTerms[index];
            if (currentTerm.degree() === term.degree()) {
                added = true;
                if (currentTerm.coefficient() + term.coefficient() !== 0) {
                    termList.push(currentTerm.add(term));
                }
            } else {
                termList.push(currentTerm);
            }
        }

        if (!added) {
            termList.push(term);
        }

        return new Polynomial(termList);
    }

    multiplyByTerm(term) {
        const termList = [];

        for (let index = 0; index < this.polynomialTerms.length; index++) {
            const currentTerm = this.polynomialTerms[index];
            termList.push(currentTerm.multiply(term));
        }

        return new Polynomial(termList);
    }

    add(p) {
        const termList = [];
        let thisCount = this.polynomialTerms.length;
        let polyCount = p.polynomialTerms.length;

        while (thisCount > 0 || polyCount > 0) {
            if (thisCount === 0) {
                const polyTerm = p.polynomialTerms[polyCount - 1];
                termList.push(polyTerm);
                polyCount--;
            } else if (polyCount === 0) {
                const thisTerm = this.polynomialTerms[thisCount - 1];
                termList.push(thisTerm);
                thisCount--;
            } else {
                const polyTerm = p.polynomialTerms[polyCount - 1];
                const thisTerm = this.polynomialTerms[thisCount - 1];

                if (thisTerm.degree() === polyTerm.degree()) {
                    const t = thisTerm.add(polyTerm);
                    if (t.coefficient() !== 0) {
                        termList.push(t);
                    }
                    thisCount--;
                    polyCount--;
                } else if (thisTerm.degree() < polyTerm.degree()) {
                    termList.push(thisTerm);
                    thisCount--;
                } else {
                    termList.push(polyTerm);
                    polyCount--;
                }
            }
        }

        return new Polynomial(termList);
    }

    divide(v) {
        divisions++;

        let q = new Polynomial();
        let r = new Polynomial(this.polynomialTerms);
        const lcv = v.leadingCoefficient();
        const dv = v.degree();

        while (r.degree() >= v.degree()) {
            const lcr = r.leadingCoefficient();
            const s = Math.floor(lcr / lcv);
            const term = new Term(s, r.degree() - dv);
            q = q.addTerm(term);
            r = r.add(v.multiplyByTerm(term.negated()));
        }

        return q;
    }

    toString() {
        if (this.polynomialTerms.length === 0) {
            return '0';
        }

        let result = this.polynomialTerms[0].toString();

        for (let i = 1; i < this.polynomialTerms.length; i++) {
            const term = this.polynomialTerms[i];
            if (term.coefficient() > 0) {
                result += ` + ${term.toString()}`;
            } else {
                result += ` - ${term.negated().toString()}`;
            }
        }

        return result;
    }
}

function getDivisors(number) {
    const divisors = [];
    const root = Math.floor(Math.sqrt(number));

    for (let i = 1; i <= root; i++) {
        if (number % i === 0) {
            divisors.push(i);
            const div = Math.floor(number / i);
            if (div !== i && div !== number) {
                divisors.push(div);
            }
        }
    }

    return divisors;
}

const allFactors = new Map();

function getFactors(number) {
    if (allFactors.has(number)) {
        return allFactors.get(number);
    }

    const factors = new Map();

    if (number % 2 === 0) {
        const factorsDivTwo = getFactors(number / 2);
        for (const [key, value] of factorsDivTwo) {
            factors.set(key, value);
        }
        factors.set(2, (factors.get(2) || 0) + 1);

        if (number < MAX_ALL_FACTORS) {
            allFactors.set(number, factors);
        }

        return factors;
    }

    const root = Math.floor(Math.sqrt(number));
    let i = 3;

    while (i <= root) {
        if (number % i === 0) {
            const factorsDivI = getFactors(number / i);
            for (const [key, value] of factorsDivI) {
                factors.set(key, value);
            }
            factors.set(i, (factors.get(i) || 0) + 1);

            if (number < MAX_ALL_FACTORS) {
                allFactors.set(number, factors);
            }

            return factors;
        }
        i += 2;
    }

    factors.set(number, 1);

    if (number < MAX_ALL_FACTORS) {
        allFactors.set(number, factors);
    }

    return factors;
}

const COMPUTED = new Map();

function cyclotomicPolynomial(n) {
    if (COMPUTED.has(n)) {
        return COMPUTED.get(n);
    }

    if (n === 1) {
        // Polynomial: x - 1
        const p = new Polynomial([1, 1, -1, 0]);
        COMPUTED.set(1, p);
        return p;
    }

    const factors = getFactors(n);

    if (factors.has(n)) {
        // n prime
        const termList = [];
        for (let index = 0; index < n; index++) {
            termList.push(new Term(1, index));
        }

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (factors.size === 2 && factors.has(2) && factors.get(2) === 1 && factors.has(n / 2) && factors.get(n / 2) === 1) {
        // n = 2p
        const prime = n / 2;
        const termList = [];
        let coeff = -1;

        for (let index = 0; index < prime; index++) {
            coeff *= -1;
            termList.push(new Term(coeff, index));
        }

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (factors.size === 1 && factors.has(2)) {
        // n = 2^h
        const h = factors.get(2);
        const termList = [];
        termList.push(new Term(1, Math.pow(2, h - 1)));
        termList.push(new Term(1, 0));

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (factors.size === 1 && factors.has(n)) {
        // n = p^k
        let p = 0;
        let k = 0;

        for (const [key, value] of factors) {
            p = key;
            k = value;
        }

        const termList = [];
        for (let index = 0; index < p; index++) {
            termList.push(new Term(1, index * Math.pow(p, k - 1)));
        }

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (factors.size === 2 && factors.has(2)) {
        // n = 2^h * p^k
        let p = 0;

        for (const [key, value] of factors) {
            if (key !== 2) {
                p = key;
            }
        }

        const termList = [];
        let coeff = -1;
        const twoExp = Math.pow(2, factors.get(2) - 1);
        const k = factors.get(p);

        for (let index = 0; index < p; index++) {
            coeff *= -1;
            termList.push(new Term(coeff, index * twoExp * Math.pow(p, k - 1)));
        }

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (factors.has(2) && ((n / 2) % 2 === 1) && (n / 2) > 1) {
        //  CP(2m)[x] = CP(-m)[x], n odd integer > 1
        const cycloDiv2 = cyclotomicPolynomial(n / 2);
        const termList = [];

        for (const term of cycloDiv2.polynomialTerms) {
            if (term.degree() % 2 === 0) {
                termList.push(term);
            } else {
                termList.push(term.negated());
            }
        }

        const cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    }

    // General Case
    if (algorithm === 0) {
        // slow - uses basic definition
        const divisors = getDivisors(n);
        // Polynomial: (x^n - 1)
        let cyclo = new Polynomial([1, n, -1, 0]);

        for (const i of divisors) {
            const p = cyclotomicPolynomial(i);
            cyclo = cyclo.divide(p);
        }

        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (algorithm === 1) {
        //  Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
        const divisors = getDivisors(n);
        let maxDivisor = Number.MIN_SAFE_INTEGER;

        for (const div of divisors) {
            maxDivisor = Math.max(maxDivisor, div);
        }

        const divisorExceptMax = [];
        for (const div of divisors) {
            if (maxDivisor % div !== 0) {
                divisorExceptMax.push(div);
            }
        }

        //  Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
        let cyclo = new Polynomial([1, n, -1, 0]).divide(new Polynomial([1, maxDivisor, -1, 0]));

        for (const i of divisorExceptMax) {
            const p = cyclotomicPolynomial(i);
            cyclo = cyclo.divide(p);
        }

        COMPUTED.set(n, cyclo);
        return cyclo;
    } else if (algorithm === 2) {
        //  Fastest
        //  Let p ; q be primes such that p does not divide n, and q q divides n.
        //  Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
        let m = 1;
        let cyclo = cyclotomicPolynomial(m);
        const primes = Array.from(factors.keys()).sort((a, b) => a - b);

        for (const prime of primes) {
            //  CP(m)[x]
            const cycloM = cyclo;
            //  Compute CP(m)[x^p].
            const termList = [];

            for (const t of cycloM.polynomialTerms) {
                termList.push(new Term(t.coefficient(), t.degree() * prime));
            }

            cyclo = new Polynomial(termList).divide(cycloM);
            m = m * prime;
        }

        //  Now, m is the largest square free divisor of n
        const s = n / m;
        //  Compute CP(n)[x] = CP(m)[x^s]
        const termList = [];

        for (const t of cyclo.polynomialTerms) {
            termList.push(new Term(t.coefficient(), t.degree() * s));
        }

        cyclo = new Polynomial(termList);
        COMPUTED.set(n, cyclo);
        return cyclo;
    } else {
        throw new Error("Invalid algorithm");
    }
}

function main() {
    // initialization
    const factors = new Map();
    factors.set(2, 1);
    allFactors.set(2, factors);

    // Task 1: cyclotomic polynomials for n <= 30
    console.log("Task 1:  cyclotomic polynomials for n <= 30:");
    for (let i = 1; i <= 30; i++) {
        const p = cyclotomicPolynomial(i);
        console.log(`CP[${i}] = ${p.toString()}`);
    }

    // Task 2: Smallest cyclotomic polynomial with n or -n as a coefficient
    console.log("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:");
    let n = 0;
    for (let i = 1; i <= 10; i++) {
        while (true) {
            n++;
            const cyclo = cyclotomicPolynomial(n);
            if (cyclo.hasCoefficientAbs(i)) {
                console.log(`CP[${n}] has coefficient with magnitude = ${i}`);
                n--;
                break;
            }
        }
    }
}

main();
