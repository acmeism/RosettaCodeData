(() => {
    'use strict';

    // seriesSum :: Num a => (a -> a) -> [a] -> a
    const seriesSum = (f, xs) =>
        xs.reduce((a, x) => a + f(x), 0);


    // GENERIC ------------------------------------------

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TEST ----------------------------------------------

    return seriesSum(x => 1 / (x * x), range(1, 1000));
})();
