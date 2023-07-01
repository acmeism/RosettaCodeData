(() => {
    'use strict';

    // permutations :: [a] -> [[a]]
    const permutations = xs =>
        xs.reduceRight(
            (a, x) => concatMap(
                xs => enumFromTo(0, xs.length)
                .map(n => xs.slice(0, n)
                    .concat(x)
                    .concat(xs.slice(n))
                ),
                a
            ),
            [[]]
        );

    // GENERIC FUNCTIONS ----------------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // ft :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // TEST -----------------------------------------------
    showLog(
        permutations([1, 2, 3])
    );
})();
