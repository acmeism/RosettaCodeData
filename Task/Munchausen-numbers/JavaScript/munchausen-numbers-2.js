(() => {
    'use strict';

    const main = () =>
        filter(isMunchausen, enumFromTo(1, 5000));

    // isMunchausen :: Int -> Bool
    const isMunchausen = n =>
        n.toString()
        .split('')
        .reduce(
            (a, c) => (
                d => a + Math.pow(d, d)
            )(parseInt(c, 10)),
            0
        ) === n;

    // GENERIC ---------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);


    // MAIN ---
    return main();
})();
