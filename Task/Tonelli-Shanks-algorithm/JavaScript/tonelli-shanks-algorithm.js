class TonelliShanks {
    static ts(n, p) {
        // Convert to BigInt if not already
        n = typeof n === 'bigint' ? n : BigInt(n);
        p = typeof p === 'bigint' ? p : BigInt(p);

        const ZERO = BigInt(0);
        const ONE = BigInt(1);
        const TWO = BigInt(2);

        // Helper function for modular exponentiation
        const powModP = (a, e) => {
            let result = BigInt(1);
            a = a % p;
            while (e > ZERO) {
                if (e % TWO === ONE) {
                    result = (result * a) % p;
                }
                e = e / TWO;
                a = (a * a) % p;
            }
            return result;
        };

        // Legendre symbol calculation
        const ls = (a) => powModP(a, (p - ONE) / TWO);

        if (ls(n) !== ONE) return { root1: ZERO, root2: ZERO, exists: false };

        let q = p - ONE;
        let ss = ZERO;
        while (q % TWO === ZERO) {
            ss += ONE;
            q /= TWO;
        }

        if (ss === ONE) {
            const r1 = powModP(n, (p + ONE) / BigInt(4));
            return { root1: r1, root2: p - r1, exists: true };
        }

        let z = TWO;
        while (ls(z) !== p - ONE) z += ONE;

        let c = powModP(z, q);
        let r = powModP(n, (q + ONE) / TWO);
        let t = powModP(n, q);
        let m = ss;

        while (true) {
            if (t === ONE) return { root1: r, root2: p - r, exists: true };

            let i = ZERO;
            let zz = t;
            while (zz !== ONE && i < m - ONE) {
                zz = (zz * zz) % p;
                i += ONE;
            }

            let b = c;
            let e = m - i - ONE;
            while (e > ZERO) {
                b = (b * b) % p;
                e -= ONE;
            }

            r = (r * b) % p;
            c = (b * b) % p;
            t = (t * c) % p;
            m = i;
        }
    }
}

// Main function
function main() {
    const pairs = [
        [10n, 13n],
        [56n, 101n],
        [1030n, 10009n],
        [1032n, 10009n],
        [44402n, 100049n],
        [665820697n, 1000000009n],
        [881398088036n, 1000000000039n]
    ];

    for (const [n, p] of pairs) {
        const sol = TonelliShanks.ts(n, p);
        console.log(`n = ${n}`);
        console.log(`p = ${p}`);
        if (sol.exists) {
            console.log(`root1 = ${sol.root1}`);
            console.log(`root2 = ${sol.root2}`);
        } else {
            console.log("No solution exists");
        }
        console.log();
    }

    const bn = 41660815127637347468140745042827704103445750172002n;
    const bp = BigInt(10) ** 50n + 577n;
    const sol = TonelliShanks.ts(bn, bp);
    console.log(`n = ${bn}`);
    console.log(`p = ${bp}`);
    if (sol.exists) {
        console.log(`root1 = ${sol.root1}`);
        console.log(`root2 = ${sol.root2}`);
    } else {
        console.log("No solution exists");
    }
}

main();
