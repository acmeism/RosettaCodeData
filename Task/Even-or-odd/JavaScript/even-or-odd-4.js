(() => {
    'use strict';

    // even : Integral a => a -> Bool
    const even = x => (x % 2) === 0;

    // odd : Integral a => a -> Bool
    const odd = x => !even(x);


    // TEST ----------------------------------------
    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // show :: a -> String
    const show = JSON.stringify;

    // xs :: [Int]
    const xs = range(-6, 6);

    return show([xs.filter(even), xs.filter(odd)]);
})();
