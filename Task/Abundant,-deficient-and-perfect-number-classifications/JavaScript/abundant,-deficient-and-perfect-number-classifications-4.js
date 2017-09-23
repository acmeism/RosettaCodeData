(() => {
    'use strict';

    const
    // divisors :: (Integral a) => a -> [a]
        divisors = n => range(1, Math.floor(n / 2))
            .filter(x => n % x === 0),

        // classOf :: (Integral a) => a -> Ordering
        classOf = n => compare(divisors(n)
            .reduce((a, b) => a + b, 0), n),

        classTypes = {
            deficient: -1,
            perfect: 0,
            abundant: 1
        };

    // GENERIC FUNCTIONS
    const
    // compare :: Ord a => a -> a -> Ordering
        compare = (a, b) =>
            a < b ? -1 : (a > b ? 1 : 0),

        // range :: Int -> Int -> [Int]
        range = (m, n) =>
            Array.from({
                length: Math.floor(n - m) + 1
            }, (_, i) => m + i);

    // TEST

    // classes :: [Ordering]
    const classes = range(1, 20000)
        .map(classOf);

    return Object.keys(classTypes)
        .map(k => k + ": " + classes
            .filter(x => x === classTypes[k])
            .length.toString())
        .join('\n');
})();
