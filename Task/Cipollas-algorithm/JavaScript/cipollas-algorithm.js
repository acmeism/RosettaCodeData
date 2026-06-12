class Point {
    constructor(x, y) {
        this.x = x;
        this.y = y;
    }

    toString() {
        return `(${this.x}, ${this.y})`;
    }
}

class Triple {
    constructor(x, y, b) {
        this.x = x;
        this.y = y;
        this.b = b;
    }

    toString() {
        return `(${this.x}, ${this.y}, ${this.b})`;
    }
}

const BIG = 10n ** 50n + 151n;
const BIG_TWO = 2n;

function modPow(base, exp, mod) {
    if (exp === 0n) return 1n;
    if (mod === 1n) return 0n;

    base = base % mod;
    let result = 1n;
    while (exp > 0n) {
        if (exp & 1n) {
            result = (result * base) % mod;
        }
        exp = exp >> 1n;
        base = (base * base) % mod;
    }
    return result;
}

function c(ns, ps) {
    const n = BigInt(ns);
    const p = ps !== "" ? BigInt(ps) : BIG;

    // Legendre symbol, returns 1, 0 or p - 1
    const ls = (a) => modPow(a, (p - 1n) / BIG_TWO, p);

    // Step 0, validate arguments
    if (ls(n) !== 1n) {
        return new Triple(0n, 0n, false);
    }

    // Step 1, find a, omega2
    let a = 0n;
    let omega2;
    while (true) {
        omega2 = ((a * a) + p - n) % p;
        if (ls(omega2) === p - 1n) {
            break;
        }
        a = a + 1n;
    }

    // multiplication in Fp2
    const finalOmega = omega2;
    const mul = (aa, bb) => new Point(
        (aa.x * bb.x + aa.y * bb.y * finalOmega) % p,
        (aa.x * bb.y + bb.x * aa.y) % p
    );

    // Step 2, compute power
    let r = new Point(1n, 0n);
    let s = new Point(a, 1n);
    let nn = ((p + 1n) >> 1n) % p;

    while (nn > 0n) {
        if (nn & 1n) {
            r = mul(r, s);
        }
        s = mul(s, s);
        nn = nn >> 1n;
    }

    // Step 3, check x in Fp
    if (r.y !== 0n) {
        return new Triple(0n, 0n, false);
    }

    // Step 5, check x * x = n
    if ((r.x * r.x) % p !== n) {
        return new Triple(0n, 0n, false);
    }

    // Step 4, solutions
    return new Triple(r.x, p - r.x, true);
}

// Test cases
console.log(c("10", "13").toString());
console.log(c("56", "101").toString());
console.log(c("8218", "10007").toString());
console.log(c("8219", "10007").toString());
console.log(c("331575", "1000003").toString());
console.log(c("665165880", "1000000007").toString());
console.log(c("881398088036", "1000000000039").toString());
console.log(c("34035243914635549601583369544560650254325084643201", "").toString());
