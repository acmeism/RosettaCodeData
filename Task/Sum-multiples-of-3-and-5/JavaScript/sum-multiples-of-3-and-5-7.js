(() => {

    // Area under straight line
    // between first multiple and last.

    // sumMults :: Int -> Int -> Int
    const sumMults = (n, factor) => {
        const n1 = quot(n - 1, factor);
        return quot(factor * n1 * (n1 + 1), 2);
    };

    // sum35 :: Int -> Int
    const sum35 = n => sumMults(n, 3) + sumMults(n, 5) - sumMults(n, 15);


    // GENERIC ----------------------------------------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // Integral a => a -> a -> a
    const quot = (n, m) => Math.floor(n / m);

    // TEST -------------------------------------------------------------------

    // Sums for 10^1 thru 10^8
    return enumFromTo(1, 8)
        .map(n => Math.pow(10, n))
        .reduce((a, x) => (
            a[x.toString()] = sum35(x),
            a
        ), {});
})();
