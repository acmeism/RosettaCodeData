class QuadraticCoefficients {
    constructor(q0, q1, q2) {
        this.q0 = q0;
        this.q1 = q1;
        this.q2 = q2;
    }

    toString() {
        return `[${this.q0}, ${this.q1}, ${this.q2}]`;
    }
}

class CubicCoefficients {
    constructor(c0, c1, c2, c3) {
        this.c0 = c0;
        this.c1 = c1;
        this.c2 = c2;
        this.c3 = c3;
    }

    toString() {
        return `[${this.c0}, ${this.c1}, ${this.c2}, ${this.c3}]`;
    }
}

// Subprogram (1)
function monomialToBernsteinDegree2(monomial) {
    return new QuadraticCoefficients(
        monomial.q0,
        monomial.q0 + (monomial.q1 / 2.0),
        monomial.q0 + monomial.q1 + monomial.q2
    );
}

// Subprogram (2)
function evaluateBernsteinDegree2(bernstein, t) {
    const s = 1 - t;
    const b01 = (s * bernstein.q0) + (t * bernstein.q1);
    const b12 = (s * bernstein.q1) + (t * bernstein.q2);
    return (s * b01) + (t * b12);
}

// Subprogram (3)
function monomialToBernsteinDegree3(monomial) {
    return new CubicCoefficients(
        monomial.c0,
        monomial.c0 + (monomial.c1 / 3.0),
        monomial.c0 + (2.0 * monomial.c1 / 3.0) + (monomial.c2 / 3.0),
        monomial.c0 + monomial.c1 + monomial.c2 + monomial.c3
    );
}

// Subprogram (4)
function evaluateBernsteinDegree3(bernstein, t) {
    const s = 1 - t;
    const b01 = (s * bernstein.c0) + (t * bernstein.c1);
    const b12 = (s * bernstein.c1) + (t * bernstein.c2);
    const b23 = (s * bernstein.c2) + (t * bernstein.c3);
    const b012 = (s * b01) + (t * b12);
    const b123 = (s * b12) + (t * b23);
    return (s * b012) + (t * b123);
}

// Subprogram (5)
function bernsteinDegree2ToDegree3(bernstein) {
    return new CubicCoefficients(
        bernstein.q0,
        (bernstein.q0 / 3.0) + (2.0 * bernstein.q1 / 3.0),
        (2.0 * bernstein.q1 / 3.0) + (bernstein.q2 / 3.0),
        bernstein.q2
    );
}

function evaluateMonomialDegree2(monomial, t) {
    return monomial.q0 + (t * (monomial.q1 + (t * monomial.q2)));
}

function evaluateMonomialDegree3(monomial, t) {
    return monomial.c0 + (t * (monomial.c1 + (t * (monomial.c2 + (t * monomial.c3)))));
}

// Main logic
function main() {
    // Subprogram (1) examples
    const pMonomial2 = new QuadraticCoefficients(1.0, 0.0, 0.0);
    const qMonomial2 = new QuadraticCoefficients(1.0, 2.0, 3.0);
    const pBernstein2 = monomialToBernsteinDegree2(pMonomial2);
    const qBernstein2 = monomialToBernsteinDegree2(qMonomial2);
    console.log("Subprogram (1) examples:");
    console.log(`    monomial ${pMonomial2} --> bernstein ${pBernstein2}`);
    console.log(`    monomial ${qMonomial2} --> bernstein ${qBernstein2}`);

    // Subprogram (2) examples
    console.log("Subprogram (2) examples:");
    [0.25, 7.50].forEach(x => {
        console.log(`    p(${x}) = ${evaluateBernsteinDegree2(pBernstein2, x)} ( mono: ${evaluateMonomialDegree2(pMonomial2, x)} )`);
    });
    [0.25, 7.50].forEach(x => {
        console.log(`    q(${x}) = ${evaluateBernsteinDegree2(qBernstein2, x)} ( mono: ${evaluateMonomialDegree2(qMonomial2, x)} )`);
    });

    // Subprogram (3) examples
    const pMonomial3 = new CubicCoefficients(1.0, 0.0, 0.0, 0.0);
    const qMonomial3 = new CubicCoefficients(1.0, 2.0, 3.0, 0.0);
    const rMonomial3 = new CubicCoefficients(1.0, 2.0, 3.0, 4.0);
    const pBernstein3 = monomialToBernsteinDegree3(pMonomial3);
    const qBernstein3 = monomialToBernsteinDegree3(qMonomial3);
    const rBernstein3 = monomialToBernsteinDegree3(rMonomial3);
    console.log("Subprogram (3) examples:");
    console.log(`    monomial ${pMonomial3} --> bernstein ${pBernstein3}`);
    console.log(`    monomial ${qMonomial3} --> bernstein ${qBernstein3}`);
    console.log(`    monomial ${rMonomial3} --> bernstein ${rBernstein3}`);

    // Subprogram (4) examples
    console.log("Subprogram (4) examples:");
    [0.25, 7.50].forEach(x => {
        console.log(`    p(${x}) = ${evaluateBernsteinDegree3(pBernstein3, x)} ( mono: ${evaluateMonomialDegree3(pMonomial3, x)} )`);
    });
    [0.25, 7.50].forEach(x => {
        console.log(`    q(${x}) = ${evaluateBernsteinDegree3(qBernstein3, x)} ( mono: ${evaluateMonomialDegree3(qMonomial3, x)} )`);
    });
    [0.25, 7.50].forEach(x => {
        console.log(`    r(${x}) = ${evaluateBernsteinDegree3(rBernstein3, x)} ( mono: ${evaluateMonomialDegree3(rMonomial3, x)} )`);
    });

    // Subprogram (5) examples
    console.log("Subprogram (5) examples:");
    const pBernstein3a = bernsteinDegree2ToDegree3(pBernstein2);
    const qBernstein3a = bernsteinDegree2ToDegree3(qBernstein2);
    console.log(`    bernstein ${pBernstein2} --> bernstein ${pBernstein3a}`);
    console.log(`    bernstein ${qBernstein2} --> bernstein ${qBernstein3a}`);
}

main();

