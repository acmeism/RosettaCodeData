(() => {
    'use strict';

    // sum :: (Num a) => [a] -> a
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // product :: (Num a) => [a] -> a
    const product = xs => xs.reduce((a, x) => a * x, 1);


    // TEST
    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    return show(
        [sum, product]
        .map(f => f([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
    );
})();
