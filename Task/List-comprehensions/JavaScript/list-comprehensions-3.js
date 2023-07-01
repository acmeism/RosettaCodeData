(n => {
    'use strict';

    // GENERIC FUNCTIONS ------------------------------------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);


    // EXAMPLE ----------------------------------------------------------------

    // [(x, y, z) | x <- [1..n], y <- [x..n], z <- [y..n], x ^ 2 + y ^ 2 == z ^ 2]

    return concatMap(x =>
           concatMap(y =>
           concatMap(z =>

                x * x + y * y === z * z ? [
                    [x, y, z]
                ] : [],

           enumFromTo(y, n)),
           enumFromTo(x, n)),
           enumFromTo(1, n));
})(20);
