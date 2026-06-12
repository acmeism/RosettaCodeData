class RE {
    equals(other) {
        return other instanceof this.constructor && this.dictEquals(other);
    }

    dictEquals(other) {
        const keys1 = Object.keys(this);
        const keys2 = Object.keys(other);
        if (keys1.length !== keys2.length) return false;
        for (let key of keys1) {
            if (this[key] !== other[key]) return false;
        }
        return true;
    }
}

class Empty extends RE {
    toString() {
        return "0";
    }
}

const empty = new Empty();

class Epsilon extends RE {
    toString() {
        return "1";
    }
}

const epsilon = new Epsilon();

class Car extends RE {
    constructor(c) {
        super();
        this.c = c;
    }

    toString() {
        return this.c;
    }

    equals(other) {
        return other instanceof Car && this.c === other.c;
    }
}

class Union extends RE {
    constructor(e, f) {
        super();
        this.e = e;
        this.f = f;
    }

    toString() {
        return `${this.e}+${this.f}`;
    }

    equals(other) {
        return other instanceof Union && this.e.equals(other.e) && this.f.equals(other.f);
    }
}

class Concat extends RE {
    constructor(e, f) {
        super();
        this.e = e;
        this.f = f;
    }

    toString() {
        return `(${this.e})(${this.f})`;
    }

    equals(other) {
        return other instanceof Concat && this.e.equals(other.e) && this.f.equals(other.f);
    }
}

class Star extends RE {
    constructor(e) {
        super();
        this.e = e;
    }

    toString() {
        return `(${this.e})*`;
    }

    equals(other) {
        return other instanceof Star && this.e.equals(other.e);
    }
}

function simpleRe(e) {
    function simple(e) {
        if (e instanceof Union) {
            const e_e = simple(e.e);
            const e_f = simple(e.f);
            if (e_e.equals(e_f)) {
                return e_e;
            } else if (e_e.equals(empty)) {
                return e_f;
            } else if (e_f.equals(empty)) {
                return e_e;
            } else if (e_e instanceof Union) {
                return simple(new Union(e_e.e, new Union(e_e.f, e_f)));
            } else {
                return new Union(e_e, e_f);
            }
        } else if (e instanceof Concat) {
            const e_e = simple(e.e);
            const e_f = simple(e.f);
            if (e_e.equals(epsilon)) {
                return e_f;
            } else if (e_f.equals(epsilon)) {
                return e_e;
            } else if (e_e.equals(empty) || e_f.equals(empty)) {
                return empty;
            } else if (e_e instanceof Concat) {
                return simple(new Concat(e_e.e, new Concat(e_e.f, e_f)));
            } else {
                return new Concat(e_e, e_f);
            }
        } else if (e instanceof Star) {
            const e_e = simple(e.e);
            if (e_e instanceof Empty || e_e instanceof Epsilon) {
                return epsilon;
            } else {
                return new Star(e_e);
            }
        } else {
            return e;
        }
    }

    let prevE = null;
    while (!e.equals(prevE)) {
        prevE = e;
        e = simple(e);
    }
    return e;
}

function brzozowski(a, b) {
    const m = a.length;
    for (let n = m - 1; n >= 0; n--) {
        const a_nn = a[n][n];
        b[n] = new Concat(new Star(a_nn), b[n]);
        for (let j = 0; j < n; j++) {
            a[n][j] = new Concat(new Star(a_nn), a[n][j]);
        }
        for (let i = 0; i < n; i++) {
            b[i] = new Union(b[i], new Concat(a[i][n], b[n]));
            for (let j = 0; j < n; j++) {
                a[i][j] = new Union(a[i][j], new Concat(a[i][n], a[n][j]));
            }
        }
        for (let i = 0; i < n; i++) {
            a[i][n] = empty;
        }
    }
    return b[0];
}

const a = [
    [empty, new Car('a'), new Car('b')],
    [new Car('b'), empty, new Car('a')],
    [new Car('a'), new Car('b'), empty],
];

const b = [epsilon, empty, empty];

const re = brzozowski(a, b);
console.log(re.toString());
console.log();
console.log(simpleRe(re).toString());
