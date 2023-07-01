(() => {
    'use strict';

    // co9 :: Int -> Int
    const co9 = n =>
        n <= 8 ? n : co9(
            digits(10, n)
            .reduce((a, x) => x !== 9 ? a + x : a, 0)
        );

    // GENERIC FUNCTIONS

    // digits :: Int -> Int -> [Int]
    const digits = (base, n) => {
        if (n < base) return [n];
        const [q, r] = quotRem(n, base);
        return [r].concat(digits(base, q));
    };

    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = (m, n) => [Math.floor(m / n), m % n];

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // squared :: Num a => a -> a
    const squared = n => Math.pow(n, 2);

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // TESTS
    return show({
        test1: co9(232345), //-> 1
        test2: co9(34234234), //-> 7
        test3: co9(232345 + 34234234) === co9(232345) + co9(34234234), //-> true
        test4: co9(232345 * 34234234) === co9(232345) * co9(34234234), //-> true,
        task2: range(1, 100)
            .filter(n => co9(n) === co9(squared(n))),
        task3: (k => range(1, 100)
            .filter(n => (n % k) === (squared(n) % k)))(16)
    });
})();
