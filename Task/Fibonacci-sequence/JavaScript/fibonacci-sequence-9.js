(() => {
    'use strict';

    // Nth member of fibonacci series

    // fib :: Int -> Int
    function fib(n) {
        return mapAccumL(([a, b]) => [
            [b, a + b], b
        ], [0, 1], range(1, n))[0][0];
    };

    // GENERIC FUNCTIONS

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    let mapAccumL = (f, acc, xs) => {
        return xs.reduce((a, x) => {
            let pair = f(a[0], x);

            return [pair[0], a[1].concat(pair[1])];
        }, [acc, []]);
    }

    // range :: Int -> Int -> Maybe Int -> [Int]
    let range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);


    // TEST
    return fib(32);

    // --> 2178309
})();
