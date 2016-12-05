(() => {
    'use strict';

    // fib :: Int -> Int
    let fib = n => range(1, n)
        .reduce(([a, b]) => [b, a + b], [0, 1])[0];


    // GENERIC [m..n]

    // range :: Int -> Int -> [Int]
    let range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);


    // TEST
    return fib(32);

    // --> 2178309
})();
