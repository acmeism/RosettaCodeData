class R2cf {
    constructor(n1, n2) {
        this.n1 = n1;
        this.n2 = n2;
    }

    hasMoreTerms() {
        return Math.abs(this.n2) > 0;
    }

    nextTerm() {
        const term = Math.floor(this.n1 / this.n2);
        const temp = this.n2;
        this.n2 = this.n1 - term * this.n2;
        this.n1 = temp;
        return term;
    }
}

class MatrixNG {
    constructor() {
        this.configuration = 0;
        this.currentTerm = 0;
        this.hasTerm = false;
    }

    consumeTerm() {
        throw new Error("Must implement consumeTerm in subclass");
    }

    consumeTermWithN(n) {
        throw new Error("Must implement consumeTermWithN in subclass");
    }

    needsTerm() {
        throw new Error("Must implement needsTerm in subclass");
    }
}

class NG4 extends MatrixNG {
    constructor(a1, a, b1, b) {
        super();
        this.a1 = a1;
        this.a = a;
        this.b1 = b1;
        this.b = b;
    }

    consumeTerm() {
        this.a = this.a1;
        this.b = this.b1;
    }

    consumeTermWithN(n) {
        let temp = this.a;
        this.a = this.a1;
        this.a1 = temp + this.a1 * n;
        temp = this.b;
        this.b = this.b1;
        this.b1 = temp + this.b1 * n;
    }

    needsTerm() {
        if (this.b1 === 0 && this.b === 0) {
            return false;
        }
        if (this.b1 === 0 || this.b === 0) {
            return true;
        }

        this.currentTerm = Math.floor(this.a / this.b);
        if (this.currentTerm === Math.floor(this.a1 / this.b1)) {
            let temp = this.a;
            this.a = this.b;
            this.b = temp - this.b * this.currentTerm;
            temp = this.a1;
            this.a1 = this.b1;
            this.b1 = temp - this.b1 * this.currentTerm;

            this.hasTerm = true;
            return false;
        }
        return true;
    }
}

class NG8 extends MatrixNG {
    constructor(a12, a1, a2, a, b12, b1, b2, b) {
        super();
        this.a12 = a12;
        this.a1 = a1;
        this.a2 = a2;
        this.a = a;
        this.b12 = b12;
        this.b1 = b1;
        this.b2 = b2;
        this.b = b;
        this.ab = 0;
        this.a1b1 = 0;
        this.a2b2 = 0;
        this.a12b12 = 0;
    }

    consumeTerm() {
        if (this.configuration === 0) {
            this.a = this.a1;
            this.a2 = this.a12;
            this.b = this.b1;
            this.b2 = this.b12;
        } else {
            this.a = this.a2;
            this.a1 = this.a12;
            this.b = this.b2;
            this.b1 = this.b12;
        }
    }

    consumeTermWithN(n) {
        if (this.configuration === 0) {
            let temp = this.a;
            this.a = this.a1;
            this.a1 = temp + this.a1 * n;
            temp = this.a2;
            this.a2 = this.a12;
            this.a12 = temp + this.a12 * n;
            temp = this.b;
            this.b = this.b1;
            this.b1 = temp + this.b1 * n;
            temp = this.b2;
            this.b2 = this.b12;
            this.b12 = temp + this.b12 * n;
        } else {
            let temp = this.a;
            this.a = this.a2;
            this.a2 = temp + this.a2 * n;
            temp = this.a1;
            this.a1 = this.a12;
            this.a12 = temp + this.a12 * n;
            temp = this.b;
            this.b = this.b2;
            this.b2 = temp + this.b2 * n;
            temp = this.b1;
            this.b1 = this.b12;
            this.b12 = temp + this.b12 * n;
        }
    }

