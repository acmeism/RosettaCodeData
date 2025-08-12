class ContinuedFractionArithmeticG1 {
    static main() {
        const cfData = [
            new CFData("[1; 5, 2] + 1 / 2", [2, 1, 0, 2], new R2cfIterator(13, 11)),
            new CFData("[3; 7] + 1 / 2", [2, 1, 0, 2], new R2cfIterator(22, 7)),
            new CFData("[3; 7] divided by 4", [1, 0, 0, 4], new R2cfIterator(22, 7)),
            new CFData("sqrt(2)", [0, 1, 1, 0], new ReciprocalRoot2()),
            new CFData("1 / sqrt(2)", [0, 1, 1, 0], new Root2()),
            new CFData("(1 + sqrt(2)) / 2", [1, 1, 0, 2], new Root2()),
            new CFData("(1 + 1 / sqrt(2)) / 2", [1, 1, 0, 2], new ReciprocalRoot2())
        ];


        for (const data of cfData) {
            process.stdout.write(data.text + " -> ");
            const ng = new NG(data.args);
            const iterator = data.iterator;
            let nextTerm = 0;

            for (let i = 1; i <= 20 && iterator.hasNext(); i++) {
                nextTerm = iterator.next();
                if (!ng.needsTerm()) {
                    process.stdout.write(ng.egress() + " ");
                }
                ng.ingress(nextTerm);
            }

            while (!ng.done()) {
                process.stdout.write(ng.egressDone() + " ");
            }
            console.log();
        }
    }
}

class NG {
    constructor(aArgs) {
        this.a1 = aArgs[0];
        this.a = aArgs[1];
        this.b1 = aArgs[2];
        this.b = aArgs[3];
    }

    ingress(aN) {
        let temp = this.a;
        this.a = this.a1;
        this.a1 = temp + this.a1 * aN;
        temp = this.b;
        this.b = this.b1;
        this.b1 = temp + this.b1 * aN;
    }

    egress() {
        const n = Math.floor(this.a / this.b);
        let temp = this.a;
        this.a = this.b;
        this.b = temp - this.b * n;
        temp = this.a1;
        this.a1 = this.b1;
        this.b1 = temp - this.b1 * n;
        return n;
    }

    needsTerm() {
        return (this.b === 0 || this.b1 === 0) || (this.a * this.b1 !== this.a1 * this.b);
    }

    egressDone() {
        if (this.needsTerm()) {
            this.a = this.a1;
            this.b = this.b1;
        }
        return this.egress();
    }

    done() {
        return (this.b === 0 || this.b1 === 0);
    }
}

class CFData {
    constructor(text, args, iterator) {
        this.text = text;
        this.args = args;
        this.iterator = iterator;
    }
}


class R2cfIterator {
    constructor(aNumerator, aDenominator) {
        this.numerator = aNumerator;
        this.denominator = aDenominator;
    }

    hasNext() {
        return this.denominator !== 0;
    }

    next() {
        const div = Math.floor(this.numerator / this.denominator);
        const rem = this.numerator % this.denominator;
        this.numerator = this.denominator;
        this.denominator = rem;
        return div;
    }
}

class Root2 {
    constructor() {
        this.firstReturn = true;
    }

    hasNext() {
        return true;
    }

    next() {
        if (this.firstReturn) {
            this.firstReturn = false;
            return 1;
        }
        return 2;
    }
}

class ReciprocalRoot2 {
    constructor() {
        this.firstReturn = true;
        this.secondReturn = true;
    }

    hasNext() {
        return true;
    }

    next() {
        if (this.firstReturn) {
            this.firstReturn = false;
            return 0;
        }
        if (this.secondReturn) {
            this.secondReturn = false;
            return 1;
        }
        return 2;
    }
}

ContinuedFractionArithmeticG1.main();
