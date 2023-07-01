(() => {
    'use strict';

    // ------------------ COMBINATIONS -------------------

    // combinations :: Int -> [a] -> [[a]]
    const combinations = n =>
        xs => {
            const comb = n => xs => {
                return 1 > n ? [
                    []
                ] : 0 === xs.length ? (
                    []
                ) : (() => {
                    const
                        h = xs[0],
                        tail = xs.slice(1);
                    return comb(n - 1)(tail)
                        .map(cons(h))
                        .concat(comb(n)(tail));
                })()
            };
            return comb(n)(xs);
        };

    // ---------------------- TEST -----------------------
    const main = () =>
        show(
            combinations(3)(
                enumFromTo(0)(4)
            )
        );


    // ---------------- GENERIC FUNCTIONS ----------------

    // cons :: a -> [a] -> [a]
    const cons = x =>
        // A list constructed from the item x,
        // followed by the existing list xs.
        xs => [x].concat(xs);


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[0], null, x[1]] : x
        );

    // MAIN ---
    return main();
})();