    needsTerm() {
        if (this.b1 === 0 && this.b === 0 && this.b2 === 0 && this.b12 === 0) {
            return false;
        }

        if (this.b === 0) {
            this.configuration = this.b2 === 0 ? 0 : 1;
            return true;
        }
        this.ab = this.a / this.b;

        if (this.b2 === 0) {
            this.configuration = 1;
            return true;
        }
        this.a2b2 = this.a2 / this.b2;

        if (this.b1 === 0) {
            this.configuration = 0;
            return true;
        }
        this.a1b1 = this.a1 / this.b1;

        if (this.b12 === 0) {
            this.configuration = this.setConfiguration();
            return true;
        }
        this.a12b12 = this.a12 / this.b12;

        this.currentTerm = Math.floor(this.ab);
        if (this.currentTerm === Math.floor(this.a1b1) &&
            this.currentTerm === Math.floor(this.a2b2) &&
            this.currentTerm === Math.floor(this.a12b12)) {
            let temp = this.a;
            this.a = this.b;
            this.b = temp - this.b * this.currentTerm;
            temp = this.a1;
            this.a1 = this.b1;
            this.b1 = temp - this.b1 * this.currentTerm;
            temp = this.a2;
            this.a2 = this.b2;
            this.b2 = temp - this.b2 * this.currentTerm;
            temp = this.a12;
            this.a12 = this.b12;
            this.b12 = temp - this.b12 * this.currentTerm;

            this.hasTerm = true;
            return false;
        }
        this.configuration = this.setConfiguration();
        return true;
    }

    setConfiguration() {
        return Math.abs(this.a1b1 - this.ab) > Math.abs(this.a2b2 - this.ab) ? 0 : 1;
    }
}

class NG {
    constructor(matrixNG, cf1, cf2 = null) {
        this.matrixNG = matrixNG;
        this.cf = [cf1];
        if (cf2) this.cf.push(cf2);
    }

    hasMoreTerms() {
        while (this.matrixNG.needsTerm()) {
            if (this.cf[this.matrixNG.configuration].hasMoreTerms()) {
                this.matrixNG.consumeTermWithN(this.cf[this.matrixNG.configuration].nextTerm());
            } else {
                this.matrixNG.consumeTerm();
            }
        }
        return this.matrixNG.hasTerm;
    }

    nextTerm() {
        this.matrixNG.hasTerm = false;
        return this.matrixNG.currentTerm;
    }
}

function test(description, ...fractions) {
    console.log(`Testing: ${description}`);
    for (const fraction of fractions) {
        const terms = [];
        while (fraction.hasMoreTerms()) {
            terms.push(fraction.nextTerm());
        }
        console.log(terms.join(" "));
    }
    console.log();
}

function main() {
    test("[3; 7] + [0; 2]",
        new NG(new NG8(0, 1, 1, 0, 0, 0, 0, 1), new R2cf(1, 2), new R2cf(22, 7)),
        new NG(new NG4(2, 1, 0, 2), new R2cf(22, 7))
    );

    test("[1; 5, 2] * [3; 7]",
        new NG(new NG8(1, 0, 0, 0, 0, 0, 0, 1), new R2cf(13, 11), new R2cf(22, 7)),
        new R2cf(286, 77)
    );

    test("[1; 5, 2] - [3; 7]",
        new NG(new NG8(0, 1, -1, 0, 0, 0, 0, 1), new R2cf(13, 11), new R2cf(22, 7)),
        new R2cf(-151, 77)
    );

    test("Divide [] by [3; 7]",
        new NG(new NG8(0, 1, 0, 0, 0, 0, 1, 0), new R2cf(22 * 22, 7 * 7), new R2cf(22, 7))
    );

    test("([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])",
        new NG(new NG8(1, 0, 0, 0, 0, 0, 0, 1),
            new NG(new NG8(0, 1, 1, 0, 0, 0, 0, 1), new R2cf(2, 7), new R2cf(13, 11)),
            new NG(new NG8(0, 1, -1, 0, 0, 0, 0, 1), new R2cf(2, 7), new R2cf(13, 11))
        ),
        new R2cf(-7797, 5929)
    );
}

main();
