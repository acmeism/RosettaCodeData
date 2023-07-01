(() => {
    'use strict';

    // sumOfSquares :: Num a => [a] -> a
    const sumOfSquares = xs =>
        sum(xs.map(squared));

    // sumOfSquares2 :: Num a => [a] -> a
    const sumOfSquares2 = xs =>
        xs.reduce((a, x) => a + squared(x), 0);


    // ---------------------- TEST -----------------------
    const main = () => [
        sumOfSquares,
        sumOfSquares2
    ].map(
        f => f([3, 1, 4, 1, 5, 9])
    ).join('\n');


    // --------------------- GENERIC ---------------------

    // squared :: Num a => a -> a
    const squared = x =>
        Math.pow(x, 2);

    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);

    // MAIN ---
    return main();
})();
