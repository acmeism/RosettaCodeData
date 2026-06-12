(() => {
    "use strict";

    // ------------------ CALMO NUMBERS ------------------

    // isCalmo :: Int -> Bool
    const isCalmo = n => {
        const
            ds = properDivisors(n),
            nd = ds.length;

        return 3 < nd && (
            0 === (nd - 1) % 3
        ) && chunksOf(3)(ds.slice(1)).every(
            triple => isPrime(sum(triple))
        );
    };

    // ---------------------- TEST -----------------------
    const main = () =>
        enumFromTo(1)(1000).filter(
            isCalmo
        );


    // --------------------- GENERIC ---------------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const chunk = xs.slice(0, n);

            return 0 < chunk.length
                ? [chunk, ...go(xs.slice(n))]
                : [];
        };

        return go;
    };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = m =>
        // Integer values enumerated from m to n
        // with a step defined by (nxt - m).
        nxt => n => {
            const d = nxt - m;

            return Array.from({
                length: (Math.floor(n - nxt) / d) + 2
            }, (_, i) => m + (d * i));
        };


    // isPrime :: Int -> Bool
    const isPrime = n => {
        // True if n is prime.
        if (n === 2 || n === 3) {
            return true;
        }
        if (2 > n || 0 === (n % 2)) {
            return false;
        }
        if (9 > n) {
            return true;
        }
        if (0 === (n % 3)) {
            return false;
        }

        const p = x =>
            0 === n % x || 0 === (n % (2 + x));

        return !enumFromThenTo(5)(11)(1 + Math.sqrt(n))
        .some(p);
    };


    // properDivisors :: Int -> [Int]
    const properDivisors = n => {
        const
            rRoot = Math.sqrt(n),
            intRoot = Math.floor(rRoot),
            lows = enumFromTo(1)(intRoot)
            .filter(x => 0 === (n % x));

        return lows.concat(
            lows.map(x => n / x)
            .reverse()
            .slice(
                rRoot === intRoot
                    ? 1
                    : 0,
                -1
            )
        );
    };


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // MAIN ---
    return JSON.stringify(main());
})();
