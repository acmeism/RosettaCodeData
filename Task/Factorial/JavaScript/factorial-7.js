(function (n) {
    'use strict';

    // factorial :: Int -> Int
    let factorial = (n) => range(1, n).reduce(product, 1);


    // product :: Num -> Num -> Num
    let product = (a, b) => a * b,

        // range :: Int -> Int -> [Int]
        range = (m, n) =>
            Array.from({
                length: (n - m) + 1
            }, (_, i) => m + i)


    return factorial(n);

})(18);
