(() => {
    "use strict";

    // Arguments: predicate, maximum perimeter
    // pythTripleCount :: ((Int, Int, Int) -> Bool) -> Int -> Int
    const pythTripleCount = p =>
        maxPerim => {
            const
                xs = enumFromTo(1)(
                    Math.floor(maxPerim / 2)
                );

            return xs.flatMap(
                x => xs.slice(x).flatMap(
                    y => xs.slice(y).flatMap(
                        z => ((x + y + z <= maxPerim) &&
                            ((x * x) + (y * y) === z * z) &&
                            p(x, y, z)) ? [
                            [x, y, z]
                        ] : []
                    )
                )
            ).length;
        };

    // ---------------------- TEST -----------------------
    const main = () => [10, 100, 1000]
        .map(n => ({
            maxPerimeter: n,
            triples: pythTripleCount(() => true)(n),
            primitives: pythTripleCount(
                (x, y) => gcd(x)(y) === 1
            )(n)
        }));


    // ---------------- GENERIC FUNCTIONS ----------------

    // abs :: Num -> Num
    const abs =
        // Absolute value of a given number
        // without the sign.
        x => 0 > x ? (
            -x
        ) : x;


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // gcd :: Integral a => a -> a -> a
    const gcd = x =>
        y => {
            const zero = x.constructor(0);
            const go = (a, b) =>
                zero === b ? (
                    a
                ) : go(b, a % b);

            return go(abs(x), abs(y));
        };

    // MAIN ---
    return main();
})();
