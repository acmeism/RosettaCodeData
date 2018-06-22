(() => {
    'use strict';

    // factorial :: Int -> Int
    const factorial = n =>
        enumFromTo(1, n)
        .reduce(product, 1);


    const test = () =>
        factorial(18);
    // --> 6402373705728000


    // GENERIC FUNCTIONS ----------------------------------

    // product :: Num -> Num -> Num
    const product = (a, b) => a * b;

    // range :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: (n - m) + 1
        }, (_, i) => m + i);

    // MAIN ------
    return test();
})();
