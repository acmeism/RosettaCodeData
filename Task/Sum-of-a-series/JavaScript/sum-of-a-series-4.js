(() => {
    'use strict';

    // SUM OF A SERIES -------------------------------------------------------

    // seriesSum :: Num a => (a -> a) -> [a] -> a
    const seriesSum = (f, xs) =>
        foldl((a, x) => a + f(x), 0, xs);


    // GENERIC ---------------------------------------------------------------

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // TEST ------------------------------------------------------------------

    return seriesSum(x => 1 / (x * x), enumFromTo(1, 1000));
})();
