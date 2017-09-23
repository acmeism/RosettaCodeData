(() => {
    'use strict';

    // monteCarloPi :: Int -> Float
    const monteCarloPi = n =>
        4 * range(1, n)
        .reduce(a => {
            const [x, y] = [rnd(), rnd()];
            return x * x + y * y < 1 ? a + 1 : a;
        }, 0) / n;


    // GENERIC FUNCTIONS

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // rnd :: () -> Float
    const rnd = Math.random;


    // TEST with from 1000 samples to 10E8 samples
    return range(3, 8)
        .map(x => monteCarloPi(Math.pow(10, x)));

    // e.g. -> [3.14, 3.1404, 3.13304, 3.142408, 3.1420304, 3.14156788]
})();
